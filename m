Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZDODRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZDODRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZDODQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:16:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZDODQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:16:08 -0400
Message-Id: <20090415031605.224882171@goodmis.org>
References: <20090415031511.128139334@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 23:15:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 3/4] tracing/events: move trace point headers into include/trace/events
Content-Disposition: inline; filename=0003-tracing-events-move-trace-point-headers-into-includ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Create a sub directory in include/trace called events to keep the
trace point headers in their own separate directory. Only headers that
declare trace points should be defined in this directory.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kmemtrace.h         |    2 +-
 include/trace/define_trace.h      |    2 +-
 include/trace/events/irq.h        |   57 ++++++
 include/trace/events/kmem.h       |  194 +++++++++++++++++++++
 include/trace/events/lockdep.h    |   60 +++++++
 include/trace/events/sched.h      |  339 +++++++++++++++++++++++++++++++++++++
 include/trace/events/skb.h        |   40 +++++
 include/trace/irq.h               |   57 ------
 include/trace/kmem.h              |  194 ---------------------
 include/trace/lockdep.h           |   60 -------
 include/trace/sched.h             |  339 -------------------------------------
 include/trace/skb.h               |   40 -----
 kernel/exit.c                     |    2 +-
 kernel/fork.c                     |    3 +-
 kernel/irq/handle.c               |    2 +-
 kernel/kthread.c                  |    2 +-
 kernel/lockdep.c                  |    2 +-
 kernel/sched.c                    |    2 +-
 kernel/signal.c                   |    2 +-
 kernel/softirq.c                  |    2 +-
 kernel/trace/ftrace.c             |    2 +-
 kernel/trace/trace_sched_switch.c |    2 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 mm/util.c                         |    2 +-
 net/core/drop_monitor.c           |    2 +-
 net/core/net-traces.c             |    2 +-
 net/core/skbuff.c                 |    2 +-
 27 files changed, 708 insertions(+), 707 deletions(-)
 create mode 100644 include/trace/events/irq.h
 create mode 100644 include/trace/events/kmem.h
 create mode 100644 include/trace/events/lockdep.h
 create mode 100644 include/trace/events/sched.h
 create mode 100644 include/trace/events/skb.h
 delete mode 100644 include/trace/irq.h
 delete mode 100644 include/trace/kmem.h
 delete mode 100644 include/trace/lockdep.h
 delete mode 100644 include/trace/sched.h
 delete mode 100644 include/trace/skb.h

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 15c45a2..b616d39 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -9,7 +9,7 @@
 
 #ifdef __KERNEL__
 
-#include <trace/kmem.h>
+#include <trace/events/kmem.h>
 
 #ifdef CONFIG_KMEMTRACE
 extern void kmemtrace_init(void);
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 980eb66..1886941 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -43,7 +43,7 @@
 #endif
 
 #ifndef TRACE_INCLUDE_PATH
