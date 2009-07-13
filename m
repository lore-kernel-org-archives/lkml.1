Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZGMJCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZGMJCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZGMJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:02:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:39962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZGMJCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:02:14 -0400
Date: Mon, 13 Jul 2009 09:01:32 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A5A9CF1.2010007@cn.fujitsu.com>
References: <4A5A9CF1.2010007@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/events: Move TRACE_SYSTEM outside of include guard
Message-ID: <tip-d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a@git.kernel.org>
Git-Commit-ID: d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 09:01:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a
Gitweb:     http://git.kernel.org/tip/d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 13 Jul 2009 10:33:21 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 10:59:55 +0200

tracing/events: Move TRACE_SYSTEM outside of include guard

If TRACE_INCLDUE_FILE is defined, <trace/events/TRACE_INCLUDE_FILE.h>
will be included and compiled, otherwise it will be
<trace/events/TRACE_SYSTEM.h>

So TRACE_SYSTEM should be defined outside of #if proctection,
just like TRACE_INCLUDE_FILE.

Imaging this scenario:

 #include <trace/events/foo.h>
    -> TRACE_SYSTEM == foo
 ...
 #include <trace/events/bar.h>
    -> TRACE_SYSTEM == bar
 ...
 #define CREATE_TRACE_POINTS
 #include <trace/events/foo.h>
    -> TRACE_SYSTEM == bar !!!

and then bar.h will be included and compiled.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A5A9CF1.2010007@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
 samples/trace_events/trace-events-sample.h |   37 +++++++++++++++-------------
 11 files changed, 51 insertions(+), 48 deletions(-)

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
