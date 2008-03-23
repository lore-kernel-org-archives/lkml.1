Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbYCWOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbYCWOwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYCWOwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 10:52:43 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:37936 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYCWOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 10:52:42 -0400
Date: Sun, 23 Mar 2008 20:22:38 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RT] [PATCH 1/3] Change the names of rt_rq fields for
Message-ID: <20080323145238.GC15554@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Gregory Haskins <ghaskins@novell.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080323145029.GB15554@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323145029.GB15554@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

o Modify the names of several fields in the rt_rq, to be consistent
with the general naming convention. For eg, s/rt_nr_running/nr_running
in the rt_rq, 'rt' being implied by being associated with the rt_rq.


Signed-off-by: Ankita Garg <ankita@in.ibm.com> 

Index: linux-2.6.24.3/kernel/sched.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sched.c	2008-03-23 19:07:48.000000000 +0530
+++ linux-2.6.24.3/kernel/sched.c	2008-03-23 19:11:24.000000000 +0530
@@ -319,9 +319,9 @@
 	struct rt_prio_array active;
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
-	unsigned long rt_nr_running;
-	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_uninterruptible;
+	unsigned long nr_running;
+	unsigned long nr_migratory;
+	unsigned long nr_uninterruptible;
 	/* highest queued rt task prio */
 	int highest_prio;
 	int overloaded;
Index: linux-2.6.24.3/kernel/sched_debug.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sched_debug.c	2008-03-23 19:07:45.000000000 +0530
+++ linux-2.6.24.3/kernel/sched_debug.c	2008-03-23 19:09:35.000000000 +0530
@@ -188,8 +188,8 @@
 	P(cpu_load[4]);
 #ifdef CONFIG_PREEMPT_RT
 	/* Print rt related rq stats */
-	P(rt.rt_nr_running);
-	P(rt.rt_nr_uninterruptible);
+	P(rt.nr_running);
+	P(rt.nr_uninterruptible);
 # ifdef CONFIG_SCHEDSTATS
 	P(rto_schedule);
 	P(rto_schedule_tail);
Index: linux-2.6.24.3/kernel/sched_rt.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sched_rt.c	2008-03-23 19:07:47.000000000 +0530
+++ linux-2.6.24.3/kernel/sched_rt.c	2008-03-23 19:11:04.000000000 +0530
@@ -36,7 +36,7 @@
 	if (unlikely(num_online_cpus() == 1))
 		return;
 
-	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
+	if (rq->rt.nr_migratory && (rq->rt.nr_running > 1)) {
 		if (!rq->rt.overloaded) {
 			rt_set_overload(rq);
 			rq->rt.overloaded = 1;
@@ -74,14 +74,14 @@
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
 	WARN_ON(!rt_task(p));
-	rq->rt.rt_nr_running++;
+	rq->rt.nr_running++;
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio) {
 		rq->rt.highest_prio = p->prio;
 		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
 	}
 	if (p->nr_cpus_allowed > 1)
-		rq->rt.rt_nr_migratory++;
+		rq->rt.nr_migratory++;
 
 	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
@@ -93,10 +93,10 @@
 	int highest_prio = rq->rt.highest_prio;
 #endif
 	WARN_ON(!rt_task(p));
-	WARN_ON(!rq->rt.rt_nr_running);
-	rq->rt.rt_nr_running--;
+	WARN_ON(!rq->rt.nr_running);
+	rq->rt.nr_running--;
 #ifdef CONFIG_SMP
-	if (rq->rt.rt_nr_running) {
+	if (rq->rt.nr_running) {
 		struct rt_prio_array *array;
 
 		WARN_ON(p->prio < rq->rt.highest_prio);
@@ -109,8 +109,8 @@
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
 	if (p->nr_cpus_allowed > 1) {
-		BUG_ON(!rq->rt.rt_nr_migratory);
-		rq->rt.rt_nr_migratory--;
+		BUG_ON(!rq->rt.nr_migratory);
+		rq->rt.nr_migratory--;
 	}
 
 	if (rq->rt.highest_prio != highest_prio)
@@ -123,13 +123,13 @@
 static inline void incr_rt_nr_uninterruptible(struct task_struct *p,
 					      struct rq *rq)
 {
-	rq->rt.rt_nr_uninterruptible++;
+	rq->rt.nr_uninterruptible++;
 }
 
 static inline void decr_rt_nr_uninterruptible(struct task_struct *p,
 					      struct rq *rq)
 {
-	rq->rt.rt_nr_uninterruptible--;
+	rq->rt.nr_uninterruptible--;
 }
 
 unsigned long rt_nr_running(void)
@@ -137,14 +137,14 @@
 	unsigned long i, sum = 0;
 
 	for_each_online_cpu(i)
-		sum += cpu_rq(i)->rt.rt_nr_running;
+		sum += cpu_rq(i)->rt.nr_running;
 
 	return sum;
 }
 
 unsigned long rt_nr_running_cpu(int cpu)
 {
-	return cpu_rq(cpu)->rt.rt_nr_running;
+	return cpu_rq(cpu)->rt.nr_running;
 }
 
 unsigned long rt_nr_uninterruptible(void)
@@ -152,7 +152,7 @@
 	unsigned long i, sum = 0;
 
 	for_each_online_cpu(i)
-		sum += cpu_rq(i)->rt.rt_nr_uninterruptible;
+		sum += cpu_rq(i)->rt.nr_uninterruptible;
 
 	/*
 	 * Since we read the counters lockless, it might be slightly
@@ -166,7 +166,7 @@
 
 unsigned long rt_nr_uninterruptible_cpu(int cpu)
 {
-	return cpu_rq(cpu)->rt.rt_nr_uninterruptible;
+	return cpu_rq(cpu)->rt.nr_uninterruptible;
 }
 
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
@@ -313,12 +313,12 @@
 	struct list_head *queue;
 	int idx;
 
-	if (likely(rq->rt.rt_nr_running < 2))
+	if (likely(rq->rt.nr_running < 2))
 		return NULL;
 
 	idx = sched_find_first_bit(array->bitmap);
 	if (unlikely(idx >= MAX_RT_PRIO)) {
-		WARN_ON(1); /* rt_nr_running is bad */
+		WARN_ON(1); /* nr_running is bad */
 		return NULL;
 	}
 
@@ -622,7 +622,7 @@
 		/*
 		 * Are there still pullable RT tasks?
 		 */
-		if (src_rq->rt.rt_nr_running <= 1) {
+		if (src_rq->rt.nr_running <= 1) {
 			spin_unlock(&src_rq->lock);
 			continue;
 		}
@@ -745,10 +745,10 @@
 		struct rq *rq = task_rq(p);
 
 		if ((p->nr_cpus_allowed <= 1) && (weight > 1))
-			rq->rt.rt_nr_migratory++;
+			rq->rt.nr_migratory++;
 		else if((p->nr_cpus_allowed > 1) && (weight <= 1)) {
-			BUG_ON(!rq->rt.rt_nr_migratory);
-			rq->rt.rt_nr_migratory--;
+			BUG_ON(!rq->rt.nr_migratory);
+			rq->rt.nr_migratory--;
 		}
 
 		update_rt_migration(rq);
@@ -789,7 +789,7 @@
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!rq->rt.rt_nr_running)
+	if (!rq->rt.nr_running)
 		pull_rt_task(rq);
 }
 #endif /* CONFIG_SMP */

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
