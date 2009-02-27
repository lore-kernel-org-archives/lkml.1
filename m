Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZB0FfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZB0FfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZB0Feq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053443.046086116@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] tracing: use newline separator for trace options list
Content-Disposition: inline; filename=0005-tracing-use-newline-separator-for-trace-options-lis.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Instead of listing the trace options like:

 # cat /debug/tracing/trace_options
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate nouserstacktrace nosym-userobj

We now list them like:

 # cat /debug/tracing/trace_options
print-parent
nosym-offset
nosym-addr
noverbose
noraw
nohex
nobin
noblock
nostacktrace
nosched-tree
ftrace_printk
noftrace_preempt
nobranch
annotate
nouserstacktrace
nosym-userobj

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 304e02c..5db7485 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2037,7 +2037,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	/* calculate max size */
 	for (i = 0; trace_options[i]; i++) {
 		len += strlen(trace_options[i]);
-		len += 3; /* "no" and space */
+		len += 3; /* "no" and newline */
 	}
 
 	mutex_lock(&trace_types_lock);
@@ -2050,7 +2050,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	 */
 	for (i = 0; trace_opts[i].name; i++) {
 		len += strlen(trace_opts[i].name);
-		len += 3; /* "no" and space */
+		len += 3; /* "no" and newline */
 	}
 
 	/* +2 for \n and \0 */
@@ -2062,22 +2062,21 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 
 	for (i = 0; trace_options[i]; i++) {
 		if (trace_flags & (1 << i))
-			r += sprintf(buf + r, "%s ", trace_options[i]);
+			r += sprintf(buf + r, "%s\n", trace_options[i]);
 		else
-			r += sprintf(buf + r, "no%s ", trace_options[i]);
+			r += sprintf(buf + r, "no%s\n", trace_options[i]);
 	}
 
 	for (i = 0; trace_opts[i].name; i++) {
 		if (tracer_flags & trace_opts[i].bit)
-			r += sprintf(buf + r, "%s ",
+			r += sprintf(buf + r, "%s\n",
 				trace_opts[i].name);
 		else
-			r += sprintf(buf + r, "no%s ",
+			r += sprintf(buf + r, "no%s\n",
 				trace_opts[i].name);
 	}
 	mutex_unlock(&trace_types_lock);
 
-	r += sprintf(buf + r, "\n");
 	WARN_ON(r >= len + 2);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-- 
1.5.6.5

-- 
