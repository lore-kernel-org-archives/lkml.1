Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZBYWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZBYWOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758960AbZBYWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:13:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbZBYWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:13:47 -0500
Message-Id: <20090225221345.005866537@goodmis.org>
References: <20090225221304.097297742@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 17:13:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] tracing: rename DEFINE_TRACE_FMT to just TRACE_FORMAT
Content-Disposition: inline; filename=0001-tracing-rename-DEFINE_TRACE_FMT-to-just-TRACE_FORMA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's been a bit confusion to whether DEFINE/DECLARE_TRACE_FMT should
be a DEFINE or a DECLARE. Ingo Molnar suggested simply calling it
TRACE_FORMAT.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h        |    2 +-
 include/trace/sched_event_types.h |   26 +++++++++++++-------------
 kernel/trace/trace_events.h       |    4 ++--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 34ae464..3de09fa 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -153,7 +153,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	synchronize_sched();
 }
 
-#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
+#define TRACE_FORMAT(name, proto, args, fmt)		\
 	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
 
 #endif
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index a4f6629..a3d3d66 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -1,72 +1,72 @@
 
 /* use <trace/sched.h> instead */
-#ifndef DEFINE_TRACE_FMT
+#ifndef TRACE_FORMAT
 # error Do not include this file directly.
 # error Unless you know what you are doing.
 #endif
 
-DEFINE_TRACE_FMT(sched_kthread_stop,
+TRACE_FORMAT(sched_kthread_stop,
 	TPPROTO(struct task_struct *t),
 	TPARGS(t),
 	TPFMT("task %s:%d", t->comm, t->pid));
 
-DEFINE_TRACE_FMT(sched_kthread_stop_ret,
+TRACE_FORMAT(sched_kthread_stop_ret,
 	TPPROTO(int ret),
 	TPARGS(ret),
 	TPFMT("ret=%d", ret));
 
-DEFINE_TRACE_FMT(sched_wait_task,
+TRACE_FORMAT(sched_wait_task,
 	TPPROTO(struct rq *rq, struct task_struct *p),
 	TPARGS(rq, p),
 	TPFMT("task %s:%d", p->comm, p->pid));
 
-DEFINE_TRACE_FMT(sched_wakeup,
+TRACE_FORMAT(sched_wakeup,
 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
 	TPARGS(rq, p, success),
 	TPFMT("task %s:%d %s",
 	      p->comm, p->pid, success?"succeeded":"failed"));
 
-DEFINE_TRACE_FMT(sched_wakeup_new,
+TRACE_FORMAT(sched_wakeup_new,
 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
 	TPARGS(rq, p, success),
 	TPFMT("task %s:%d",
 	      p->comm, p->pid, success?"succeeded":"failed"));
 
-DEFINE_TRACE_FMT(sched_switch,
+TRACE_FORMAT(sched_switch,
 	TPPROTO(struct rq *rq, struct task_struct *prev,
 		struct task_struct *next),
 	TPARGS(rq, prev, next),
 	TPFMT("task %s:%d ==> %s:%d",
 	      prev->comm, prev->pid, next->comm, next->pid));
 
-DEFINE_TRACE_FMT(sched_migrate_task,
+TRACE_FORMAT(sched_migrate_task,
 	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
 	TPARGS(p, orig_cpu, dest_cpu),
 	TPFMT("task %s:%d from: %d  to: %d",
 	      p->comm, p->pid, orig_cpu, dest_cpu));
 
-DEFINE_TRACE_FMT(sched_process_free,
+TRACE_FORMAT(sched_process_free,
 	TPPROTO(struct task_struct *p),
 	TPARGS(p),
 	TPFMT("task %s:%d", p->comm, p->pid));
 
-DEFINE_TRACE_FMT(sched_process_exit,
+TRACE_FORMAT(sched_process_exit,
 	TPPROTO(struct task_struct *p),
 	TPARGS(p),
 	TPFMT("task %s:%d", p->comm, p->pid));
 
-DEFINE_TRACE_FMT(sched_process_wait,
+TRACE_FORMAT(sched_process_wait,
 	TPPROTO(struct pid *pid),
 	TPARGS(pid),
 	TPFMT("pid %d", pid));
 
-DEFINE_TRACE_FMT(sched_process_fork,
+TRACE_FORMAT(sched_process_fork,
 	TPPROTO(struct task_struct *parent, struct task_struct *child),
 	TPARGS(parent, child),
 	TPFMT("parent %s:%d  child %s:%d",
 	      parent->comm, parent->pid, child->comm, child->pid));
 
-DEFINE_TRACE_FMT(sched_signal_send,
+TRACE_FORMAT(sched_signal_send,
 	TPPROTO(int sig, struct task_struct *p),
 	TPARGS(sig, p),
 	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid));
diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
index cb8455b..deb95e5 100644
--- a/kernel/trace/trace_events.h
+++ b/kernel/trace/trace_events.h
@@ -17,8 +17,8 @@ struct ftrace_event_call {
 #undef TPFMT
 #define TPFMT(fmt, args...)	fmt "\n", ##args
 
-#undef DEFINE_TRACE_FMT
-#define DEFINE_TRACE_FMT(call, proto, args, fmt)			\
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)				\
 static void ftrace_event_##call(proto)					\
 {									\
 	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
-- 
1.5.6.5

-- 
