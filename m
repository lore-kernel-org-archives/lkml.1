Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbYKLWzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbYKLWzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYKLWzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:55:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYKLWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:55:03 -0500
Message-Id: <20081112225501.111007724@goodmis.org>
References: <20081112225235.056515739@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 17:52:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: rename iter_ctrl to trace_options
Content-Disposition: inline; filename=0002-ftrace-rename-iter_ctrl-to-trace_options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: debugfs file iter_ctrl renamed to trace_options

The original ftrace had a file called "iter_ctrl" that would control
the way the output was iterated. But this file grew into a catch all
for different trace options. This patch renames the file from iter_ctrl
to trace_options to reflect this change.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |   14 +++++++-------
 kernel/trace/trace.c     |   18 +++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index 58cba1f..01ac404 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -82,7 +82,7 @@ of ftrace. Here is a list of some of the key files:
 		tracer is not adding more data, they will display
 		the same information every time they are read.
 
-  iter_ctrl: This file lets the user control the amount of data
+  trace_options: This file lets the user control the amount of data
 		that is displayed in one of the above output
 		files.
 
@@ -316,23 +316,23 @@ The above is mostly meaningful for kernel developers.
   The rest is the same as the 'trace' file.
 
 
-iter_ctrl
----------
+trace_options
+-------------
 
-The iter_ctrl file is used to control what gets printed in the trace
+The trace_options file is used to control what gets printed in the trace
 output. To see what is available, simply cat the file:
 
-  cat /debug/tracing/iter_ctrl
+  cat /debug/tracing/trace_options
   print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
  noblock nostacktrace nosched-tree
 
 To disable one of the options, echo in the option prepended with "no".
 
-  echo noprint-parent > /debug/tracing/iter_ctrl
+  echo noprint-parent > /debug/tracing/trace_options
 
 To enable an option, leave off the "no".
 
-  echo sym-offset > /debug/tracing/iter_ctrl
+  echo sym-offset > /debug/tracing/trace_options
 
 Here are the available options:
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c681778..32cef26 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -204,7 +204,7 @@ static DEFINE_MUTEX(trace_types_lock);
 /* trace_wait is a waitqueue for tasks blocked on trace_poll */
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
-/* trace_flags holds iter_ctrl options */
+/* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK;
 
 /**
@@ -2411,7 +2411,7 @@ static struct file_operations tracing_cpumask_fops = {
 };
 
 static ssize_t
-tracing_iter_ctrl_read(struct file *filp, char __user *ubuf,
+tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
 	char *buf;
@@ -2448,7 +2448,7 @@ tracing_iter_ctrl_read(struct file *filp, char __user *ubuf,
 }
 
 static ssize_t
-tracing_iter_ctrl_write(struct file *filp, const char __user *ubuf,
+tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
@@ -2493,8 +2493,8 @@ tracing_iter_ctrl_write(struct file *filp, const char __user *ubuf,
 
 static struct file_operations tracing_iter_fops = {
 	.open		= tracing_open_generic,
-	.read		= tracing_iter_ctrl_read,
-	.write		= tracing_iter_ctrl_write,
+	.read		= tracing_trace_options_read,
+	.write		= tracing_trace_options_write,
 };
 
 static const char readme_msg[] =
@@ -2508,9 +2508,9 @@ static const char readme_msg[] =
 	"# echo sched_switch > /debug/tracing/current_tracer\n"
 	"# cat /debug/tracing/current_tracer\n"
 	"sched_switch\n"
-	"# cat /debug/tracing/iter_ctrl\n"
+	"# cat /debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
-	"# echo print-parent > /debug/tracing/iter_ctrl\n"
+	"# echo print-parent > /debug/tracing/trace_options\n"
 	"# echo 1 > /debug/tracing/tracing_enabled\n"
 	"# cat /debug/tracing/trace > /tmp/trace.txt\n"
 	"echo 0 > /debug/tracing/tracing_enabled\n"
@@ -3145,10 +3145,10 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
 
-	entry = debugfs_create_file("iter_ctrl", 0644, d_tracer,
+	entry = debugfs_create_file("trace_options", 0644, d_tracer,
 				    NULL, &tracing_iter_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
+		pr_warning("Could not create debugfs 'trace_options' entry\n");
 
 	entry = debugfs_create_file("tracing_cpumask", 0644, d_tracer,
 				    NULL, &tracing_cpumask_fops);
-- 
1.5.6.5

-- 
