Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZHTNqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZHTNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZHTNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:46:14 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:4058 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZHTNqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:46:14 -0400
X-SpamScore: 22
X-BigFish: VPS22(z34a4jzzz1202hzz3198u327alz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOOGWT-01-1EX-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:46:04 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090820134604.GD29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:46:05.0133 (UTC) FILETIME=[903297D0:01CA219C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The correct mask that describes core-siblings of an processor
is topology_core_cpumask. See topology adapation patches, especially
http://marc.info/?l=linux-kernel&m=124964999608179

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f797214..f39bb2c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -446,7 +446,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return cpu_core_mask(cpu);
+		return topology_core_cpumask(cpu);
 	else
 		return c->llc_shared_map;
 }
-- 
1.6.0.4



