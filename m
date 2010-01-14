Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0ANDVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0ANDVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993Ab0ANDVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:21:44 -0500
Received: from [206.15.93.42] ([206.15.93.42]:20763 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751612Ab0ANDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:21:44 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sched: don't expose local functions
Date: Wed, 13 Jan 2010 20:21:52 -0700
Cc: mingo@elte.hu, peterz@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001132021.53253.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched: don't expose local functions

The get_rr_interval_* functions are all class methods of
struct sched_class. They are not exported so make them
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>

---

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..7177860 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2076,7 +2076,7 @@ static void moved_group_fair(struct task_struct *p, int on_rq)
 }
 #endif
 
-unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
 	unsigned int rr_interval = 0;
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 5f93b57..01332bf 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..072b3fc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1721,7 +1721,7 @@ static void set_curr_task_rt(struct rq *rq)
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks
