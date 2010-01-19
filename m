Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503Ab0ASInb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0ASInb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271Ab0ASIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:43:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0ASIn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:43:29 -0500
Message-ID: <4B557036.3080005@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 16:41:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 v2] tracing/kprobe: cleanup unused return value of function
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B54662B.4050109@cn.fujitsu.com>
In-Reply-To: <4B54662B.4050109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those function's return value is meaningless

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/trace_kprobe.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2714d23..de2cf85 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -942,7 +942,7 @@ static const struct file_operations kprobe_profile_ops = {
 };
 
 /* Kprobe handler */
-static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
+static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct kprobe_trace_entry *entry;
@@ -962,7 +962,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
 	if (!event)
-		return 0;
+		return ;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -972,11 +972,11 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
-	return 0;
+	return ;
 }
 
 /* Kretprobe handler */
-static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 					  struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -995,7 +995,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
 	if (!event)
-		return 0;
+		return ;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -1007,7 +1007,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
 
-	return 0;
+	return ;
 }
 
 /* Event entry printers */
@@ -1217,7 +1217,7 @@ static int set_print_fmt(struct trace_probe *tp)
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes int kprobe_profile_func(struct kprobe *kp,
+static __kprobes void kprobe_profile_func(struct kprobe *kp,
 					 struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
@@ -1232,11 +1232,11 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return ;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return ;
 
 	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
@@ -1245,11 +1245,11 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
 
-	return 0;
+	return ;
 }
 
 /* Kretprobe profile handler */
-static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 					    struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1264,11 +1264,11 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return ;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return ;
 
 	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
@@ -1278,7 +1278,7 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
 
-	return 0;
+	return ;
 }
 
 static int probe_profile_enable(struct ftrace_event_call *call)
-- 
1.6.1.2


