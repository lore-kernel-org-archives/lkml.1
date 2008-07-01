Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYGAT6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYGAT6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYGAT61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:58:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYGAT61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:58:27 -0400
Date: Tue, 1 Jul 2008 21:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20080701195814.GA1786@elte.hu>
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
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

I think that's the last one for v2.6.26. Thanks,

	Ingo

------------------>
Raistlin (1):
      sched: fix divide error when trying to configure rt_period to zero

 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a66e856..94ead43 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8502,6 +8502,9 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
 	rt_runtime = tg->rt_bandwidth.rt_runtime;
 
+	if (rt_period == 0)
+		return -EINVAL;
+
 	return tg_set_bandwidth(tg, rt_period, rt_runtime);
 }
 
