Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZBTK4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZBTK4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZBTK4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:56:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:31299 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZBTK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dadcJyMlY/c9TkqL3N8j6BYON1BTqSdyAikw22Hi04CpmEbGlCuMmhx/iSl4i8AGWH
         iKzvQAg9lBbMVTIOiWZ1xGJGfm/gu+/XYbByHGWsY3mkJCXiiE91x/FkXD9v9HBXU1ji
         U1GtO5ILXeQhHi3E6OM2DoSkXBuwlNt2YYLdc=
Date: Fri, 20 Feb 2009 11:56:38 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: use symbolic constants for MSR_IA32_MISC_ENABLE bits
Message-ID: <20090220105638.GA22786@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d465c8c135e64c9aabfbf83175fb90b41912b1da Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 20 Feb 2009 11:49:34 +0100
Subject: [PATCH] x86: use symbolic constants for MSR_IA32_MISC_ENABLE bits

Impact: Cleanup. No functional changes.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/e_powersaver.c       |    6 +++---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    6 +++---
 arch/x86/kernel/cpu/intel.c                      |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c        |    6 +++---
 arch/x86/kernel/cpu/mcheck/p4.c                  |    4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/e_powersaver.c b/arch/x86/kernel/cpu/cpufreq/e_powersaver.c
index c2f930d..41ab3f0 100644
--- a/arch/x86/kernel/cpu/cpufreq/e_powersaver.c
+++ b/arch/x86/kernel/cpu/cpufreq/e_powersaver.c
@@ -204,12 +204,12 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	}
 	/* Enable Enhanced PowerSaver */
 	rdmsrl(MSR_IA32_MISC_ENABLE, val);
-	if (!(val & 1 << 16)) {
-		val |= 1 << 16;
+	if (!(val & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
+		val |= MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP;
 		wrmsrl(MSR_IA32_MISC_ENABLE, val);
 		/* Can be locked at 0 */
 		rdmsrl(MSR_IA32_MISC_ENABLE, val);
-		if (!(val & 1 << 16)) {
+		if (!(val & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 			printk(KERN_INFO "eps: Can't enable Enhanced PowerSaver\n");
 			return -ENODEV;
 		}
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index f089982..c9f1fdc 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -390,14 +390,14 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 	   enable it if not. */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 
-	if (!(l & (1<<16))) {
-		l |= (1<<16);
+	if (!(l & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
+		l |= MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP;
 		dprintk("trying to enable Enhanced SpeedStep (%x)\n", l);
 		wrmsr(MSR_IA32_MISC_ENABLE, l, h);
 
 		/* check to see if it stuck */
 		rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-		if (!(l & (1<<16))) {
+		if (!(l & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 			printk(KERN_INFO PFX
 				"couldn't enable Enhanced SpeedStep\n");
 			return -ENODEV;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 24ff26a..33e783c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -135,10 +135,10 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
-		if ((lo & (1<<9)) == 0) {
+		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
 			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
 			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
-			lo |= (1<<9);	/* Disable hw prefetching */
+			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
 			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 4b48f25..2dc0902 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -48,13 +48,13 @@ static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 	h = apic_read(APIC_LVTTHMR);
-	if ((l & (1 << 3)) && (h & APIC_DM_SMI)) {
+	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
 		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
 		return;
 	}
 
-	if (cpu_has(c, X86_FEATURE_TM2) && (l & (1 << 13)))
+	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
 		tm2 = 1;
 
 	if (h & APIC_VECTOR_MASK) {
@@ -72,7 +72,7 @@ static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
 	wrmsr(MSR_IA32_THERM_INTERRUPT, l | 0x03, h);
 
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	wrmsr(MSR_IA32_MISC_ENABLE, l | (1 << 3), h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
 
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 9b60fce..f53bdcb 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -85,7 +85,7 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 	h = apic_read(APIC_LVTTHMR);
-	if ((l & (1<<3)) && (h & APIC_DM_SMI)) {
+	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG "CPU%d: Thermal monitoring handled by SMI\n",
 				cpu);
 		return; /* -EBUSY */
@@ -111,7 +111,7 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
 	vendor_thermal_interrupt = intel_thermal_interrupt;
 
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	wrmsr(MSR_IA32_MISC_ENABLE, l | (1<<3), h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
 
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
-- 
1.6.0.6

