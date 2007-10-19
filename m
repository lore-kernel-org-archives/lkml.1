Return-Path: <linux-kernel-owner+w=401wt.eu-S966245AbXJSSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966245AbXJSSrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935050AbXJSSo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:44:29 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55368 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762699AbXJSSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:44:16 -0400
Message-Id: <20071019184336.826217430@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Oct 2007 14:42:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 5/8] Move prototypes together.
Content-Disposition: inline; filename=mov-protos.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A later patch uses some of the functions that were declared, and
this patch is used to move those prototypes up with other prototypes
that were declared.

This patch is mainly for prettiness.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 kernel/sched_rt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:35:58.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:36:02.000000000 -0400
@@ -28,6 +28,8 @@ static void update_curr_rt(struct rq *rq
 #ifdef CONFIG_SMP
 static __cacheline_aligned_in_smp atomic_t rt_overload;
 static cpumask_t rto_cpumask;
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
+static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 #endif /* CONFIG_SMP*/
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -133,9 +135,6 @@ static struct task_struct *pick_next_tas
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
-
 static inline void rq_prio_add_task(struct rq *rq, struct task_struct *p)
 {
 	if (unlikely(rt_task(p)) && p->prio < rq->highest_prio)

-- 
