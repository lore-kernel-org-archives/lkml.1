Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZGCI7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZGCI7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZGCI6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:58:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbZGCI6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:58:43 -0400
Date: Fri, 3 Jul 2009 08:58:08 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12459460981342-git-send-email->
References: <12459460981342-git-send-email->
Subject: [tip:core/rcu] rcu: Add synchronize_sched_expedited() torture tests
Message-ID: <tip-0acc512cb1a29636df5e982c7d845edafe77c2d0@git.kernel.org>
Git-Commit-ID: 0acc512cb1a29636df5e982c7d845edafe77c2d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 08:58:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0acc512cb1a29636df5e982c7d845edafe77c2d0
Gitweb:     http://git.kernel.org/tip/0acc512cb1a29636df5e982c7d845edafe77c2d0
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 25 Jun 2009 09:08:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 10:02:29 +0200

rcu: Add synchronize_sched_expedited() torture tests

This patch adds rcutorture tests for the new
synchronize_sched_expedited() primitive, and also does some
whitespace cleanups in kernel/rcutorture.c as well.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org
Cc: davem@davemloft.net
Cc: dada1@cosmosbay.com
Cc: zbr@ioremap.net
Cc: jeff.chua.linux@gmail.com
Cc: paulus@samba.org
Cc: laijs@cn.fujitsu.com
Cc: jengelh@medozas.de
Cc: r000n@r000n.net
Cc: benh@kernel.crashing.org
Cc: mathieu.desnoyers@polymtl.ca
LKML-Reference: <12459460981342-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutorture.c |  202 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 110 insertions(+), 92 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9b4a975..b33db53 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -257,14 +257,14 @@ struct rcu_torture_ops {
 	void (*init)(void);
 	void (*cleanup)(void);
 	int (*readlock)(void);
-	void (*readdelay)(struct rcu_random_state *rrsp);
+	void (*read_delay)(struct rcu_random_state *rrsp);
 	void (*readunlock)(int idx);
 	int (*completed)(void);
-	void (*deferredfree)(struct rcu_torture *p);
+	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*cb_barrier)(void);
 	int (*stats)(char *page);
-	int irqcapable;
+	int irq_capable;
 	char *name;
 };
 static struct rcu_torture_ops *cur_ops = NULL;
@@ -320,7 +320,7 @@ rcu_torture_cb(struct rcu_head *p)
 		rp->rtort_mbtest = 0;
 		rcu_torture_free(rp);
 	} else
-		cur_ops->deferredfree(rp);
+		cur_ops->deferred_free(rp);
 }
 
 static void rcu_torture_deferred_free(struct rcu_torture *p)
@@ -329,18 +329,18 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops rcu_ops = {
-	.init = NULL,
-	.cleanup = NULL,
-	.readlock = rcu_torture_read_lock,
-	.readdelay = rcu_read_delay,
-	.readunlock = rcu_torture_read_unlock,
-	.completed = rcu_torture_completed,
-	.deferredfree = rcu_torture_deferred_free,
-	.sync = synchronize_rcu,
-	.cb_barrier = rcu_barrier,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu"
+	.init		= NULL,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_torture_completed,
+	.deferred_free	= rcu_torture_deferred_free,
+	.sync		= synchronize_rcu,
+	.cb_barrier	= rcu_barrier,
+	.stats		= NULL,
+	.irq_capable 	= 1,
+	.name 		= "rcu"
 };
 
 static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
@@ -370,18 +370,18 @@ static void rcu_sync_torture_init(void)
 }
 
 static struct rcu_torture_ops rcu_sync_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = rcu_torture_read_lock,
