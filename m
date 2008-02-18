Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYBRMWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYBRMWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbYBRMWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:22:31 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:21113 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbYBRMWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:22:30 -0500
Message-ID: <47B9785A.4080108@siemens.com>
Date: Mon, 18 Feb 2008 13:21:46 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Gautham R Shenoy <ego@in.ibm.com>, mathieu.desnoyers@polymtl.ca,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] Markers Implementation for RCU Tracing - Ver II
References: <20071231060911.GB6461@in.ibm.com> <20080103163055.GB27651@Krystal> <20080104105858.GA13865@in.ibm.com> <20080105124632.GA16576@Krystal> <20080107195038.GA5119@in.ibm.com>
In-Reply-To: <20080107195038.GA5119@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K. Prasad wrote:
> Hi Ingo,
> 	Please accept these patches into the rt tree which convert the
> existing RCU tracing mechanism for Preempt RCU and RCU Boost into
> markers.
>  
> These patches are based upon the 2.6.24-rc5-rt1 kernel tree.
>  
> Along with marker transition, the RCU Tracing infrastructure has also
> been modularised to be built as a kernel module, thereby enabling
> runtime changes to the RCU Tracing infrastructure.
>  
> Patch [1/2] - Patch that converts the Preempt RCU tracing in
> rcupreempt.c into markers.
>  
> Patch [1/2] - Patch that converts the Preempt RCU Boost tracing in
> rcupreempt-boost.c into markers.
>  
> Thanks,
> K.Prasad
> (prasad@linux.vnet.ibm.com)

The correct marker annotation for "no arguments" is MARK_NOARGS.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 kernel/rcupreempt-boost.c |   24 ++++++++++++------------
 kernel/rcupreempt.c       |   42 +++++++++++++++++++++---------------------
 2 files changed, 33 insertions(+), 33 deletions(-)

Index: b/kernel/rcupreempt-boost.c
===================================================================
--- a/kernel/rcupreempt-boost.c
+++ b/kernel/rcupreempt-boost.c
@@ -57,10 +57,10 @@ static void rcu_boost_task(struct task_s
 	WARN_ON(!irqs_disabled());
 	WARN_ON_SMP(!spin_is_locked(&task->pi_lock));
 
-	trace_mark(task_boost_called, "NULL");
+	trace_mark(task_boost_called, MARK_NOARGS);
 
 	if (task->rcu_prio < task->prio) {
-		trace_mark(task_boosted, "NULL");
+		trace_mark(task_boosted, MARK_NOARGS);
 		task_setprio(task, task->rcu_prio);
 	}
 }
@@ -84,7 +84,7 @@ void __rcu_preempt_boost(void)
 
 	WARN_ON(!current->rcu_read_lock_nesting);
 
-	trace_mark(boost_called, "NULL");
+	trace_mark(boost_called, MARK_NOARGS);
 
 	/* check to see if we are already boosted */
 	if (unlikely(rcu_is_boosted(curr)))
@@ -102,7 +102,7 @@ void __rcu_preempt_boost(void)
 
 	curr->rcub_rbdp = rbd;
 
-	trace_mark(try_boost, "NULL");
+	trace_mark(try_boost, MARK_NOARGS);
 
 	prio = rt_mutex_getprio(curr);
 
@@ -111,7 +111,7 @@ void __rcu_preempt_boost(void)
 	if (prio <= rbd->rbs_prio)
 		goto out;
 
-	trace_mark(boosted, "NULL");
+	trace_mark(boosted, MARK_NOARGS);
 
 	curr->rcu_prio = rbd->rbs_prio;
 	rcu_boost_task(curr);
@@ -136,7 +136,7 @@ void __rcu_preempt_unboost(void)
 	int prio;
 	unsigned long flags;
 
-	trace_mark(unboost_called, "NULL");
+	trace_mark(unboost_called, MARK_NOARGS);
 
 	/* if not boosted, then ignore */
 	if (likely(!rcu_is_boosted(curr)))
@@ -174,7 +174,7 @@ void __rcu_preempt_unboost(void)
 
 	list_del_init(&curr->rcub_entry);
 
-	trace_mark(unboosted, "NULL");
+	trace_mark(unboosted, MARK_NOARGS);
 
 	curr->rcu_prio = MAX_PRIO;
 
