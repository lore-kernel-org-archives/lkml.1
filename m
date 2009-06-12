Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZFLIZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZFLIZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZFLIZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:25:32 -0400
Received: from mga12.intel.com ([143.182.124.36]:32624 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752462AbZFLIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,208,1243839600"; 
   d="scan'208";a="153495862"
Date: Fri, 12 Jun 2009 16:08:55 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Add a quirk for Atom processors
Message-ID: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixed-function performance counters do not work on current Atom
processors. Use the general-purpose ones instead.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 perf_counter.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 895c82e..4bba0d8 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -968,6 +968,12 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
+        /* 
+	 * Quirk: IA32_FIXED_CTRs do not work on current Atom processors  
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && boot_cpu_data.x86_model == 28)
+		return -1;
+
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
