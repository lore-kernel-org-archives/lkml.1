Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZBQSVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZBQSVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZBQSV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182125.103493869@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/6] ftrace: clean up coding style
Content-Disposition: inline; filename=0001-ftrace-clean-up-coding-style.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar pointed out some coding style issues with the recent ftrace
updates. This patch cleans them up.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c          |   24 +++++++++++++-----------
 kernel/trace/trace_functions.c |    1 -
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4e6c87e..af9d95c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -460,8 +460,8 @@ static void ftrace_bug(int failed, unsigned long ip)
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
-	unsigned long ip, fl;
 	unsigned long ftrace_addr;
+	unsigned long ip, fl;
 
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
@@ -530,9 +530,9 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
 static void ftrace_replace_code(int enable)
 {
-	int failed;
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
+	int failed;
 
 	do_for_each_ftrace_rec(pg, rec) {
 		/*
@@ -1208,14 +1208,15 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 
 static void ftrace_match_records(char *buff, int len, int enable)
 {
-	char *search;
+	unsigned int search_len;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
+	unsigned long flag;
+	char *search;
 	int type;
-	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	unsigned search_len;
 	int not;
 
+	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	type = ftrace_setup_glob(buff, len, &search, &not);
 
 	search_len = strlen(search);
@@ -1263,14 +1264,16 @@ ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
 
 static void ftrace_match_module_records(char *buff, char *mod, int enable)
 {
-	char *search = buff;
+	unsigned search_len = 0;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	int type = MATCH_FULL;
-	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	unsigned search_len = 0;
+	char *search = buff;
+	unsigned long flag;
 	int not = 0;
 
+	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
+
 	/* blank or '*' mean the same */
 	if (strcmp(buff, "*") == 0)
 		buff[0] = 0;
@@ -1442,8 +1445,8 @@ register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 	struct ftrace_func_hook *entry;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
-	unsigned long key;
 	int type, len, not;
+	unsigned long key;
 	int count = 0;
 	char *search;
 
@@ -1623,8 +1626,8 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd)
 
 static int ftrace_process_regex(char *buff, int len, int enable)
 {
-	struct ftrace_func_command *p;
 	char *func, *command, *next = buff;
+	struct ftrace_func_command *p;
 	int ret = -EINVAL;
 
 	func = strsep(&next, ":");
@@ -2392,7 +2395,6 @@ static __init int ftrace_init_debugfs(void)
 			   "'set_ftrace_pid' entry\n");
 	return 0;
 }
-
 fs_initcall(ftrace_init_debugfs);
 
 /**
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index f520aa4..021a574 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -397,6 +397,5 @@ static __init int init_function_trace(void)
 	init_func_cmd_traceon();
 	return register_tracer(&function_trace);
 }
-
 device_initcall(init_function_trace);
 
-- 
1.5.6.5

-- 
