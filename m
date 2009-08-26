Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZHZFAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZHZFAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZHZFAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZHZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:50 -0400
Message-Id: <20090826050050.522016187@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/8] tracing/sched: show CPU task wakes up on in trace event
Content-Disposition: inline; filename=0001-tracing-sched-show-CPU-task-wakes-up-on-in-trace-eve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

While debugging the scheduler push / pull algorithm, I found
it very annoying that the sched wake up events did not show
the CPU that the task was waking on. In order to analyze the
scheduler, I needed that information.

This patch adds recording of the CPU that a task is waking up
on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 8949bb7..a581ef2 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -94,6 +94,7 @@ TRACE_EVENT(sched_wakeup,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
+		__field(	int,	cpu			)
 	),
 
 	TP_fast_assign(
@@ -101,11 +102,12 @@ TRACE_EVENT(sched_wakeup,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
+		__entry->cpu		= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
+	TP_printk("task %s:%d [%d] success=%d [%03d]",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+		  __entry->success, __entry->cpu)
 );
 
 /*
@@ -125,6 +127,7 @@ TRACE_EVENT(sched_wakeup_new,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
+		__field(	int,	cpu			)
 	),
 
 	TP_fast_assign(
@@ -132,11 +135,12 @@ TRACE_EVENT(sched_wakeup_new,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
+		__entry->cpu		= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
+	TP_printk("task %s:%d [%d] success=%d [%03d]",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+		  __entry->success, __entry->cpu)
 );
 
 /*
-- 
1.6.3.3

-- 
