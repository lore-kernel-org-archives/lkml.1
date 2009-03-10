Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZCJE7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZCJE7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZCJE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZCJE6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:14 -0400
Message-Id: <20090310045810.833427485@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] tracing: replace TP<var> with TP_<var>
Content-Disposition: inline; filename=0002-tracing-replace-TP-var-with-TP_-var.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The macros TPPROTO, TPARGS, TPFMT, TPRAWFMT, and TPCMD all look a bit
ugly. This patch adds an underscore to their names.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/tracepoints.txt          |    8 +-
 include/linux/tracepoint.h             |    6 +-
 include/trace/block.h                  |   70 +++++++++++-----------
 include/trace/irq_event_types.h        |   16 +++---
 include/trace/lockdep_event_types.h    |   24 ++++----
 include/trace/power.h                  |   12 ++--
 include/trace/sched_event_types.h      |   98 ++++++++++++++++----------------
 include/trace/workqueue.h              |   16 +++---
 kernel/trace/trace_event_types.h       |   28 +++++-----
 kernel/trace/trace_events_stage_2.h    |    6 +-
 kernel/trace/trace_events_stage_3.h    |    8 +-
 kernel/trace/trace_export.c            |    8 +-
 kernel/trace/trace_format.h            |   55 ------------------
 samples/tracepoints/tp-samples-trace.h |    8 +-
 14 files changed, 154 insertions(+), 209 deletions(-)
 delete mode 100644 kernel/trace/trace_format.h

diff --git a/Documentation/tracepoints.txt b/Documentation/tracepoints.txt
index 6f0a044..4ff43c6 100644
--- a/Documentation/tracepoints.txt
+++ b/Documentation/tracepoints.txt
@@ -45,8 +45,8 @@ In include/trace/subsys.h :
 #include <linux/tracepoint.h>
 
 DECLARE_TRACE(subsys_eventname,
-	TPPROTO(int firstarg, struct task_struct *p),
-	TPARGS(firstarg, p));
+	TP_PROTO(int firstarg, struct task_struct *p),
+	TP_ARGS(firstarg, p));
 
 In subsys/file.c (where the tracing statement must be added) :
 
@@ -66,10 +66,10 @@ Where :
     - subsys is the name of your subsystem.
     - eventname is the name of the event to trace.
 
-- TPPROTO(int firstarg, struct task_struct *p) is the prototype of the
+- TP_PROTO(int firstarg, struct task_struct *p) is the prototype of the
   function called by this tracepoint.
 
