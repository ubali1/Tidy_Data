
## use read.table to load the text files using header = FALSE argument to ensure similar row numbers

## Load data for test dataset into R

y_test <- read.table("./y_test.txt", header = FALSE)
colnames(y_test) <- "activity" ## Assign colname 'activity' to this table

subject_test <- read.table("./subject_test.txt", header = FALSE)
colnames(subject_test) <- "subject" ## Assign colname 'subject' to this table

X_test <- read.table("./X_test.txt", header = FALSE)
features <- read.table("./features.txt") ## read table containing names for X_test column
X_test_names <- features[,2] ## extract column 2 containing all the column names for X_test column
as.character(X_test_names) ## convert the names to 'character'
colnames(X_test) <- X_test_names ## apply the names to X_test

X_test_bound <- cbind(X_test, subject_test, y_test) ## column bind the subjet and activity tables into the X_test table


## Load data for 'train' dataset into R

y_train <- read.table("./y_train.txt", header = FALSE)
colnames(y_train) <- "activity" ## Assign colname 'activity' to this table

subject_train <- read.table("./subject_train.txt", header = FALSE)
colnames(subject_train) <- "subject" ## Assign colname 'subject' to this table

X_train <- read.table("./X_train.txt", header = FALSE)
## features <- read.table("./features.txt") ## read table containing names for X_train column
X_train_names <- features[,2] ## extract column 2 containing all the column names for X_train column
as.character(X_train_names) ## convert the names to 'character'
colnames(X_train) <- X_train_names ## apply the names to X_train

X_train_bound <- cbind(X_train, subject_train, y_train) ## column bind the subjet and activity tables into the X_train table

mergeData <- rbind(X_test_bound, X_train_bound) ## merge the two data sets using rbind function 

## the 'contains' function in dplyr select function does not work so use grep
## have to use // to escape the parenthesis else grep will pick up more columns
mergeData_subset <- mergeData[,grep('subject|activity|mean\\(\\)|std\\(\\)', colnames(mergeData))]

## attaching descriptive activity names to name the activities in the data set
mergeData_subset$activity[which(mergeData_subset$activity == "1")] <- "WALKING"
mergeData_subset$activity[which(mergeData_subset$activity == "2")] <- "WALKING_UPSTAIRS"
mergeData_subset$activity[which(mergeData_subset$activity == "3")] <- "WALKING_DOWNSTAIRS"
mergeData_subset$activity[which(mergeData_subset$activity == "4")] <- "SITTING"
mergeData_subset$activity[which(mergeData_subset$activity == "5")] <- "STANDING"
mergeData_subset$activity[which(mergeData_subset$activity == "6")] <- "LAYING"


## going to combing the following two statements of code below into a pipeline code as follows:
#by_subject <- group_by(mergeData_subset, subject)
#summarize <- summarise_each(by_subject, funs(mean), vars=-(activity))

# activity variable is excluded from summarize_each function to avoid warnings generated from a character column

summary_data <- mergeData_subset %>% group_by(subject, activity) %>% summarise_each(funs(mean), vars=-(activity))

## Write the summary_data into home directory as a *.csv file with same name
write.table(summary_data, file = "./summary_data.txt", sep = ",", row.names = FALSE)

## Use the following code to view the summary_data in RStudio
## View(read.table("./summary_data.txt", header = TRUE, sep = ","))

