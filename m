Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZHTNpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZHTNpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZHTNpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:45:17 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53446
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754232AbZHTNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:45:15 -0400
X-SpamScore: 5
X-BigFish: VPS5(z34a4jzzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOGV7-01-1D7-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:45:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] sched: Conditionally limit __cpu_power when child
	sched domain has type NODE
Message-ID: <20090820134506.GC29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:45:06.0929 (UTC) FILETIME=[6D815E10:01CA219C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need this in case of performance policy. All sched_groups in
child's parent domain (MN in this case) should be limited such that
tasks are balanced among these sched_groups.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0c950dc..ab88d88 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8555,11 +8555,11 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	 */
 	if (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
 	    ((child->flags &
-	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
+	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)) ||
+	     (child->level == SD_LV_NODE))) {
 		sd->groups->__cpu_power = 0;
 		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
 	}
-
 }
 
 /*
-- 
1.6.0.4