-- TPARGS(firstarg, p) are the parameters names, same as found in the
+- TP_ARGS(firstarg, p) are the parameters names, same as found in the
   prototype.
 
 Connecting a function (probe) to a tracepoint is done by providing a
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 152b2f0..3bcc3e1 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -31,8 +31,8 @@ struct tracepoint {
 					 * Keep in sync with vmlinux.lds.h.
 					 */
 
-#define TPPROTO(args...)	args
-#define TPARGS(args...)		args
+#define TP_PROTO(args...)	args
+#define TP_ARGS(args...)		args
 
 #ifdef CONFIG_TRACEPOINTS
 
@@ -65,7 +65,7 @@ struct tracepoint {
 	{								\
 		if (unlikely(__tracepoint_##name.state))		\
 			__DO_TRACE(&__tracepoint_##name,		\
-				TPPROTO(proto), TPARGS(args));		\
+				TP_PROTO(proto), TP_ARGS(args));	\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
diff --git a/include/trace/block.h b/include/trace/block.h
index 25c6a1f..25b7068 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -5,72 +5,72 @@
 #include <linux/tracepoint.h>
 
 DECLARE_TRACE(block_rq_abort,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 DECLARE_TRACE(block_rq_insert,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 DECLARE_TRACE(block_rq_issue,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 DECLARE_TRACE(block_rq_requeue,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 DECLARE_TRACE(block_rq_complete,
-	TPPROTO(struct request_queue *q, struct request *rq),
-		TPARGS(q, rq));
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 DECLARE_TRACE(block_bio_bounce,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 DECLARE_TRACE(block_bio_complete,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 DECLARE_TRACE(block_bio_backmerge,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 DECLARE_TRACE(block_bio_frontmerge,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 DECLARE_TRACE(block_bio_queue,
-	TPPROTO(struct request_queue *q, struct bio *bio),
-		TPARGS(q, bio));
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 DECLARE_TRACE(block_getrq,
-	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
-		TPARGS(q, bio, rw));
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	      TP_ARGS(q, bio, rw));
 
 DECLARE_TRACE(block_sleeprq,
-	TPPROTO(struct request_queue *q, struct bio *bio, int rw),
-		TPARGS(q, bio, rw));
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	      TP_ARGS(q, bio, rw));
 
 DECLARE_TRACE(block_plug,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
 
 DECLARE_TRACE(block_unplug_timer,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
 
 DECLARE_TRACE(block_unplug_io,
-	TPPROTO(struct request_queue *q),
-		TPARGS(q));
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
 
 DECLARE_TRACE(block_split,
-	TPPROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
-		TPARGS(q, bio, pdu));
+	TP_PROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
+	      TP_ARGS(q, bio, pdu));
 
 DECLARE_TRACE(block_remap,
-	TPPROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		sector_t from, sector_t to),
-		TPARGS(q, bio, dev, from, to));
+	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		 sector_t from, sector_t to),
+	      TP_ARGS(q, bio, dev, from, to));
 
 #endif
diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 65850bc..0147d9e 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -9,25 +9,25 @@
 #define TRACE_SYSTEM irq
 
 TRACE_EVENT_FORMAT(irq_handler_entry,
-	TPPROTO(int irq, struct irqaction *action),
-	TPARGS(irq, action),
-	TPFMT("irq=%d handler=%s", irq, action->name),
+	TP_PROTO(int irq, struct irqaction *action),
+	TP_ARGS(irq, action),
+	TP_FMT("irq=%d handler=%s", irq, action->name),
 	TRACE_STRUCT(
 		TRACE_FIELD(int, irq, irq)
 	),
-	TPRAWFMT("irq %d")
+	TP_RAW_FMT("irq %d")
 	);
 
 TRACE_EVENT_FORMAT(irq_handler_exit,
-	TPPROTO(int irq, struct irqaction *action, int ret),
-	TPARGS(irq, action, ret),
-	TPFMT("irq=%d handler=%s return=%s",
+	TP_PROTO(int irq, struct irqaction *action, int ret),
+	TP_ARGS(irq, action, ret),
+	TP_FMT("irq=%d handler=%s return=%s",
 		irq, action->name, ret ? "handled" : "unhandled"),
 	TRACE_STRUCT(
 		TRACE_FIELD(int, irq, irq)
 		TRACE_FIELD(int, ret, ret)
 	),
-	TPRAWFMT("irq %d ret %d")
+	TP_RAW_FMT("irq %d ret %d")
 	);
 
 #undef TRACE_SYSTEM
diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
index f713d74..1f00e8b 100644
--- a/include/trace/lockdep_event_types.h
+++ b/include/trace/lockdep_event_types.h
@@ -10,32 +10,32 @@
 #ifdef CONFIG_LOCKDEP
 
 TRACE_FORMAT(lock_acquire,
-	TPPROTO(struct lockdep_map *lock, unsigned int subclass,
+	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
 		int trylock, int read, int check,
 		struct lockdep_map *next_lock, unsigned long ip),
-	TPARGS(lock, subclass, trylock, read, check, next_lock, ip),
-	TPFMT("%s%s%s", trylock ? "try " : "",
+	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
+	TP_FMT("%s%s%s", trylock ? "try " : "",
 		read ? "read " : "", lock->name)
 	);
 
 TRACE_FORMAT(lock_release,
-	TPPROTO(struct lockdep_map *lock, int nested, unsigned long ip),
-	TPARGS(lock, nested, ip),
-	TPFMT("%s", lock->name)
+	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+	TP_ARGS(lock, nested, ip),
+	TP_FMT("%s", lock->name)
 	);
 
 #ifdef CONFIG_LOCK_STAT
 
 TRACE_FORMAT(lock_contended,
-	TPPROTO(struct lockdep_map *lock, unsigned long ip),
-	TPARGS(lock, ip),
-	TPFMT("%s", lock->name)
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+	TP_ARGS(lock, ip),
+	TP_FMT("%s", lock->name)
 	);
 
 TRACE_FORMAT(lock_acquired,
-	TPPROTO(struct lockdep_map *lock, unsigned long ip),
-	TPARGS(lock, ip),
-	TPFMT("%s", lock->name)
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+	TP_ARGS(lock, ip),
+	TP_FMT("%s", lock->name)
 	);
 
 #endif
diff --git a/include/trace/power.h b/include/trace/power.h
index 38aca53..ef20466 100644
--- a/include/trace/power.h
+++ b/include/trace/power.h
@@ -18,15 +18,15 @@ struct power_trace {
 };
 
 DECLARE_TRACE(power_start,
-	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
-		TPARGS(it, type, state));
+	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
+	      TP_ARGS(it, type, state));
 
 DECLARE_TRACE(power_mark,
-	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
-		TPARGS(it, type, state));
+	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
+	      TP_ARGS(it, type, state));
 
 DECLARE_TRACE(power_end,
-	TPPROTO(struct power_trace *it),
-		TPARGS(it));
+	TP_PROTO(struct power_trace *it),
+	      TP_ARGS(it));
 
 #endif /* _TRACE_POWER_H */
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index a6de5c1..71b1482 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -9,143 +9,143 @@
 #define TRACE_SYSTEM sched
 
 TRACE_EVENT_FORMAT(sched_kthread_stop,
-	TPPROTO(struct task_struct *t),
-	TPARGS(t),
-	TPFMT("task %s:%d", t->comm, t->pid),
+	TP_PROTO(struct task_struct *t),
+	TP_ARGS(t),
+	TP_FMT("task %s:%d", t->comm, t->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, t->pid)
 	),
-	TPRAWFMT("task %d")
+	TP_RAW_FMT("task %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_kthread_stop_ret,
-	TPPROTO(int ret),
-	TPARGS(ret),
-	TPFMT("ret=%d", ret),
+	TP_PROTO(int ret),
+	TP_ARGS(ret),
+	TP_FMT("ret=%d", ret),
 	TRACE_STRUCT(
 		TRACE_FIELD(int, ret, ret)
 	),
-	TPRAWFMT("ret=%d")
+	TP_RAW_FMT("ret=%d")
 	);
 
 TRACE_EVENT_FORMAT(sched_wait_task,
-	TPPROTO(struct rq *rq, struct task_struct *p),
-	TPARGS(rq, p),
-	TPFMT("task %s:%d", p->comm, p->pid),
+	TP_PROTO(struct rq *rq, struct task_struct *p),
+	TP_ARGS(rq, p),
+	TP_FMT("task %s:%d", p->comm, p->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 	),
-	TPRAWFMT("task %d")
+	TP_RAW_FMT("task %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_wakeup,
-	TPPROTO(struct rq *rq, struct task_struct *p, int success),
-	TPARGS(rq, p, success),
-	TPFMT("task %s:%d %s",
+	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	TP_ARGS(rq, p, success),
+	TP_FMT("task %s:%d %s",
 	      p->comm, p->pid, success ? "succeeded" : "failed"),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 		TRACE_FIELD(int, success, success)
 	),
-	TPRAWFMT("task %d success=%d")
+	TP_RAW_FMT("task %d success=%d")
 	);
 
 TRACE_EVENT_FORMAT(sched_wakeup_new,
-	TPPROTO(struct rq *rq, struct task_struct *p, int success),
-	TPARGS(rq, p, success),
-	TPFMT("task %s:%d",
+	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	TP_ARGS(rq, p, success),
+	TP_FMT("task %s:%d",
 	      p->comm, p->pid, success ? "succeeded" : "failed"),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 		TRACE_FIELD(int, success, success)
 	),
-	TPRAWFMT("task %d success=%d")
+	TP_RAW_FMT("task %d success=%d")
 	);
 
 TRACE_EVENT_FORMAT(sched_switch,
-	TPPROTO(struct rq *rq, struct task_struct *prev,
+	TP_PROTO(struct rq *rq, struct task_struct *prev,
 		struct task_struct *next),
-	TPARGS(rq, prev, next),
-	TPFMT("task %s:%d ==> %s:%d",
+	TP_ARGS(rq, prev, next),
+	TP_FMT("task %s:%d ==> %s:%d",
 	      prev->comm, prev->pid, next->comm, next->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, prev_pid, prev->pid)
 		TRACE_FIELD(int, prev_prio, prev->prio)
 		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
 				    next_comm,
-				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
+				    TP_CMD(memcpy(TRACE_ENTRY->next_comm,
 						 next->comm,
 						 TASK_COMM_LEN)))
 		TRACE_FIELD(pid_t, next_pid, next->pid)
 		TRACE_FIELD(int, next_prio, next->prio)
 	),
-	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
+	TP_RAW_FMT("prev %d:%d ==> next %s:%d:%d")
 	);
 
 TRACE_EVENT_FORMAT(sched_migrate_task,
-	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
-	TPARGS(p, orig_cpu, dest_cpu),
-	TPFMT("task %s:%d from: %d  to: %d",
+	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+	TP_ARGS(p, orig_cpu, dest_cpu),
+	TP_FMT("task %s:%d from: %d  to: %d",
 	      p->comm, p->pid, orig_cpu, dest_cpu),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 		TRACE_FIELD(int, orig_cpu, orig_cpu)
 		TRACE_FIELD(int, dest_cpu, dest_cpu)
 	),
-	TPRAWFMT("task %d  from: %d to: %d")
+	TP_RAW_FMT("task %d  from: %d to: %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_process_free,
-	TPPROTO(struct task_struct *p),
-	TPARGS(p),
-	TPFMT("task %s:%d", p->comm, p->pid),
+	TP_PROTO(struct task_struct *p),
+	TP_ARGS(p),
+	TP_FMT("task %s:%d", p->comm, p->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 	),
-	TPRAWFMT("task %d")
+	TP_RAW_FMT("task %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_process_exit,
-	TPPROTO(struct task_struct *p),
-	TPARGS(p),
-	TPFMT("task %s:%d", p->comm, p->pid),
+	TP_PROTO(struct task_struct *p),
+	TP_ARGS(p),
+	TP_FMT("task %s:%d", p->comm, p->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, p->pid)
 	),
-	TPRAWFMT("task %d")
+	TP_RAW_FMT("task %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_process_wait,
-	TPPROTO(struct pid *pid),
-	TPARGS(pid),
-	TPFMT("pid %d", pid_nr(pid)),
+	TP_PROTO(struct pid *pid),
+	TP_ARGS(pid),
+	TP_FMT("pid %d", pid_nr(pid)),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, pid, pid_nr(pid))
 	),
-	TPRAWFMT("task %d")
+	TP_RAW_FMT("task %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_process_fork,
-	TPPROTO(struct task_struct *parent, struct task_struct *child),
-	TPARGS(parent, child),
-	TPFMT("parent %s:%d  child %s:%d",
+	TP_PROTO(struct task_struct *parent, struct task_struct *child),
+	TP_ARGS(parent, child),
+	TP_FMT("parent %s:%d  child %s:%d",
 	      parent->comm, parent->pid, child->comm, child->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, parent, parent->pid)
 		TRACE_FIELD(pid_t, child, child->pid)
 	),
-	TPRAWFMT("parent %d  child %d")
+	TP_RAW_FMT("parent %d  child %d")
 	);
 
 TRACE_EVENT_FORMAT(sched_signal_send,
-	TPPROTO(int sig, struct task_struct *p),
-	TPARGS(sig, p),
-	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid),
+	TP_PROTO(int sig, struct task_struct *p),
+	TP_ARGS(sig, p),
+	TP_FMT("sig: %d   task %s:%d", sig, p->comm, p->pid),
 	TRACE_STRUCT(
 		TRACE_FIELD(int, sig, sig)
 		TRACE_FIELD(pid_t, pid, p->pid)
 	),
-	TPRAWFMT("sig: %d  task %d")
+	TP_RAW_FMT("sig: %d  task %d")
 	);
 
 #undef TRACE_SYSTEM
diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
index 867829d..7626523 100644
--- a/include/trace/workqueue.h
+++ b/include/trace/workqueue.h
@@ -6,20 +6,20 @@
 #include <linux/sched.h>
 
 DECLARE_TRACE(workqueue_insertion,
-	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TPARGS(wq_thread, work));
+	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+	   TP_ARGS(wq_thread, work));
 
 DECLARE_TRACE(workqueue_execution,
-	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TPARGS(wq_thread, work));
+	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+	   TP_ARGS(wq_thread, work));
 
 /* Trace the creation of one workqueue thread on a cpu */
 DECLARE_TRACE(workqueue_creation,
-	   TPPROTO(struct task_struct *wq_thread, int cpu),
-	   TPARGS(wq_thread, cpu));
+	   TP_PROTO(struct task_struct *wq_thread, int cpu),
+	   TP_ARGS(wq_thread, cpu));
 
 DECLARE_TRACE(workqueue_destruction,
-	   TPPROTO(struct task_struct *wq_thread),
-	   TPARGS(wq_thread));
+	   TP_PROTO(struct task_struct *wq_thread),
+	   TP_ARGS(wq_thread));
 
 #endif /* __TRACE_WORKQUEUE_H */
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index fb4eba1..d94179a 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -10,7 +10,7 @@ TRACE_EVENT_FORMAT(function, TRACE_FN, ftrace_entry, ignore,
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(unsigned long, parent_ip, parent_ip)
 	),
-	TPRAWFMT(" %lx <-- %lx")
+	TP_RAW_FMT(" %lx <-- %lx")
 );
 
 TRACE_EVENT_FORMAT(funcgraph_entry, TRACE_GRAPH_ENT,
@@ -19,7 +19,7 @@ TRACE_EVENT_FORMAT(funcgraph_entry, TRACE_GRAPH_ENT,
 		TRACE_FIELD(unsigned long, graph_ent.func, func)
 		TRACE_FIELD(int, graph_ent.depth, depth)
 	),
-	TPRAWFMT("--> %lx (%d)")
+	TP_RAW_FMT("--> %lx (%d)")
 );
 
 TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
@@ -28,7 +28,7 @@ TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
 		TRACE_FIELD(unsigned long, ret.func, func)
 		TRACE_FIELD(int, ret.depth, depth)
 	),
-	TPRAWFMT("<-- %lx (%d)")
+	TP_RAW_FMT("<-- %lx (%d)")
 );
 
 TRACE_EVENT_FORMAT(wakeup, TRACE_WAKE, ctx_switch_entry, ignore,
@@ -41,7 +41,7 @@ TRACE_EVENT_FORMAT(wakeup, TRACE_WAKE, ctx_switch_entry, ignore,
 		TRACE_FIELD(unsigned char, next_state, next_state)
 		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
 	),
-	TPRAWFMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
+	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
 );
 
 TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
@@ -54,7 +54,7 @@ TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
 		TRACE_FIELD(unsigned char, next_state, next_state)
 		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
 	),
