Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZGRKZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZGRKZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZGRKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:25:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZGRKZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:25:04 -0400
Date: Sat, 18 Jul 2009 10:24:33 GMT
From: "tip-bot for jolsa@redhat.com" <jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jolsa@redhat.com, mingo@elte.hu
In-Reply-To: <1247773468-11594-2-git-send-email-jolsa@redhat.com>
References: <1247773468-11594-2-git-send-email-jolsa@redhat.com>
Subject: [tip:tracing/core] tracing: Remove unused fields/variables
Message-ID: <tip-566b0aaf798a0dddfc455d1a5b05c424c6686c65@git.kernel.org>
Git-Commit-ID: 566b0aaf798a0dddfc455d1a5b05c424c6686c65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 10:24:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  566b0aaf798a0dddfc455d1a5b05c424c6686c65
Gitweb:     http://git.kernel.org/tip/566b0aaf798a0dddfc455d1a5b05c424c6686c65
Author:     jolsa@redhat.com <jolsa@redhat.com>
AuthorDate: Thu, 16 Jul 2009 21:44:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 12:21:16 +0200

tracing: Remove unused fields/variables

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org
LKML-Reference: <1247773468-11594-2-git-send-email-jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    3 ---
 kernel/trace/trace.c  |    3 +--
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6227dc8..24e3ff5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1339,7 +1339,6 @@ struct ftrace_iterator {
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
 	unsigned		buffer_idx;
-	unsigned		filtered;
 };
 
 static void *
@@ -2268,7 +2267,6 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (isspace(ch)) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ret = ftrace_process_regex(iter->buffer,
 					   iter->buffer_idx, enable);
@@ -2399,7 +2397,6 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		iter = file->private_data;
 
 	if (iter->buffer_idx) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 60a4948..e30e6b1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4265,7 +4265,6 @@ void ftrace_dump(void)
 
 __init static int tracer_alloc_buffers(void)
 {
-	struct trace_array_cpu *data;
 	int ring_buf_size;
 	int i;
 	int ret = -ENOMEM;
@@ -4315,7 +4314,7 @@ __init static int tracer_alloc_buffers(void)
 
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
-		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 		max_tr.data[i] = &per_cpu(max_data, i);
 	}
 
