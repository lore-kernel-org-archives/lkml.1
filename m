Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbZCYPr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbZCYPr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZCYPrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:47:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbZCYPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:47:45 -0400
Message-Id: <20090325154742.999233198@goodmis.org>
References: <20090325154538.916038098@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 11:45:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3 v2] sched: remove unlikelys from sched_move_task
Content-Disposition: inline; filename=0002-sched-remove-unlikelys-from-sched_move_task.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

We seem to be moving running tasks more than non running tasks.
I guess tasks like to move themselves.

These are also candidates for likely:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0    10027 100 sched_move_task                sched.c              8918
       0    10027 100 sched_move_task                sched.c              8908

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..5a60745 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8905,7 +8905,7 @@ void sched_move_task(struct task_struct *tsk)
 
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
-	if (unlikely(running))
+	if (running)
 		tsk->sched_class->put_prev_task(rq, tsk);
 
 	set_task_rq(tsk, task_cpu(tsk));
@@ -8915,7 +8915,7 @@ void sched_move_task(struct task_struct *tsk)
 		tsk->sched_class->moved_group(tsk);
 #endif
 
-	if (unlikely(running))
+	if (running)
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-- 
1.6.2

-- 
