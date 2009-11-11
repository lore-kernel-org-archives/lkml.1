Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZKKHvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZKKHvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbZKKHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:51:43 -0500
Received: from mga10.intel.com ([192.55.52.92]:48474 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755707AbZKKHvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:51:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,721,1249282800"; 
   d="scan'208";a="745845982"
Date: Wed, 11 Nov 2009 15:51:25 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Mark the thermal init functions __init
Message-ID: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the thermal init functions __init so that the init memory can be freed.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7f3cf36..8a73d5c 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -256,7 +256,7 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
-void mcheck_intel_therm_init(void)
+void __init mcheck_intel_therm_init(void)
 {
 	/*
 	 * This function is only called on boot CPU. Save the init thermal
@@ -268,7 +268,7 @@ void mcheck_intel_therm_init(void)
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
-void intel_init_thermal(struct cpuinfo_x86 *c)
+void __init intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
