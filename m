Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZFJJXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZFJJXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZFJJWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:22:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:39877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515AbZFJJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:22:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,339,1241420400"; 
   d="scan'208";a="523226902"
Date: Wed, 10 Jun 2009 17:06:12 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Fix the model number of Intel Core2
	processors
Message-ID: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the model number of Intel Core2 processors according to the documentation
Intel Processor Identification with the CPUID Instruction
http://www.intel.com/support/processors/sb/cs-009861.htm

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 arch/x86/kernel/cpu/perf_counter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 40978aa..a49a82c 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1407,7 +1407,8 @@ static int intel_pmu_init(void)
 	 * Install the hw-cache-events table:
 	 */
 	switch (boot_cpu_data.x86_model) {
-	case 17:
+	case 15:
+	case 23:
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
