Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZHTNlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZHTNlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZHTNlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:41:16 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:16768
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754445AbZHTNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:41:13 -0400
X-SpamScore: 14
X-BigFish: VPS14(z1857r34a4j8deizzz1202hzzz32i6bh203h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGOF-02-8F6-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:41:04 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] sched: Check for sched_mn_power_savings when doing
	load balancing
Message-ID: <20090820134104.GY29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:41:04.0502 (UTC) FILETIME=[DD01F160:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch adds support for POWERSAVINGS_BALANCE_BASIC for MN domain
level. Currently POWERSAVINGS_BALANCE_WAKEUP is not used for MN domain.

(I have to admit that so far I don't have the correct understanding
what's the benefit of POWERSAVINGS_BALANCE_WAKEUP (when an deticated
wakeup CPU is used) in contrast to POWERSAVINGS_BALANCE_BASIC.  I also
have not found an example that would demonstrate the difference
between those two powersaving levels.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ebcda58..7a0d710 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4591,7 +4591,8 @@ static int find_new_ilb(int cpu)
 	 * Have idle load balancer selection from semi-idle packages only
 	 * when power-aware load balancing is enabled
 	 */
-	if (!(sched_smt_power_savings || sched_mc_power_savings))
+	if (!(sched_smt_power_savings || sched_mc_power_savings ||
+	      sched_mn_power_savings))
 		goto out_done;
 
 	/*
@@ -4681,7 +4682,7 @@ int select_nohz_load_balancer(int stop_tick)
 			int new_ilb;
 
 			if (!(sched_smt_power_savings ||
-						sched_mc_power_savings))
+			      sched_mc_power_savings || sched_mn_power_savings))
 				return 1;
 			/*
 			 * Check to see if there is a more power-efficient
-- 
1.6.0.4