-	.readdelay = rcu_read_delay,
-	.readunlock = rcu_torture_read_unlock,
-	.completed = rcu_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = synchronize_rcu,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_sync"
 };
 
 /*
@@ -432,33 +432,33 @@ static void rcu_bh_torture_synchronize(void)
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
-	.init = NULL,
-	.cleanup = NULL,
-	.readlock = rcu_bh_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = rcu_bh_torture_read_unlock,
-	.completed = rcu_bh_torture_completed,
-	.deferredfree = rcu_bh_torture_deferred_free,
-	.sync = rcu_bh_torture_synchronize,
-	.cb_barrier = rcu_barrier_bh,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_bh"
+	.init		= NULL,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_bh_torture_deferred_free,
+	.sync		= rcu_bh_torture_synchronize,
+	.cb_barrier	= rcu_barrier_bh,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh"
 };
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = rcu_bh_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = rcu_bh_torture_read_unlock,
-	.completed = rcu_bh_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = rcu_bh_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_bh_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= rcu_bh_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh_sync"
 };
 
 /*
@@ -530,17 +530,17 @@ static int srcu_torture_stats(char *page)
 }
 
 static struct rcu_torture_ops srcu_ops = {
-	.init = srcu_torture_init,
-	.cleanup = srcu_torture_cleanup,
-	.readlock = srcu_torture_read_lock,
-	.readdelay = srcu_read_delay,
-	.readunlock = srcu_torture_read_unlock,
-	.completed = srcu_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = srcu_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = srcu_torture_stats,
-	.name = "srcu"
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu"
 };
 
 /*
@@ -574,32 +574,49 @@ static void sched_torture_synchronize(void)
 }
 
 static struct rcu_torture_ops sched_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = sched_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = sched_torture_read_unlock,
-	.completed = sched_torture_completed,
-	.deferredfree = rcu_sched_torture_deferred_free,
-	.sync = sched_torture_synchronize,
-	.cb_barrier = rcu_barrier_sched,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "sched"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sched_torture_deferred_free,
+	.sync		= sched_torture_synchronize,
+	.cb_barrier	= rcu_barrier_sched,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "sched"
 };
 
 static struct rcu_torture_ops sched_ops_sync = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = sched_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = sched_torture_read_unlock,
-	.completed = sched_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = sched_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.name = "sched_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= sched_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.name		= "sched_sync"
+};
+
+extern int rcu_expedited_torture_stats(char *page);
+
+static struct rcu_torture_ops sched_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_sched_expedited,
+	.cb_barrier	= NULL,
+	.stats		= rcu_expedited_torture_stats,
+	.irq_capable	= 1,
+	.name		= "sched_expedited"
 };
 
 /*
@@ -635,7 +652,7 @@ rcu_torture_writer(void *arg)
 				i = RCU_TORTURE_PIPE_LEN;
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
-			cur_ops->deferredfree(old_rp);
+			cur_ops->deferred_free(old_rp);
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
@@ -700,7 +717,7 @@ static void rcu_torture_timer(unsigned long unused)
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
-	cur_ops->readdelay(&rand);
+	cur_ops->read_delay(&rand);
 	n_rcu_torture_timers++;
 	spin_unlock(&rand_lock);
 	preempt_disable();
@@ -738,11 +755,11 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	if (irqreader && cur_ops->irqcapable)
+	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
 	do {
-		if (irqreader && cur_ops->irqcapable) {
+		if (irqreader && cur_ops->irq_capable) {
 			if (!timer_pending(&t))
 				mod_timer(&t, 1);
 		}
@@ -757,7 +774,7 @@ rcu_torture_reader(void *arg)
 		}
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
-		cur_ops->readdelay(&rand);
+		cur_ops->read_delay(&rand);
 		preempt_disable();
 		pipe_count = p->rtort_pipe_count;
 		if (pipe_count > RCU_TORTURE_PIPE_LEN) {
@@ -778,7 +795,7 @@ rcu_torture_reader(void *arg)
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_reader");
-	if (irqreader && cur_ops->irqcapable)
+	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
@@ -1078,6 +1095,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &sched_expedited_ops,
 		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	mutex_lock(&fullstop_mutex);