-	TPRAWFMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
+	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
 );
 
 TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
@@ -63,7 +63,7 @@ TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
 		TRACE_FIELD(unsigned long, arg2, arg2)
 		TRACE_FIELD(unsigned long, arg3, arg3)
 	),
-	TPRAWFMT("(%08lx) (%08lx) (%08lx)")
+	TP_RAW_FMT("(%08lx) (%08lx) (%08lx)")
 );
 
 /*
@@ -83,7 +83,7 @@ TRACE_EVENT_FORMAT(kernel_stack, TRACE_STACK, stack_entry, ignore,
 		TRACE_FIELD(unsigned long, caller[6], stack6)
 		TRACE_FIELD(unsigned long, caller[7], stack7)
 	),
-	TPRAWFMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+	TP_RAW_FMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
 );
 
@@ -98,7 +98,7 @@ TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
 		TRACE_FIELD(unsigned long, caller[6], stack6)
 		TRACE_FIELD(unsigned long, caller[7], stack7)
 	),
-	TPRAWFMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+	TP_RAW_FMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
 );
 
@@ -108,7 +108,7 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 		TRACE_FIELD(unsigned int, depth, depth)
 		TRACE_FIELD_ZERO_CHAR(buf)
 	),
-	TPRAWFMT("%08lx (%d) %s")
+	TP_RAW_FMT("%08lx (%d) %s")
 );
 
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
@@ -118,7 +118,7 @@ TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file, file)
 		TRACE_FIELD(char, correct, correct)
 	),
-	TPRAWFMT("%u:%s:%s (%u)")
+	TP_RAW_FMT("%u:%s:%s (%u)")
 );
 
 TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
@@ -126,7 +126,7 @@ TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
 		TRACE_FIELD(u64, from, from)
 		TRACE_FIELD(u64, to, to)
 	),
-	TPRAWFMT("from: %llx to: %llx")
+	TP_RAW_FMT("from: %llx to: %llx")
 );
 
 TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
@@ -136,7 +136,7 @@ TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
 		TRACE_FIELD(int, state_data.type, type)
 		TRACE_FIELD(int, state_data.state, state)
 	),
-	TPRAWFMT("%llx->%llx type:%u state:%u")
+	TP_RAW_FMT("%llx->%llx type:%u state:%u")
 );
 
 TRACE_EVENT_FORMAT(kmem_alloc, TRACE_KMEM_ALLOC, kmemtrace_alloc_entry, ignore,
@@ -149,7 +149,7 @@ TRACE_EVENT_FORMAT(kmem_alloc, TRACE_KMEM_ALLOC, kmemtrace_alloc_entry, ignore,
 		TRACE_FIELD(gfp_t, gfp_flags, gfp_flags)
 		TRACE_FIELD(int, node, node)
 	),
-	TPRAWFMT("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
+	TP_RAW_FMT("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
 		 " flags:%x node:%d")
 );
 
@@ -159,7 +159,7 @@ TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
 		TRACE_FIELD(unsigned long, call_site, call_site)
 		TRACE_FIELD(const void *, ptr, ptr)
 	),
-	TPRAWFMT("type:%u call_site:%lx ptr:%p")
+	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
 );
 
 #undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index d24a97e..8e2e0f5 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -20,7 +20,7 @@
  *
  *	field = (typeof(field))entry;
  *
- *	ret = trace_seq_printf(s, <TPRAWFMT> "%s", <ARGS> "\n");
+ *	ret = trace_seq_printf(s, <TP_RAW_FMT> "%s", <ARGS> "\n");
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -44,8 +44,8 @@
 	field->item,
 
 
-#undef TPRAWFMT
-#define TPRAWFMT(args...)	args
+#undef TP_RAW_FMT
+#define TP_RAW_FMT(args...)	args
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 2c8d76c..557ca52 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -106,8 +106,8 @@
  *
  */
 
