Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZHTNeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZHTNeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZHTNeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:34:10 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:16261
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754389AbZHTNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:34:08 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh203h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGCP-01-0ZL-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:34:00 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/15] sched, x86: Provide initializer for MN scheduling
	domain, define MN level
Message-ID: <20090820133400.GQ29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:34:01.0019 (UTC) FILETIME=[E09790B0:01CA219A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/topology.h |   25 +++++++++++++++++++++++++
 include/linux/sched.h           |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d53ef91..6d7d133 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -181,6 +181,31 @@ static inline void setup_node_to_cpumask_map(void) { }
 
 #endif
 
+#ifdef CONFIG_SCHED_MN
+/* Common values for multi-node siblings */
+#ifndef SD_MN_INIT
+#define SD_MN_INIT (struct sched_domain) {		\
+	.min_interval		= 1,			\
+	.max_interval		= 4,			\
+	.busy_factor		= 64,			\
+	.imbalance_pct		= 125,			\
+	.cache_nice_tries	= 1,			\
+	.busy_idx		= 2,			\
+	.wake_idx		= 1,			\
+	.forkexec_idx		= 1,			\
+	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_FORK	\
+				| SD_BALANCE_EXEC	\
+				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
+				| sd_balance_for_package_power()\
+				| sd_power_saving_flags(),\
+	.last_balance		= jiffies,		\
+	.balance_interval	= 1,			\
+}
+#endif
+#endif /* CONFIG_SCHED_MN */
+
 #include <asm-generic/topology.h>
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index af1e328..3a1f8db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -901,6 +901,7 @@ enum sched_domain_level {
 	SD_LV_NONE = 0,
 	SD_LV_SIBLING,
 	SD_LV_MC,
+	SD_LV_MN,
 	SD_LV_CPU,
 	SD_LV_NODE,
 	SD_LV_ALLNODES,
-- 
1.6.0.4



