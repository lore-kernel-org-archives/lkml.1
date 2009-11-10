Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbZKJRnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbZKJRnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbZKJRnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:43:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZKJRng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:43:36 -0500
Date: Tue, 10 Nov 2009 18:43:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091110174333.GA5723@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      sched: Use root_task_group_empty only with FAIR_GROUP_SCHED

Randy Dunlap (1):
      sched: Fix kernel-doc function parameter name


 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 28dd4f4..3c11ae0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -309,6 +309,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
 #ifdef CONFIG_SMP
 static int root_task_group_empty(void)
 {
@@ -316,7 +318,6 @@ static int root_task_group_empty(void)
 }
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
 #else /* !CONFIG_USER_SCHED */
@@ -1994,7 +1995,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
- * @k: thread created by kthread_create().
+ * @p: thread created by kthread_create().
  * @cpu: cpu (might not be online, must be possible) for @k to run on.
  *
  * Description: This function is equivalent to set_cpus_allowed(),
