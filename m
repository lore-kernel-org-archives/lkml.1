Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZCFSjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZCFSjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZCFSim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:38:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbZCFSil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:38:41 -0500
Date: Fri, 6 Mar 2009 19:38:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] RCU fix
Message-ID: <20090306183826.GA12276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      rcu: increment quiescent state counter in ksoftirqd()


 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index bdbe9de..9041ea7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -626,6 +626,7 @@ static int ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
+			rcu_qsctr_inc((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