@@ -235,7 +235,7 @@ static int __rcu_boost_readers(struct rc
 		 * Another task may have taken over.
 		 */
 		if (curr->rcu_preempt_counter != rcu_boost_counter) {
-			trace_mark(over_taken, "NULL");
+			trace_mark(over_taken, MARK_NOARGS);
 			return 1;
 		}
 
@@ -266,7 +266,7 @@ void rcu_boost_readers(void)
 
 	prio = rt_mutex_getprio(curr);
 
-	trace_mark(try_boost_readers, "NULL");
+	trace_mark(try_boost_readers, MARK_NOARGS);
 
 	if (prio >= rcu_boost_prio) {
 		/* already boosted */
@@ -276,7 +276,7 @@ void rcu_boost_readers(void)
 
 	rcu_boost_prio = prio;
 
-	trace_mark(boost_readers, "NULL");
+	trace_mark(boost_readers, MARK_NOARGS);
 
 	/* Flag that we are the one to unboost */
 	curr->rcu_preempt_counter = ++rcu_boost_counter;
@@ -309,12 +309,12 @@ void rcu_unboost_readers(void)
 
 	spin_lock_irqsave(&rcu_boost_wake_lock, flags);
 
-	trace_mark(try_unboost_readers, "NULL");
+	trace_mark(try_unboost_readers, MARK_NOARGS);
 
 	if (current->rcu_preempt_counter != rcu_boost_counter)
 		goto out;
 
-	trace_mark(unboost_readers, "NULL");
+	trace_mark(unboost_readers, MARK_NOARGS);
 
 	/*
 	 * We could also put in something that
Index: b/kernel/rcupreempt.c
===================================================================
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -308,7 +308,7 @@ static void __rcu_advance_callbacks(stru
 		if (rdp->waitlist[GP_STAGES - 1] != NULL) {
 			*rdp->donetail = rdp->waitlist[GP_STAGES - 1];
 			rdp->donetail = rdp->waittail[GP_STAGES - 1];
-			trace_mark(rcupreempt_trace_move2done, "NULL");
+			trace_mark(rcupreempt_trace_move2done, MARK_NOARGS);
 		}
 		for (i = GP_STAGES - 2; i >= 0; i--) {
 			if (rdp->waitlist[i] != NULL) {
@@ -327,7 +327,7 @@ static void __rcu_advance_callbacks(stru
 			wlc++;
 			rdp->nextlist = NULL;
 			rdp->nexttail = &rdp->nextlist;
-			trace_mark(rcupreempt_trace_move2wait, "NULL");
+			trace_mark(rcupreempt_trace_move2wait, MARK_NOARGS);
 		} else {
 			rdp->waitlist[0] = NULL;
 			rdp->waittail[0] = &rdp->waitlist[0];
@@ -571,9 +571,9 @@ rcu_try_flip_idle(void)
 {
 	int cpu;
 
-	trace_mark(rcupreempt_trace_try_flip_i1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_i1, MARK_NOARGS);
 	if (!rcu_pending(smp_processor_id())) {
-		trace_mark(rcupreempt_trace_try_flip_ie1, "NULL");
+		trace_mark(rcupreempt_trace_try_flip_ie1, MARK_NOARGS);
 		return 0;
 	}
 
@@ -581,7 +581,7 @@ rcu_try_flip_idle(void)
 	 * Do the flip.
 	 */
 
-	trace_mark(rcupreempt_trace_try_flip_g1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_g1, MARK_NOARGS);
 	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
 
 	/*
@@ -611,11 +611,11 @@ rcu_try_flip_waitack(void)
 {
 	int cpu;
 
-	trace_mark(rcupreempt_trace_try_flip_a1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_a1, MARK_NOARGS);
 	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
-			trace_mark(rcupreempt_trace_try_flip_ae1, "NULL");
+			trace_mark(rcupreempt_trace_try_flip_ae1, MARK_NOARGS);
 			return 0;
 		}
 
@@ -625,7 +625,7 @@ rcu_try_flip_waitack(void)
 	 */
 
 	smp_mb();	/* see above block comment. */
-	trace_mark(rcupreempt_trace_try_flip_a2, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_a2, MARK_NOARGS);
 	return 1;
 }
 
@@ -643,11 +643,11 @@ rcu_try_flip_waitzero(void)
 
 	/* Check to see if the sum of the "last" counters is zero. */
 
-	trace_mark(rcupreempt_trace_try_flip_z1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_z1, MARK_NOARGS);
 	for_each_possible_cpu(cpu)
 		sum += per_cpu(rcu_flipctr, cpu)[lastidx];
 	if (sum != 0) {
-		trace_mark(rcupreempt_trace_try_flip_ze1, "NULL");
+		trace_mark(rcupreempt_trace_try_flip_ze1, MARK_NOARGS);
 		return 0;
 	}
 
@@ -660,7 +660,7 @@ rcu_try_flip_waitzero(void)
 		dyntick_save_progress_counter(cpu);
 	}
 
