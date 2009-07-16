Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbZGPTos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbZGPTos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbZGPTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:44:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747AbZGPToq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:44:46 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] tracing: removing not used variables
Date: Thu, 16 Jul 2009 21:44:26 +0200
Message-Id: <1247773468-11594-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
References: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing not used variables.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
 kernel/trace/ftrace.c |    3 ---
 kernel/trace/trace.c  |    3 +--
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..1dc08ab 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1375,7 +1375,6 @@ struct ftrace_iterator {
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
 	unsigned		buffer_idx;
-	unsigned		filtered;
 };
 
 static void *
@@ -2312,7 +2311,6 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (isspace(ch)) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ret = ftrace_process_regex(iter->buffer,
 					   iter->buffer_idx, enable);
@@ -2443,7 +2441,6 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		iter = file->private_data;
 
 	if (iter->buffer_idx) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8bc8d8a..d8bb7fd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4268,7 +4268,6 @@ void ftrace_dump(void)
 
 __init static int tracer_alloc_buffers(void)
 {
-	struct trace_array_cpu *data;
 	int ring_buf_size;
 	int i;
 	int ret = -ENOMEM;
@@ -4318,7 +4317,7 @@ __init static int tracer_alloc_buffers(void)
 
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
-		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 		max_tr.data[i] = &per_cpu(max_data, i);
 	}
 
-- 
1.6.2.5

