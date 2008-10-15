Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYJOQsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYJOQsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYJOQsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:48:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYJOQsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:48:12 -0400
Date: Wed, 15 Oct 2008 18:47:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081015164758.GA3156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0513]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dave Kleikamp (1):
      sched_clock: prevent scd->clock from moving backwards


 kernel/sched_clock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..8178724 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      max(scd->clock, scd->tick_gtod + TICK_NSEC));
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
