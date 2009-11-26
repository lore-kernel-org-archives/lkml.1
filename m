Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZKZInj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZKZInj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZKZIni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:43:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:58686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbZKZInh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:43:37 -0500
Date: Thu, 26 Nov 2009 08:43:18 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E289F.5010104@cn.fujitsu.com>
References: <4B0E289F.5010104@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some workqueue events to DEFINE_EVENT
Message-ID: <tip-382ece710bf88b08440b598731361e5a47582b62@git.kernel.org>
Git-Commit-ID: 382ece710bf88b08440b598731361e5a47582b62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  382ece710bf88b08440b598731361e5a47582b62
Gitweb:     http://git.kernel.org/tip/382ece710bf88b08440b598731361e5a47582b62
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:05:03 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:03 +0100

tracing: Convert some workqueue events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  13171     800      72   14043    36db kernel/workqueue.o.old
  12243     800      68   13111    3337 kernel/workqueue.o

Two events are converted:

  workqueue: workqueue_insertion, workqueue_execution

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E289F.5010104@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/workqueue.h |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index e4612db..d6c9744 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,7 +8,7 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(workqueue_insertion,
+DECLARE_EVENT_CLASS(workqueue,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -30,26 +30,18 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_execution,
+DEFINE_EVENT(workqueue, workqueue_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
-	TP_ARGS(wq_thread, work),
+	TP_ARGS(wq_thread, work)
+);
 
-	TP_STRUCT__entry(
-		__array(char,		thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,		thread_pid)
-		__field(work_func_t,	func)
-	),
+DEFINE_EVENT(workqueue, workqueue_execution,
 
-	TP_fast_assign(
-		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
-		__entry->thread_pid	= wq_thread->pid;
-		__entry->func		= work->func;
-	),
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
-	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
+	TP_ARGS(wq_thread, work)
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
