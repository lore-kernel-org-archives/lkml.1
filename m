Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZGNSd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZGNSd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZGNSd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:33:28 -0400
Received: from www.tglx.de ([62.245.132.106]:40687 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbZGNSd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:33:27 -0400
Date: Tue, 14 Jul 2009 20:32:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] tracing fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907142031260.2777@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	tglx

------------------>
Li Zefan (1):
      tracing/events: Move TRACE_SYSTEM outside of include guard

Steven Rostedt (1):
      tracing/function-profiler: do not free per cpu variable stat


 fs/gfs2/trace_gfs2.h                       |    8 +++---
 include/trace/events/block.h               |    6 ++--
 include/trace/events/ext4.h                |    6 ++--
 include/trace/events/irq.h                 |    6 ++--
 include/trace/events/jbd2.h                |    6 ++--
 include/trace/events/kmem.h                |    6 ++--
 include/trace/events/lockdep.h             |    6 ++--
 include/trace/events/sched.h               |    6 ++--
 include/trace/events/skb.h                 |    6 ++--
 include/trace/events/workqueue.h           |    6 ++--
 kernel/trace/ftrace.c                      |    5 +--
 samples/trace_events/trace-events-sample.h |   37 +++++++++++++++-------------
 12 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 98d6ef1..148d55c 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -1,12 +1,11 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM gfs2
+
 #if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_GFS2_H
 
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM gfs2
-#define TRACE_INCLUDE_FILE trace_gfs2
-
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/dlmconstants.h>
@@ -403,5 +402,6 @@ TRACE_EVENT(gfs2_block_alloc,
 /* This part must be outside protection */
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_gfs2
 #include <trace/define_trace.h>
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d6b05f4..9a74b46 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -1,3 +1,6 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM block
+
 #if !defined(_TRACE_BLOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_BLOCK_H
 
@@ -5,9 +8,6 @@
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM block
-
 TRACE_EVENT(block_rq_abort,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index acf4cc9..8eb82cc 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1,9 +1,9 @@
-#if !defined(_TRACE_EXT4_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_EXT4_H
-
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ext4
 
+#if !defined(_TRACE_EXT4_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EXT4_H
+
 #include <linux/writeback.h>
 #include "../../../fs/ext4/ext4.h"
 #include "../../../fs/ext4/mballoc.h"
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index b0c7ede..1cb0c3a 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq
+
 #if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_IRQ_H
 
 #include <linux/tracepoint.h>
 #include <linux/interrupt.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM irq
-
 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
 #define show_softirq_name(val)			\
 	__print_symbolic(val,			\
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 845b0b4..10813fa 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM jbd2
+
 #if !defined(_TRACE_JBD2_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_JBD2_H
 
 #include <linux/jbd2.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM jbd2
-
 TRACE_EVENT(jbd2_checkpoint,
 
 	TP_PROTO(journal_t *journal, int result),
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 9baba50..1493c54 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kmem
+
 #if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_KMEM_H
 
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM kmem
-
 /*
  * The order of these masks is important. Matching masks will be seen
  * first and the left over flags will end up showing by themselves.
diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 0e956c9..bcf1d20 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM lockdep
+
 #if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_LOCKDEP_H
 
 #include <linux/lockdep.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM lockdep
-
 #ifdef CONFIG_LOCKDEP
 
 TRACE_EVENT(lock_acquire,
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 24ab5bc..8949bb7 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sched
+
 #if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_SCHED_H
 
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM sched
-
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
  */
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1e8fabb..e499863 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -1,12 +1,12 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM skb
+
 #if !defined(_TRACE_SKB_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_SKB_H
 
 #include <linux/skbuff.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM skb
-
 /*
  * Tracepoint for free an sk_buff:
  */
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 035f1bf..fcfd9a1 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -1,3 +1,6 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM workqueue
+
 #if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_WORKQUEUE_H
 
@@ -5,9 +8,6 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM workqueue
-
 TRACE_EVENT(workqueue_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bce9e01..4521c77 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -768,7 +768,7 @@ static struct tracer_stat function_stats __initdata = {
 	.stat_show	= function_stat_show
 };
 
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -786,7 +786,6 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 			 * The files created are permanent, if something happens
 			 * we still do not free memory.
 			 */
-			kfree(stat);
 			WARN(1,
 			     "Could not allocate stat file for cpu %d\n",
 			     cpu);
@@ -813,7 +812,7 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 9977a75..f24ae37 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -1,21 +1,4 @@
 /*
- * Notice that this file is not protected like a normal header.
- * We also must allow for rereading of this file. The
- *
- *  || defined(TRACE_HEADER_MULTI_READ)
- *
- * serves this purpose.
- */
-#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_EVENT_SAMPLE_H
-
-/*
- * All trace headers should include tracepoint.h, until we finally
- * make it into a standard header.
- */
-#include <linux/tracepoint.h>
-
-/*
  * If TRACE_SYSTEM is defined, that will be the directory created
  * in the ftrace directory under /debugfs/tracing/events/<system>
  *
@@ -34,11 +17,31 @@
  * #define TRACE_INCLUDE_FILE trace-events-sample
  *
  * As we do an the bottom of this file.
+ *
+ * Notice that TRACE_SYSTEM should be defined outside of #if
+ * protection, just like TRACE_INCLUDE_FILE.
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sample
 
 /*
+ * Notice that this file is not protected like a normal header.
+ * We also must allow for rereading of this file. The
+ *
+ *  || defined(TRACE_HEADER_MULTI_READ)
+ *
+ * serves this purpose.
+ */
+#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENT_SAMPLE_H
+
+/*
+ * All trace headers should include tracepoint.h, until we finally
+ * make it into a standard header.
+ */
+#include <linux/tracepoint.h>
+
+/*
  * The TRACE_EVENT macro is broken up into 5 parts.
  *
  * name: name of the trace point. This is also how to enable the tracepoint.
