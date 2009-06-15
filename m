Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZFOI1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZFOI1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbZFOI0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:26:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53502 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294AbZFOI0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:26:42 -0400
Message-ID: <4A3605BC.8000407@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:26:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/16] x86, mce: remove intel_set_thermal_handler()
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and make intel_thermal_interrupt() static.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h               |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 3bc827c..365a594 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -199,7 +199,6 @@ extern void (*mce_threshold_vector)(void);
  * Thermal handler
  */
 
-void intel_set_thermal_handler(void);
 void intel_init_thermal(struct cpuinfo_x86 *c);
 
 #ifdef CONFIG_X86_NEW_MCE
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7a508aa..7c7944c 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,7 +202,7 @@ device_initcall(thermal_throttle_init_device);
 #endif /* CONFIG_SYSFS */
 
 /* Thermal transition interrupt handler */
-void intel_thermal_interrupt(void)
+static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
@@ -231,11 +231,6 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
-void intel_set_thermal_handler(void)
-{
-	smp_thermal_vector = intel_thermal_interrupt;
-}
-
 void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
@@ -278,7 +273,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	wrmsr(MSR_IA32_THERM_INTERRUPT,
 		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
 
-	intel_set_thermal_handler();
+	smp_thermal_vector = intel_thermal_interrupt;
 
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
-- 
1.6.3


