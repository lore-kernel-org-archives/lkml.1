Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXIEEY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXIEEY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 00:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXIEEYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 00:24:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30781 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXIEEYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 00:24:20 -0400
Date: Tue, 4 Sep 2007 21:23:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: [PATCH] docproc: style & typo cleanups
Message-Id: <20070904212322.cd5ba596.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

- fix typos/spellos in docproc.c and Makefile
- add a little whitespace {while, switch} (coding style)
- use NULL instead of 0 for pointer testing

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/basic/Makefile  |    8 ++++----
 scripts/basic/docproc.c |   34 ++++++++++++++++++----------------
 2 files changed, 22 insertions(+), 20 deletions(-)

--- linux-2.6.23-rc5.orig/scripts/basic/docproc.c
+++ linux-2.6.23-rc5/scripts/basic/docproc.c
@@ -10,8 +10,10 @@
  *	documentation-frontend
  *		Scans the template file and call kernel-doc for
  *		all occurrences of ![EIF]file
- *		Beforehand each referenced file are scanned for
- *		any exported sympols "EXPORT_SYMBOL()" statements.
+ *		Beforehand each referenced file is scanned for
+ *		any symbols that are exported via these macros:
+ *			EXPORT_SYMBOL(), EXPORT_SYMBOL_GPL(), &
+ *			EXPORT_SYMBOL_GPL_FUTURE()
  *		This is used to create proper -function and
  *		-nofunction arguments in calls to kernel-doc.
  *		Usage: docproc doc file.tmpl
@@ -73,7 +75,7 @@ void usage (void)
 }
 
 /*
- * Execute kernel-doc with parameters givin in svec
+ * Execute kernel-doc with parameters given in svec
  */
 void exec_kernel_doc(char **svec)
 {
@@ -82,7 +84,7 @@ void exec_kernel_doc(char **svec)
 	char real_filename[PATH_MAX + 1];
 	/* Make sure output generated so far are flushed */
 	fflush(stdout);
-	switch(pid=fork()) {
+	switch (pid=fork()) {
 		case -1:
 			perror("fork");
 			exit(1);
@@ -133,6 +135,7 @@ struct symfile * add_new_file(char * fil
 	symfilelist[symfilecnt++].filename = strdup(filename);
 	return &symfilelist[symfilecnt - 1];
 }
+
 /* Check if file already are present in the list */
 struct symfile * filename_exist(char * filename)
 {
@@ -156,8 +159,8 @@ void noaction2(char * file, char * line)
 void printline(char * line)               { printf("%s", line); }
 
 /*
- * Find all symbols exported with EXPORT_SYMBOL and EXPORT_SYMBOL_GPL
- * in filename.
+ * Find all symbols in filename that are exported with EXPORT_SYMBOL &
+ * EXPORT_SYMBOL_GPL (& EXPORT_SYMBOL_GPL_FUTURE implicitly).
  * All symbols located are stored in symfilelist.
  */
 void find_export_symbols(char * filename)
@@ -179,15 +182,15 @@ void find_export_symbols(char * filename
 			perror(real_filename);
 			exit(1);
 		}
-		while(fgets(line, MAXLINESZ, fp)) {
+		while (fgets(line, MAXLINESZ, fp)) {
 			char *p;
 			char *e;
-			if (((p = strstr(line, "EXPORT_SYMBOL_GPL")) != 0) ||
-                            ((p = strstr(line, "EXPORT_SYMBOL")) != 0)) {
+			if (((p = strstr(line, "EXPORT_SYMBOL_GPL")) != NULL) ||
+                            ((p = strstr(line, "EXPORT_SYMBOL")) != NULL)) {
 				/* Skip EXPORT_SYMBOL{_GPL} */
 				while (isalnum(*p) || *p == '_')
 					p++;
-				/* Remove paranteses and additional ws */
+				/* Remove parentheses & additional whitespace */
 				while (isspace(*p))
 					p++;
 				if (*p != '(')
@@ -211,7 +214,7 @@ void find_export_symbols(char * filename
  * Document all external or internal functions in a file.
  * Call kernel-doc with following parameters:
  * kernel-doc -docbook -nofunction function_name1 filename
- * function names are obtained from all the src files
+ * Function names are obtained from all the src files
  * by find_export_symbols.
  * intfunc uses -nofunction
  * extfunc uses -function
@@ -262,7 +265,7 @@ void singfunc(char * filename, char * li
 	vec[idx++] = KERNELDOC;
 	vec[idx++] = DOCBOOK;
 
-        /* Split line up in individual parameters preceeded by FUNCTION */
+        /* Split line up in individual parameters preceded by FUNCTION */
         for (i=0; line[i]; i++) {
                 if (isspace(line[i])) {
                         line[i] = '\0';
@@ -292,7 +295,7 @@ void parse_file(FILE *infile)
 {
 	char line[MAXLINESZ];
 	char * s;
-	while(fgets(line, MAXLINESZ, infile)) {
+	while (fgets(line, MAXLINESZ, infile)) {
 		if (line[0] == '!') {
 			s = line + 2;
 			switch (line[1]) {
@@ -351,9 +354,9 @@ int main(int argc, char *argv[])
 	{
 		/* Need to do this in two passes.
 		 * First pass is used to collect all symbols exported
-		 * in the various files.
+		 * in the various files;
 		 * Second pass generate the documentation.
-		 * This is required because function are declared
+		 * This is required because some functions are declared
 		 * and exported in different files :-((
 		 */
 		/* Collect symbols */
@@ -396,4 +399,3 @@ int main(int argc, char *argv[])
 	fflush(stdout);
 	return exitstatus;
 }
-
--- linux-2.6.23-rc5.orig/scripts/basic/Makefile
+++ linux-2.6.23-rc5/scripts/basic/Makefile
@@ -1,13 +1,13 @@
 ###
-# Makefile.basic list the most basic programs used during the build process.
-# The programs listed herein is what is needed to do the basic stuff,
-# such as fix dependency file.
+# Makefile.basic lists the most basic programs used during the build process.
+# The programs listed herein are what are needed to do the basic stuff,
+# such as fix file dependencies.
 # This initial step is needed to avoid files to be recompiled
 # when kernel configuration changes (which is what happens when
 # .config is included by main Makefile.
 # ---------------------------------------------------------------------------
 # fixdep: 	 Used to generate dependency information during build process
-# docproc:	 Used in Documentation/docbook
+# docproc:	 Used in Documentation/DocBook
 
 hostprogs-y	:= fixdep docproc
 always		:= $(hostprogs-y)
