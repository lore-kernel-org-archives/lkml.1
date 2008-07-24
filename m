Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYGXPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYGXPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYGXPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:13:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56912 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYGXPNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:13:04 -0400
Date: Thu, 24 Jul 2008 17:12:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080724151241.GA19461@elte.hu>
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

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: fix hrtick & generic-ipi dependency

Peter Zijlstra (1):
      sched: clean up compiler warning


 kernel/Kconfig.hz |    2 +-
 kernel/sched_rt.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 2a202a8..382dd5a 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS
+	def_bool HIGH_RES_TIMERS && USE_GENERIC_SMP_HELPERS
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 147004c..93ac8ee 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -253,7 +253,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
-			do_div(diff, weight);
+			diff = div_u64((u64)diff, weight);
 			if (rt_rq->rt_runtime + diff > rt_period)
 				diff = rt_period - rt_rq->rt_runtime;
 			iter->rt_runtime -= diff;
