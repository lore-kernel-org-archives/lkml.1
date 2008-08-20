Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYHTK5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYHTK5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYHTK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:57:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYHTK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:57:10 -0400
Date: Wed, 20 Aug 2008 12:51:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080820105141.GA18226@elte.hu>
References: <20080804070508.GA4028@linux.vnet.ibm.com> <1217833939.9016.47.camel@twins> <1912217169.25608.228.camel@ymzhang> <1218180605.8625.64.camel@twins> <20080811185008.GA29291@linux.vnet.ibm.com> <1912726331.25608.235.camel@ymzhang> <20080817115035.GA32223@linux.vnet.ibm.com> <20080818052155.GA5063@linux.vnet.ibm.com> <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219218089.10800.404.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> And I must admit to having overlooked the effect on wake_affine..
> 
> Chris, could you see the effect of this on smp group fairness?

applied your commit below to tip/sched/urgent, thanks.

	Ingo

-------------->
>From 939387c3a6141ec6aefc7acd40f8b186781bb098 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 20 Aug 2008 12:44:55 +0200
Subject: [PATCH] sched: enable LB_BIAS by default

Yanmin reported a significant regression on his 16-core machine due to:

  commit 93b75217df39e6d75889cc6f8050343286aff4a5
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Fri Jun 27 13:41:33 2008 +0200

Flip back to the old behaviour.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_features.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 862b06b..9353ca7 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -8,6 +8,6 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
-SCHED_FEAT(LB_BIAS, 0)
+SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
