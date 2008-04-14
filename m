Return-Path: <linux-kernel-owner+w=401wt.eu-S1761490AbYDNPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490AbYDNPH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbYDNPHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:07:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbYDNPHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:07:18 -0400
Date: Mon, 14 Apr 2008 17:07:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fix
Message-ID: <20080414150700.GA14195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0426]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

it contains a single revert for an interactivity commit that has been 
tracked down to cause audio skipping for some folks. We'll delay that 
change to v2.6.26 instead. Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      revert "sched: fix fair sleepers"

 kernel/sched_fair.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 86a9337..0080968 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -510,10 +510,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			vruntime -= calc_delta_fair(sysctl_sched_latency,
-						    &cfs_rq->load);
-		}
+		if (sched_feat(NEW_FAIR_SLEEPERS))
+			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
