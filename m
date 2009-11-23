Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZKWLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZKWLxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZKWLxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:53:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:56056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271AbZKWLxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:53:49 -0500
Date: Mon, 23 Nov 2009 11:53:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing, function tracer: Clean up strstrip() usage
Message-ID: <tip-457dc928f586f3f4b930206965e6db270034e97e@git.kernel.org>
Git-Commit-ID: 457dc928f586f3f4b930206965e6db270034e97e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  457dc928f586f3f4b930206965e6db270034e97e
Gitweb:     http://git.kernel.org/tip/457dc928f586f3f4b930206965e6db270034e97e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Nov 2009 11:03:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:04:07 +0100

tracing, function tracer: Clean up strstrip() usage

Clean up strstrip() usage - which also addresses this build warning:

  kernel/trace/ftrace.c: In function 'ftrace_pid_write':
  kernel/trace/ftrace.c:3004: warning: ignoring return value of 'strstrip', declared with attribute warn_unused_result

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7f9b51e..1dc101d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2985,7 +2985,7 @@ static ssize_t
 ftrace_pid_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
-	char buf[64];
+	char buf[64], *tmp;
 	long val;
 	int ret;
 
@@ -3001,11 +3001,11 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	 * Allow "echo > set_ftrace_pid" or "echo -n '' > set_ftrace_pid"
 	 * to clean the filter quietly.
 	 */
-	strstrip(buf);
-	if (strlen(buf) == 0)
+	tmp = strstrip(buf);
+	if (strlen(tmp) == 0)
 		return 1;
 
-	ret = strict_strtol(buf, 10, &val);
+	ret = strict_strtol(tmp, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -3391,4 +3391,3 @@ void ftrace_graph_stop(void)
 	ftrace_stop();
 }
 #endif
-