-	trace_mark(rcupreempt_trace_try_flip_z2, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_z2, MARK_NOARGS);
 	return 1;
 }
 
@@ -674,16 +674,16 @@ rcu_try_flip_waitmb(void)
 {
 	int cpu;
 
-	trace_mark(rcupreempt_trace_try_flip_m1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_m1, MARK_NOARGS);
 	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
-			trace_mark(rcupreempt_trace_try_flip_me1, "NULL");
+			trace_mark(rcupreempt_trace_try_flip_me1, MARK_NOARGS);
 			return 0;
 		}
 
 	smp_mb(); /* Ensure that the above checks precede any following flip. */
-	trace_mark(rcupreempt_trace_try_flip_m2, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_m2, MARK_NOARGS);
 	return 1;
 }
 
@@ -700,9 +700,9 @@ static void rcu_try_flip(void)
 {
 	unsigned long oldirq;
 
-	trace_mark(rcupreempt_trace_try_flip_1, "NULL");
+	trace_mark(rcupreempt_trace_try_flip_1, MARK_NOARGS);
 	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, oldirq))) {
-		trace_mark(rcupreempt_trace_try_flip_e1, "NULL");
+		trace_mark(rcupreempt_trace_try_flip_e1, MARK_NOARGS);
 		return;
 	}
 
@@ -754,7 +754,7 @@ void rcu_check_callbacks_rt(int cpu, int
 	if (rcu_ctrlblk.completed == rdp->completed)
 		rcu_try_flip();
 	spin_lock_irqsave(&rdp->lock, oldirq);
-	trace_mark(rcupreempt_trace_check_callbacks, "NULL");
+	trace_mark(rcupreempt_trace_check_callbacks, MARK_NOARGS);
 	__rcu_advance_callbacks(rdp);
 	spin_unlock_irqrestore(&rdp->lock, oldirq);
 }
@@ -774,7 +774,7 @@ void rcu_advance_callbacks_rt(int cpu, i
 			return;
 	}
 	spin_lock_irqsave(&rdp->lock, oldirq);
-	trace_mark(rcupreempt_trace_check_callbacks, "NULL");
+	trace_mark(rcupreempt_trace_check_callbacks, MARK_NOARGS);
 	__rcu_advance_callbacks(rdp);
 	spin_unlock_irqrestore(&rdp->lock, oldirq);
 }
@@ -876,13 +876,13 @@ void rcu_process_callbacks_rt(struct sof
 	}
 	rdp->donelist = NULL;
 	rdp->donetail = &rdp->donelist;
-	trace_mark(rcupreempt_trace_done_remove, "NULL");
+	trace_mark(rcupreempt_trace_done_remove, MARK_NOARGS);
 	spin_unlock_irqrestore(&rdp->lock, flags);
 	while (list) {
 		next = list->next;
 		list->func(list);
 		list = next;
-		trace_mark(rcupreempt_trace_invoke, "NULL");
+		trace_mark(rcupreempt_trace_invoke, MARK_NOARGS);
 	}
 }
 
@@ -900,7 +900,7 @@ void fastcall call_rcu_preempt(struct rc
 	__rcu_advance_callbacks(rdp);
 	*rdp->nexttail = head;
 	rdp->nexttail = &head->next;
-	trace_mark(rcupreempt_trace_next_add, "NULL");
+	trace_mark(rcupreempt_trace_next_add, MARK_NOARGS);
 	spin_unlock(&rdp->lock);
 	local_irq_restore(oldirq);
 }