-# define __TRACE_INCLUDE(system) <trace/system.h>
+# define __TRACE_INCLUDE(system) <trace/events/system.h>
 # define UNDEF_TRACE_INCLUDE_FILE
 #else
 # define __TRACE_INCLUDE(system) __stringify(TRACE_INCLUDE_PATH/system.h)
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
new file mode 100644
index 0000000..75e3468
--- /dev/null
+++ b/include/trace/events/irq.h
@@ -0,0 +1,57 @@
+#if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_H
+
+#include <linux/tracepoint.h>
+#include <linux/interrupt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq
+
+/*
+ * Tracepoint for entry of interrupt handler:
+ */
+TRACE_FORMAT(irq_handler_entry,
+	TP_PROTO(int irq, struct irqaction *action),
+	TP_ARGS(irq, action),
+	TP_FMT("irq=%d handler=%s", irq, action->name)
+	);
+
+/*
+ * Tracepoint for return of an interrupt handler:
+ */
+TRACE_EVENT(irq_handler_exit,
+
+	TP_PROTO(int irq, struct irqaction *action, int ret),
+
+	TP_ARGS(irq, action, ret),
+
+	TP_STRUCT__entry(
+		__field(	int,	irq	)
+		__field(	int,	ret	)
+	),
+
+	TP_fast_assign(
+		__entry->irq	= irq;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("irq=%d return=%s",
+		  __entry->irq, __entry->ret ? "handled" : "unhandled")
+);
+
+TRACE_FORMAT(softirq_entry,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
+	);
+
+TRACE_FORMAT(softirq_exit,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
+	);
+
+#endif /*  _TRACE_IRQ_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
new file mode 100644
index 0000000..c22c42f
--- /dev/null
+++ b/include/trace/events/kmem.h
@@ -0,0 +1,194 @@
+#if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KMEM_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kmem
+
+TRACE_EVENT(kmalloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags)
+);
+
+TRACE_EVENT(kmem_cache_alloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags)
+);
+
+TRACE_EVENT(kmalloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags,
+		__entry->node)
+);
+
+TRACE_EVENT(kmem_cache_alloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		__entry->gfp_flags,
+		__entry->node)
+);
+
+TRACE_EVENT(kfree,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+
+TRACE_EVENT(kmem_cache_free,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+#endif /* _TRACE_KMEM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
new file mode 100644
index 0000000..45e326b
--- /dev/null
+++ b/include/trace/events/lockdep.h
@@ -0,0 +1,60 @@
+#if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_LOCKDEP_H
+
+#include <linux/lockdep.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM lockdep
+
+#ifdef CONFIG_LOCKDEP
+
+TRACE_FORMAT(lock_acquire,
+	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
+		int trylock, int read, int check,
+		struct lockdep_map *next_lock, unsigned long ip),
+	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
+	TP_FMT("%s%s%s", trylock ? "try " : "",
+		read ? "read " : "", lock->name)
+	);
+
+TRACE_FORMAT(lock_release,
+	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+	TP_ARGS(lock, nested, ip),
+	TP_FMT("%s", lock->name)
+	);
+
+#ifdef CONFIG_LOCK_STAT
+
+TRACE_FORMAT(lock_contended,
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+	TP_ARGS(lock, ip),
+	TP_FMT("%s", lock->name)
+	);
+
+TRACE_EVENT(lock_acquired,
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+
+	TP_ARGS(lock, ip, waittime),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(unsigned long, wait_usec)
+		__field(unsigned long, wait_nsec_rem)
+	),
+	TP_fast_assign(
+		__entry->name = lock->name;
+		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
+		__entry->wait_usec = (unsigned long) waittime;
+	),
+	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
+				       __entry->wait_nsec_rem)
+);
+
+#endif
+#endif
+
+#endif /* _TRACE_LOCKDEP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
new file mode 100644
index 0000000..ffa1cab
--- /dev/null
+++ b/include/trace/events/sched.h
@@ -0,0 +1,339 @@
+#if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SCHED_H
+
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sched
+
+/*
+ * Tracepoint for calling kthread_stop, performed to end a kthread:
+ */
+TRACE_EVENT(sched_kthread_stop,
+
+	TP_PROTO(struct task_struct *t),
+
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		__entry->pid	= t->pid;
+	),
+
+	TP_printk("task %s:%d", __entry->comm, __entry->pid)
+);
+
+/*
+ * Tracepoint for the return value of the kthread stopping:
+ */
+TRACE_EVENT(sched_kthread_stop_ret,
+
+	TP_PROTO(int ret),
+
+	TP_ARGS(ret),
+
+	TP_STRUCT__entry(
+		__field(	int,	ret	)
+	),
+
+	TP_fast_assign(
+		__entry->ret	= ret;
+	),
+
+	TP_printk("ret %d", __entry->ret)
+);
+
+/*
+ * Tracepoint for waiting on task to unschedule:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wait_task,
+
+	TP_PROTO(struct rq *rq, struct task_struct *p),
+
+	TP_ARGS(rq, p),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid	= p->pid;
+		__entry->prio	= p->prio;
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
+);
+
+/*
+ * Tracepoint for waking up a task:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wakeup,
+
+	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+
+	TP_ARGS(rq, p, success),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	success			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->success	= success;
+	),
+
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success)
+);
+
+/*
+ * Tracepoint for waking up a new task:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wakeup_new,
+
+	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+
+	TP_ARGS(rq, p, success),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	success			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->success	= success;
+	),
+
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success)
+);
+
+/*
+ * Tracepoint for task switches, performed by the scheduler:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_switch,
+
+	TP_PROTO(struct rq *rq, struct task_struct *prev,
+		 struct task_struct *next),
+
+	TP_ARGS(rq, prev, next),
+
+	TP_STRUCT__entry(
+		__array(	char,	prev_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	prev_pid			)
+		__field(	int,	prev_prio			)
+		__array(	char,	next_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	next_pid			)
+		__field(	int,	next_prio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		__entry->prev_pid	= prev->pid;
+		__entry->prev_prio	= prev->prio;
+		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		__entry->next_pid	= next->pid;
+		__entry->next_prio	= next->prio;
+	),
+
+	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+);
+
+/*
+ * Tracepoint for a task being migrated:
+ */
+TRACE_EVENT(sched_migrate_task,
+
+	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+
+	TP_ARGS(p, orig_cpu, dest_cpu),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	orig_cpu		)
+		__field(	int,	dest_cpu		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->orig_cpu	= orig_cpu;
+		__entry->dest_cpu	= dest_cpu;
+	),
+
+	TP_printk("task %s:%d [%d] from: %d  to: %d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->orig_cpu, __entry->dest_cpu)
+);
+
+/*
+ * Tracepoint for freeing a task:
+ */
+TRACE_EVENT(sched_process_free,
+
+	TP_PROTO(struct task_struct *p),
+
+	TP_ARGS(p),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
+);
+
+/*
+ * Tracepoint for a task exiting:
+ */
+TRACE_EVENT(sched_process_exit,
+
+	TP_PROTO(struct task_struct *p),
+
+	TP_ARGS(p),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
+);
+
+/*
+ * Tracepoint for a waiting task:
+ */
+TRACE_EVENT(sched_process_wait,
+
+	TP_PROTO(struct pid *pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->pid		= pid_nr(pid);
+		__entry->prio		= current->prio;
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
+);
+
+/*
+ * Tracepoint for do_fork:
+ */
+TRACE_EVENT(sched_process_fork,
+
+	TP_PROTO(struct task_struct *parent, struct task_struct *child),
+
+	TP_ARGS(parent, child),
+
+	TP_STRUCT__entry(
+		__array(	char,	parent_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	parent_pid			)
+		__array(	char,	child_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	child_pid			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
+		__entry->parent_pid	= parent->pid;
+		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
+		__entry->child_pid	= child->pid;
+	),
+
+	TP_printk("parent %s:%d  child %s:%d",
+		__entry->parent_comm, __entry->parent_pid,
+		__entry->child_comm, __entry->child_pid)
+);
+
+/*
+ * Tracepoint for sending a signal:
+ */
+TRACE_EVENT(sched_signal_send,
+
+	TP_PROTO(int sig, struct task_struct *p),
+
+	TP_ARGS(sig, p),
+
+	TP_STRUCT__entry(
+		__field(	int,	sig			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid	= p->pid;
+		__entry->sig	= sig;
+	),
+
+	TP_printk("sig: %d  task %s:%d",
+		  __entry->sig, __entry->comm, __entry->pid)
+);
+
+#endif /* _TRACE_SCHED_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
new file mode 100644
index 0000000..1e8fabb
--- /dev/null
+++ b/include/trace/events/skb.h
@@ -0,0 +1,40 @@
+#if !defined(_TRACE_SKB_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SKB_H
+
+#include <linux/skbuff.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM skb
+
+/*
+ * Tracepoint for free an sk_buff:
+ */
+TRACE_EVENT(kfree_skb,
+
+	TP_PROTO(struct sk_buff *skb, void *location),
+
+	TP_ARGS(skb, location),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned short,	protocol	)
+		__field(	void *,		location	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		if (skb) {
+			__entry->protocol = ntohs(skb->protocol);
+		}
+		__entry->location = location;
+	),
+
+	TP_printk("skbaddr=%p protocol=%u location=%p",
+		__entry->skbaddr, __entry->protocol, __entry->location)
+);
+
+#endif /* _TRACE_SKB_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/irq.h b/include/trace/irq.h
deleted file mode 100644
index 75e3468..0000000
--- a/include/trace/irq.h
+++ /dev/null
@@ -1,57 +0,0 @@
-#if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_IRQ_H
-
-#include <linux/tracepoint.h>
-#include <linux/interrupt.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM irq
-
-/*
- * Tracepoint for entry of interrupt handler:
- */
-TRACE_FORMAT(irq_handler_entry,
-	TP_PROTO(int irq, struct irqaction *action),
-	TP_ARGS(irq, action),
-	TP_FMT("irq=%d handler=%s", irq, action->name)
-	);
-
-/*
- * Tracepoint for return of an interrupt handler:
- */
-TRACE_EVENT(irq_handler_exit,
-
-	TP_PROTO(int irq, struct irqaction *action, int ret),
-
-	TP_ARGS(irq, action, ret),
-
-	TP_STRUCT__entry(
-		__field(	int,	irq	)
-		__field(	int,	ret	)
-	),
-
-	TP_fast_assign(
-		__entry->irq	= irq;
-		__entry->ret	= ret;
-	),
-
-	TP_printk("irq=%d return=%s",
-		  __entry->irq, __entry->ret ? "handled" : "unhandled")
-);
-
-TRACE_FORMAT(softirq_entry,
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
-	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
-
-TRACE_FORMAT(softirq_exit,
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
-	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
-
-#endif /*  _TRACE_IRQ_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/include/trace/kmem.h b/include/trace/kmem.h
deleted file mode 100644
index c22c42f..0000000
--- a/include/trace/kmem.h
+++ /dev/null
@@ -1,194 +0,0 @@
-#if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_KMEM_H
-
-#include <linux/types.h>
-#include <linux/tracepoint.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM kmem
-
-TRACE_EVENT(kmalloc,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags)
-);
-
-TRACE_EVENT(kmem_cache_alloc,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags)
-);
-
-TRACE_EVENT(kmalloc_node,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags,
-		 int node),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-		__field(	int,		node		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-		__entry->node		= node;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags,
-		__entry->node)
-);
-
-TRACE_EVENT(kmem_cache_alloc_node,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags,
-		 int node),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-		__field(	int,		node		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-		__entry->node		= node;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags,
-		__entry->node)
-);
-
-TRACE_EVENT(kfree,
-
-	TP_PROTO(unsigned long call_site, const void *ptr),
-
-	TP_ARGS(call_site, ptr),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-	),
-
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
-);
-
-TRACE_EVENT(kmem_cache_free,
-
-	TP_PROTO(unsigned long call_site, const void *ptr),
-
-	TP_ARGS(call_site, ptr),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-	),
-
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
-);
-#endif /* _TRACE_KMEM_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
deleted file mode 100644
index 45e326b..0000000
--- a/include/trace/lockdep.h
+++ /dev/null
@@ -1,60 +0,0 @@
-#if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_LOCKDEP_H
-
-#include <linux/lockdep.h>
-#include <linux/tracepoint.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM lockdep
-
-#ifdef CONFIG_LOCKDEP
-
-TRACE_FORMAT(lock_acquire,
-	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
-		int trylock, int read, int check,
-		struct lockdep_map *next_lock, unsigned long ip),
-	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
-	TP_FMT("%s%s%s", trylock ? "try " : "",
-		read ? "read " : "", lock->name)
-	);
-
-TRACE_FORMAT(lock_release,
-	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
-	TP_ARGS(lock, nested, ip),
-	TP_FMT("%s", lock->name)
-	);
-
-#ifdef CONFIG_LOCK_STAT
-
-TRACE_FORMAT(lock_contended,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
-	TP_ARGS(lock, ip),
-	TP_FMT("%s", lock->name)
-	);
-
-TRACE_EVENT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
-
-	TP_ARGS(lock, ip, waittime),
-
-	TP_STRUCT__entry(
-		__field(const char *, name)
-		__field(unsigned long, wait_usec)
-		__field(unsigned long, wait_nsec_rem)
-	),
-	TP_fast_assign(
-		__entry->name = lock->name;
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
-	),
-	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
-				       __entry->wait_nsec_rem)
-);
-
-#endif
-#endif
-
-#endif /* _TRACE_LOCKDEP_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/include/trace/sched.h b/include/trace/sched.h
deleted file mode 100644
index ffa1cab..0000000
--- a/include/trace/sched.h
+++ /dev/null
@@ -1,339 +0,0 @@
-#if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_SCHED_H
-
-#include <linux/sched.h>
-#include <linux/tracepoint.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM sched
-
-/*
- * Tracepoint for calling kthread_stop, performed to end a kthread:
- */
-TRACE_EVENT(sched_kthread_stop,
-
-	TP_PROTO(struct task_struct *t),
-
-	TP_ARGS(t),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
-		__entry->pid	= t->pid;
-	),
-
-	TP_printk("task %s:%d", __entry->comm, __entry->pid)
-);
-
-/*
- * Tracepoint for the return value of the kthread stopping:
- */
-TRACE_EVENT(sched_kthread_stop_ret,
-
-	TP_PROTO(int ret),
-
-	TP_ARGS(ret),
-
-	TP_STRUCT__entry(
-		__field(	int,	ret	)
-	),
-
-	TP_fast_assign(
-		__entry->ret	= ret;
-	),
-
-	TP_printk("ret %d", __entry->ret)
-);
-
-/*
- * Tracepoint for waiting on task to unschedule:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
- */
-TRACE_EVENT(sched_wait_task,
-
-	TP_PROTO(struct rq *rq, struct task_struct *p),
-
-	TP_ARGS(rq, p),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid	= p->pid;
-		__entry->prio	= p->prio;
-	),
-
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
-
-/*
- * Tracepoint for waking up a task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
- */
-TRACE_EVENT(sched_wakeup,
-
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-
-	TP_ARGS(rq, p, success),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-		__field(	int,	success			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-		__entry->success	= success;
-	),
-
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
-);
-
-/*
- * Tracepoint for waking up a new task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
- */
-TRACE_EVENT(sched_wakeup_new,
-
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-
-	TP_ARGS(rq, p, success),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-		__field(	int,	success			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-		__entry->success	= success;
-	),
-
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
-);
-
-/*
- * Tracepoint for task switches, performed by the scheduler:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
- */
-TRACE_EVENT(sched_switch,
-
-	TP_PROTO(struct rq *rq, struct task_struct *prev,
-		 struct task_struct *next),
-
-	TP_ARGS(rq, prev, next),
-
-	TP_STRUCT__entry(
-		__array(	char,	prev_comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	prev_pid			)
-		__field(	int,	prev_prio			)
-		__array(	char,	next_comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	next_pid			)
-		__field(	int,	next_prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
-		__entry->prev_pid	= prev->pid;
-		__entry->prev_prio	= prev->prio;
-		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
-		__entry->next_pid	= next->pid;
-		__entry->next_prio	= next->prio;
-	),
-
-	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
-		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
-		__entry->next_comm, __entry->next_pid, __entry->next_prio)
-);
-
-/*
- * Tracepoint for a task being migrated:
- */
-TRACE_EVENT(sched_migrate_task,
-
-	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
-
-	TP_ARGS(p, orig_cpu, dest_cpu),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-		__field(	int,	orig_cpu		)
-		__field(	int,	dest_cpu		)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-		__entry->orig_cpu	= orig_cpu;
-		__entry->dest_cpu	= dest_cpu;
-	),
-
-	TP_printk("task %s:%d [%d] from: %d  to: %d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->orig_cpu, __entry->dest_cpu)
-);
-
-/*
- * Tracepoint for freeing a task:
- */
-TRACE_EVENT(sched_process_free,
-
-	TP_PROTO(struct task_struct *p),
-
-	TP_ARGS(p),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-	),
-
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
-
-/*
- * Tracepoint for a task exiting:
- */
-TRACE_EVENT(sched_process_exit,
-
-	TP_PROTO(struct task_struct *p),
-
-	TP_ARGS(p),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-	),
-
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
-
-/*
- * Tracepoint for a waiting task:
- */
-TRACE_EVENT(sched_process_wait,
-
-	TP_PROTO(struct pid *pid),
-
-	TP_ARGS(pid),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-		__entry->pid		= pid_nr(pid);
-		__entry->prio		= current->prio;
-	),
-
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
-
-/*
- * Tracepoint for do_fork:
- */
-TRACE_EVENT(sched_process_fork,
-
-	TP_PROTO(struct task_struct *parent, struct task_struct *child),
-
-	TP_ARGS(parent, child),
-
-	TP_STRUCT__entry(
-		__array(	char,	parent_comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	parent_pid			)
-		__array(	char,	child_comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	child_pid			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
-		__entry->parent_pid	= parent->pid;
-		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
-		__entry->child_pid	= child->pid;
-	),
-
-	TP_printk("parent %s:%d  child %s:%d",
-		__entry->parent_comm, __entry->parent_pid,
-		__entry->child_comm, __entry->child_pid)
-);
-
-/*
- * Tracepoint for sending a signal:
- */
-TRACE_EVENT(sched_signal_send,
-
-	TP_PROTO(int sig, struct task_struct *p),
-
-	TP_ARGS(sig, p),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig			)
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid	= p->pid;
-		__entry->sig	= sig;
-	),
-
-	TP_printk("sig: %d  task %s:%d",
-		  __entry->sig, __entry->comm, __entry->pid)
-);
-
-#endif /* _TRACE_SCHED_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/include/trace/skb.h b/include/trace/skb.h
deleted file mode 100644
index 1e8fabb..0000000
--- a/include/trace/skb.h
+++ /dev/null
@@ -1,40 +0,0 @@
-#if !defined(_TRACE_SKB_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_SKB_H
-
-#include <linux/skbuff.h>
-#include <linux/tracepoint.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM skb
-
-/*
- * Tracepoint for free an sk_buff:
- */
-TRACE_EVENT(kfree_skb,
-
-	TP_PROTO(struct sk_buff *skb, void *location),
-
-	TP_ARGS(skb, location),
-
-	TP_STRUCT__entry(
-		__field(	void *,		skbaddr		)
-		__field(	unsigned short,	protocol	)
-		__field(	void *,		location	)
-	),
-
-	TP_fast_assign(
-		__entry->skbaddr = skb;
-		if (skb) {
-			__entry->protocol = ntohs(skb->protocol);
-		}
-		__entry->location = location;
-	),
-
-	TP_printk("skbaddr=%p protocol=%u location=%p",
-		__entry->skbaddr, __entry->protocol, __entry->location)
-);
-
-#endif /* _TRACE_SKB_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/kernel/exit.c b/kernel/exit.c
index 2fe9d2c..cab535c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -48,7 +48,7 @@
 #include <linux/tracehook.h>
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 4bebf26..085f73e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -61,7 +61,6 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/fs_struct.h>
-#include <trace/sched.h>
 #include <linux/magic.h>
 
 #include <asm/pgtable.h>