-#undef TPFMT
-#define TPFMT(fmt, args...)	fmt "\n", ##args
+#undef TP_FMT
+#define TP_FMT(fmt, args...)	fmt "\n", ##args
 
 #define _TRACE_FORMAT(call, proto, args, fmt)				\
 static void ftrace_event_##call(proto)					\
@@ -152,8 +152,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
 
-#undef TPCMD
-#define TPCMD(cmd...)	cmd
+#undef TP_CMD
+#define TP_CMD(cmd...)	cmd
 
 #undef TRACE_ENTRY
 #define TRACE_ENTRY	entry
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7162ab4..e62bc10 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -26,8 +26,8 @@
 		return 0;
 
 
-#undef TPRAWFMT
-#define TPRAWFMT(args...) args
+#undef TP_RAW_FMT
+#define TP_RAW_FMT(args...) args
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
@@ -57,8 +57,8 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
 
-#undef TPCMD
-#define TPCMD(cmd...)	cmd
+#undef TP_CMD
+#define TP_CMD(cmd...)	cmd
 
 #undef TRACE_ENTRY
 #define TRACE_ENTRY	entry
diff --git a/kernel/trace/trace_format.h b/kernel/trace/trace_format.h
deleted file mode 100644
index 97e59a9..0000000
--- a/kernel/trace/trace_format.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Setup the showing format of trace point.
- *
- * int
- * ftrace_format_##call(struct trace_seq *s)
- * {
- *	struct ftrace_raw_##call field;
- *	int ret;
- *
- *	ret = trace_seq_printf(s, #type " " #item ";"
- *			       " size:%d; offset:%d;\n",
- *			       sizeof(field.type),
- *			       offsetof(struct ftrace_raw_##call,
- *					item));
- *
- * }
- */
-
-#undef TRACE_STRUCT
-#define TRACE_STRUCT(args...) args
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
-	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field;					\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
-									\
-	return ret;							\
-}
-
diff --git a/samples/tracepoints/tp-samples-trace.h b/samples/tracepoints/tp-samples-trace.h
index 01724e0..dffdc49 100644
--- a/samples/tracepoints/tp-samples-trace.h
+++ b/samples/tracepoints/tp-samples-trace.h
@@ -5,9 +5,9 @@
 #include <linux/tracepoint.h>
 
 DECLARE_TRACE(subsys_event,
-	TPPROTO(struct inode *inode, struct file *file),
-	TPARGS(inode, file));
+	TP_PROTO(struct inode *inode, struct file *file),
+	TP_ARGS(inode, file));
 DECLARE_TRACE(subsys_eventb,
-	TPPROTO(void),
-	TPARGS());
+	TP_PROTO(void),
+	TP_ARGS());
 #endif
-- 
1.6.1.3

-- 
