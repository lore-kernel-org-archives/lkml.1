Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZCFDUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZCFDUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZCFDTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:19:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZCFDTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:19:44 -0500
Message-Id: <20090306031941.625930618@goodmis.org>
References: <20090306031857.686507907@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 22:18:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] tracing: make all file_operations const
Content-Disposition: inline; filename=0001-tracing-make-all-file_operations-const.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup

All file_operations structures should be constant. No one is going to
change them.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c        |   10 +++++-----
 kernel/trace/ring_buffer.c   |    2 +-
 kernel/trace/trace.c         |   24 ++++++++++++------------
 kernel/trace/trace_sysprof.c |    2 +-
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5a3a06b..d7a06a0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1869,21 +1869,21 @@ ftrace_notrace_release(struct inode *inode, struct file *file)
 	return ftrace_regex_release(inode, file, 0);
 }
 
-static struct file_operations ftrace_avail_fops = {
+static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = ftrace_avail_release,
 };
 
-static struct file_operations ftrace_failures_fops = {
+static const struct file_operations ftrace_failures_fops = {
 	.open = ftrace_failures_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = ftrace_avail_release,
 };
 
-static struct file_operations ftrace_filter_fops = {
+static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = ftrace_regex_read,
 	.write = ftrace_filter_write,
@@ -1891,7 +1891,7 @@ static struct file_operations ftrace_filter_fops = {
 	.release = ftrace_filter_release,
 };
 
-static struct file_operations ftrace_notrace_fops = {
+static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
 	.read = ftrace_regex_read,
 	.write = ftrace_notrace_write,
@@ -2423,7 +2423,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static struct file_operations ftrace_pid_fops = {
+static const struct file_operations ftrace_pid_fops = {
 	.read = ftrace_pid_read,
 	.write = ftrace_pid_write,
 };
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f747364..1788584 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2606,7 +2606,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static struct file_operations rb_simple_fops = {
+static const struct file_operations rb_simple_fops = {
 	.open		= tracing_open_generic,
 	.read		= rb_simple_read,
 	.write		= rb_simple_write,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c0e9c12..e6144ac 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1882,14 +1882,14 @@ static int show_traces_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static struct file_operations tracing_fops = {
+static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= tracing_release,
 };
 
-static struct file_operations show_traces_fops = {
+static const struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
 	.release	= seq_release,
@@ -1982,7 +1982,7 @@ err_unlock:
 	return err;
 }
 
-static struct file_operations tracing_cpumask_fops = {
+static const struct file_operations tracing_cpumask_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_cpumask_read,
 	.write		= tracing_cpumask_write,
@@ -2134,7 +2134,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static struct file_operations tracing_iter_fops = {
+static const struct file_operations tracing_iter_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_trace_options_read,
 	.write		= tracing_trace_options_write,
@@ -2167,7 +2167,7 @@ tracing_readme_read(struct file *filp, char __user *ubuf,
 					readme_msg, strlen(readme_msg));
 }
 
-static struct file_operations tracing_readme_fops = {
+static const struct file_operations tracing_readme_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_readme_read,
 };
@@ -2927,25 +2927,25 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static struct file_operations tracing_max_lat_fops = {
+static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
 	.write		= tracing_max_lat_write,
 };
 
-static struct file_operations tracing_ctrl_fops = {
+static const struct file_operations tracing_ctrl_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_ctrl_read,
 	.write		= tracing_ctrl_write,
 };
 
-static struct file_operations set_tracer_fops = {
+static const struct file_operations set_tracer_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_set_trace_read,
 	.write		= tracing_set_trace_write,
 };
 
-static struct file_operations tracing_pipe_fops = {
+static const struct file_operations tracing_pipe_fops = {
 	.open		= tracing_open_pipe,
 	.poll		= tracing_poll_pipe,
 	.read		= tracing_read_pipe,
@@ -2953,13 +2953,13 @@ static struct file_operations tracing_pipe_fops = {
 	.release	= tracing_release_pipe,
 };
 
-static struct file_operations tracing_entries_fops = {
+static const struct file_operations tracing_entries_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
 };
 
-static struct file_operations tracing_mark_fops = {
+static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
 };
@@ -3240,7 +3240,7 @@ tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 	return r;
 }
 
-static struct file_operations tracing_dyn_info_fops = {
+static const struct file_operations tracing_dyn_info_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_read_dyn_info,
 };
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index c771af4..91fd19c 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -314,7 +314,7 @@ sysprof_sample_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static struct file_operations sysprof_sample_fops = {
+static const struct file_operations sysprof_sample_fops = {
 	.read		= sysprof_sample_read,
 	.write		= sysprof_sample_write,
 };
-- 
1.6.1.3

-- 
