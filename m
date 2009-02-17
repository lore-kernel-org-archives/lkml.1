Return-Path: <linux-kernel-owner+w=401wt.eu-S1751180AbZBQFPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbZBQFPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZBQFOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZBQFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:07 -0500
Message-Id: <20090217051405.538980274@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/15] ftrace: rename ftrace_match to ftrace_match_records
Content-Disposition: inline; filename=0003-ftrace-rename-ftrace_match-to-ftrace_match_records.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

ftrace_match is too generic of a name. What it really does is
search all records and matches the records with the given string,
and either sets or unsets the functions to be traced depending
on if the parameter 'enable' is set or not.

This allows us to make another function called ftrace_match that
can be used to test a single record.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fed1ebc..f397d7a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1054,7 +1054,7 @@ enum {
 };
 
 static void
-ftrace_match(unsigned char *buff, int len, int enable)
+ftrace_match_records(unsigned char *buff, int len, int enable)
 {
 	char str[KSYM_SYMBOL_LEN];
 	char *search = NULL;
@@ -1197,7 +1197,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	if (isspace(ch)) {
 		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match(iter->buffer, iter->buffer_idx, enable);
+		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 		iter->buffer_idx = 0;
 	} else
 		iter->flags |= FTRACE_ITER_CONT;
@@ -1236,7 +1236,7 @@ ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
 	if (reset)
 		ftrace_filter_reset(enable);
 	if (buf)
-		ftrace_match(buf, len, enable);
+		ftrace_match_records(buf, len, enable);
 	mutex_unlock(&ftrace_regex_lock);
 }
 
@@ -1286,7 +1286,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	if (iter->buffer_idx) {
 		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match(iter->buffer, iter->buffer_idx, enable);
+		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 	}
 
 	mutex_lock(&ftrace_sysctl_lock);
-- 
1.5.6.5

-- 
