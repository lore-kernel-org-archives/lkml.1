Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZE1Hd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZE1Hd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZE1HdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:33:20 -0400
Received: from mga05.intel.com ([192.55.52.89]:64871 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbZE1HdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:33:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,263,1241420400"; 
   d="scan'208";a="461082666"
Date: Thu, 28 May 2009 15:16:55 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Remove masking and unmasking of LVT
	error register.
Message-ID: <20090528071655.GA21039@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masking and unmasking of LVT error register become unnecessary as NMI mode will be
used all the time.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 perf_counter.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2eeaa99..444bcf2 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -865,22 +865,16 @@ void set_perf_counter_pending(void)
 
 void perf_counters_lapic_init(int nmi)
 {
-	u32 apic_val;
-
 	if (!x86_pmu_initialized())
 		return;
 
 	/*
 	 * Enable the performance counter vector in the APIC LVT:
 	 */
-	apic_val = apic_read(APIC_LVTERR);
-
-	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
 	if (nmi)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	else
 		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
-	apic_write(APIC_LVTERR, apic_val);
 }
 
 static int __kprobes