@@ -71,6 +70,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include <trace/events/sched.h>
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 983d8be..37c6363 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -20,7 +20,7 @@
 #include <linux/bootmem.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/irq.h>
+#include <trace/events/irq.h>
 
 #include "internals.h"
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index e1c7692..41c88fe 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -13,7 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 257f21a..47b201e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -48,7 +48,7 @@
 #include "lockdep_internals.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/lockdep.h>
+#include <trace/events/lockdep.h>
 
 #ifdef CONFIG_PROVE_LOCKING
 int prove_locking = 1;
diff --git a/kernel/sched.c b/kernel/sched.c
index e6d4518..9f7ffd0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -79,7 +79,7 @@
 #include "sched_cpupri.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
diff --git a/kernel/signal.c b/kernel/signal.c
index 1d5703f..94ec0a4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -27,7 +27,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
diff --git a/kernel/softirq.c b/kernel/softirq.c
index a2d9b45..7ab9dfd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,7 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
-#include <trace/irq.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq.h>
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8e6a0b5..a234889 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -29,7 +29,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/ftrace.h>
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 9d8cccd..a98106d 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -10,7 +10,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include "trace.h"
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 5bc00e8..b8b13c5 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -15,7 +15,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include "trace.h"
 
diff --git a/mm/util.c b/mm/util.c
index 0e74a22..6794a33 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -7,7 +7,7 @@
 #include <asm/uaccess.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/kmem.h>
+#include <trace/events/kmem.h>
 
 /**
  * kstrdup - allocate space for and copy an existing string
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9fd0dc3..b75b6ce 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -23,7 +23,7 @@
 #include <linux/bitops.h>
 #include <net/genetlink.h>
 
-#include <trace/skb.h>
+#include <trace/events/skb.h>
 
 #include <asm/unaligned.h>
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 8017720..499a67e 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -24,6 +24,6 @@
 #include <asm/bitops.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/skb.h>
+#include <trace/events/skb.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ce6356c..12806b8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -65,7 +65,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <trace/skb.h>
+#include <trace/events/skb.h>
 
 #include "kmap_skb.h"
 
-- 
1.6.2.1

-- 
