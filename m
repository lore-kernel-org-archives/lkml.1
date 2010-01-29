Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208Ab0A2J0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0A2J0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965Ab0A2J0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:26:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:50639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0A2J0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:26:30 -0500
Date: Fri, 29 Jan 2010 09:25:43 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <4B60E9A3.2040505@cn.fujitsu.com>
References: <4B60E9A3.2040505@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Cleanup unused return value of tracing functions
Message-ID: <tip-1e12a4a7a3a78bc9c3aaf3486dde3b8ab1cdf465@git.kernel.org>
Git-Commit-ID: 1e12a4a7a3a78bc9c3aaf3486dde3b8ab1cdf465
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:25:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e12a4a7a3a78bc9c3aaf3486dde3b8ab1cdf465
Gitweb:     http://git.kernel.org/tip/1e12a4a7a3a78bc9c3aaf3486dde3b8ab1cdf465
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 28 Jan 2010 09:34:27 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 29 Jan 2010 02:14:40 +0100

tracing/kprobe: Cleanup unused return value of tracing functions

The return values of the kprobe's tracing functions are meaningless,
lets remove these.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B60E9A3.2040505@cn.fujitsu.com>
[fweisbec@gmail: whitespace fixes, drop useless void returns in end
of functions]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2e28ee3..6178abf 100644
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
+		return;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -972,11 +972,10 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
-	return 0;
 }
 
 /* Kretprobe handler */
-static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 					  struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -995,7 +994,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
 	if (!event)
-		return 0;
+		return;
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
@@ -1006,8 +1005,6 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
-
-	return 0;
 }
 
 /* Event entry printers */
@@ -1237,7 +1234,7 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes int kprobe_profile_func(struct kprobe *kp,
+static __kprobes void kprobe_profile_func(struct kprobe *kp,
 					 struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
@@ -1252,11 +1249,11 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return;
 
 	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
@@ -1264,12 +1261,10 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
-
-	return 0;
 }
 
 /* Kretprobe profile handler */
-static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
+static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 					    struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1284,11 +1279,11 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
 		     "profile buffer not large enough"))
-		return 0;
+		return;
 
 	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
 	if (!entry)
-		return 0;
+		return;
 
 	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
@@ -1297,8 +1292,6 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
-
-	return 0;
 }
 
 static int probe_profile_enable(struct ftrace_event_call *call)
