Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYKILAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYKILAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYKIK7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:59:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:49024 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYKIK7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=joO0nI86YI7pxgw219hyc5Z3EvzeuCjrXqkmthc1YGJrHk1EBC15Zf1y3YG+MRRF46
         AJ6bzsyNuq6cpT/3jfShSYGZicyEPGHV5G+Fqpoi8yzCJKNiE4kdBPN9xisTI3FE+tUO
         gk0LiX6tJUFwQ3FUYoN3KwTZpAXnqTKYy18fY=
References: <20081109105709.222708517@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: apic - use pr_ macros for logging
Content-Disposition: inline; filename=x86-apic-pr-debug
Message-ID: <4916c290.0c07560a.4a14.ffffdde9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

It saves us some sourcse lines and shift
the code a bit righter.

And a multiline comment style is fixed too :-)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic.c |  116 ++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 63 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic.c
@@ -559,13 +559,13 @@ static int __init calibrate_by_pmtimer(l
 	} else {
 		res = (((u64)deltapm) *  mult) >> 22;
 		do_div(res, 1000000);
-		printk(KERN_WARNING "APIC calibration not consistent "
+		pr_warning("APIC calibration not consistent "
 			"with PM Timer: %ldms instead of 100ms\n",
 			(long)res);
 		/* Correct the lapic counter value */
 		res = (((u64)(*delta)) * pm_100ms);
 		do_div(res, deltapm);
-		printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+		pr_info("APIC delta adjusted to PM-Timer: "
 			"%lu (%ld)\n", (unsigned long)res, *delta);
 		*delta = (long)res;
 	}
@@ -645,8 +645,7 @@ static int __init calibrate_APIC_clock(v
 	 */
 	if (calibration_result < (1000000 / HZ)) {
 		local_irq_enable();
-		printk(KERN_WARNING
-		       "APIC frequency too slow, disabling apic timer\n");
+		pr_warning("APIC frequency too slow, disabling apic timer\n");
 		return -1;
 	}
 
@@ -688,8 +687,7 @@ static int __init calibrate_APIC_clock(v
 		local_irq_enable();
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
-		printk(KERN_WARNING
-		       "APIC timer disabled due to verification failure.\n");
+		pr_warning("APIC timer disabled due to verification failure.\n");
 			return -1;
 	}
 
@@ -710,7 +708,7 @@ void __init setup_boot_APIC_clock(void)
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
 	if (disable_apic_timer) {
-		printk(KERN_INFO "Disabling APIC timer\n");
+		pr_info("Disabling APIC timer\n");
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1) {
 			lapic_clockevent.mult = 1;
@@ -737,7 +735,7 @@ void __init setup_boot_APIC_clock(void)
 	if (nmi_watchdog != NMI_IO_APIC)
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 	else
-		printk(KERN_WARNING "APIC timer registered as dummy,"
+		pr_warning("APIC timer registered as dummy,"
 			" due to nmi_watchdog=%d!\n", nmi_watchdog);
 
 	/* Setup the lapic or request the broadcast */
@@ -769,8 +767,7 @@ static void local_apic_timer_interrupt(v
 	 * spurious.
 	 */
 	if (!evt->event_handler) {
-		printk(KERN_WARNING
-		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		pr_warning("Spurious LAPIC timer interrupt on cpu %d\n", cpu);
 		/* Switch it off */
 		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, evt);
 		return;
@@ -1089,7 +1086,7 @@ static void __cpuinit lapic_setup_esr(vo
 	unsigned int oldvalue, value, maxlvt;
 
 	if (!lapic_is_integrated()) {
-		printk(KERN_INFO "No ESR for 82489DX.\n");
+		pr_info("No ESR for 82489DX.\n");
 		return;
 	}
 
@@ -1100,7 +1097,7 @@ static void __cpuinit lapic_setup_esr(vo
 		 * ESR disabled - we can't do anything useful with the
 		 * errors anyway - mbligh
 		 */
-		printk(KERN_INFO "Leaving ESR disabled.\n");
+		pr_info("Leaving ESR disabled.\n");
 		return;
 	}
 
@@ -1294,7 +1291,7 @@ void check_x2apic(void)
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 
 	if (msr & X2APIC_ENABLE) {
-		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
+		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic = 1;
 		apic_ops = &x2apic_ops;
 	}
@@ -1306,7 +1303,7 @@ void enable_x2apic(void)
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
-		printk("Enabling x2apic\n");
+		pr_info("Enabling x2apic\n");
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
@@ -1321,9 +1318,8 @@ void enable_IR_x2apic(void)
 		return;
 
 	if (!x2apic_preenabled && disable_x2apic) {
-		printk(KERN_INFO
-		       "Skipped enabling x2apic and Interrupt-remapping "
-		       "because of nox2apic\n");
+		pr_info("Skipped enabling x2apic and Interrupt-remapping "
+			"because of nox2apic\n");
 		return;
 	}
 
@@ -1331,22 +1327,19 @@ void enable_IR_x2apic(void)
 		panic("Bios already enabled x2apic, can't enforce nox2apic");
 
 	if (!x2apic_preenabled && skip_ioapic_setup) {
-		printk(KERN_INFO
-		       "Skipped enabling x2apic and Interrupt-remapping "
-		       "because of skipping io-apic setup\n");
+		pr_info("Skipped enabling x2apic and Interrupt-remapping "
+			"because of skipping io-apic setup\n");
 		return;
 	}
 
 	ret = dmar_table_init();
 	if (ret) {
-		printk(KERN_INFO
-		       "dmar_table_init() failed with %d:\n", ret);
+		pr_info("dmar_table_init() failed with %d:\n", ret);
 
 		if (x2apic_preenabled)
 			panic("x2apic enabled by bios. But IR enabling failed");
 		else
-			printk(KERN_INFO
-			       "Not enabling x2apic,Intr-remapping\n");
+			pr_info("Not enabling x2apic,Intr-remapping\n");
 		return;
 	}
 
@@ -1355,7 +1348,7 @@ void enable_IR_x2apic(void)
 
 	ret = save_mask_IO_APIC_setup();
 	if (ret) {
-		printk(KERN_INFO "Saving IO-APIC state failed: %d\n", ret);
+		pr_info("Saving IO-APIC state failed: %d\n", ret);
 		goto end;
 	}
 
@@ -1390,14 +1383,11 @@ end:
 
 	if (!ret) {
 		if (!x2apic_preenabled)
-			printk(KERN_INFO
-			       "Enabled x2apic and interrupt-remapping\n");
+			pr_info("Enabled x2apic and interrupt-remapping\n");
 		else
-			printk(KERN_INFO
-			       "Enabled Interrupt-remapping\n");
+			pr_info("Enabled Interrupt-remapping\n");
 	} else
-		printk(KERN_ERR
-		       "Failed to enable Interrupt-remapping and x2apic\n");
+		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
 #else
 	if (!cpu_has_x2apic)
 		return;
@@ -1406,8 +1396,8 @@ end:
 		panic("x2apic enabled prior OS handover,"
 		      " enable CONFIG_INTR_REMAP");
 
-	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-	       " and x2apic\n");
+	pr_info("Enable CONFIG_INTR_REMAP for enabling intr-remapping "
+		" and x2apic\n");
 #endif
 
 	return;
@@ -1424,7 +1414,7 @@ end:
 static int __init detect_init_APIC(void)
 {
 	if (!cpu_has_apic) {
-		printk(KERN_INFO "No local APIC present\n");
+		pr_info("No local APIC present\n");
 		return -1;
 	}
 
@@ -1465,8 +1455,8 @@ static int __init detect_init_APIC(void)
 		 * "lapic" specified.
 		 */
 		if (!force_enable_local_apic) {
-			printk(KERN_INFO "Local APIC disabled by BIOS -- "
-			       "you can enable it with \"lapic\"\n");
+			pr_info("Local APIC disabled by BIOS -- "
+				"you can enable it with \"lapic\"\n");
 			return -1;
 		}
 		/*
@@ -1476,8 +1466,7 @@ static int __init detect_init_APIC(void)
 		 */
 		rdmsr(MSR_IA32_APICBASE, l, h);
 		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-			printk(KERN_INFO
-			       "Local APIC disabled by BIOS -- reenabling.\n");
+			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
 			l &= ~MSR_IA32_APICBASE_BASE;
 			l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
 			wrmsr(MSR_IA32_APICBASE, l, h);
@@ -1490,7 +1479,7 @@ static int __init detect_init_APIC(void)
 	 */
 	features = cpuid_edx(1);
 	if (!(features & (1 << X86_FEATURE_APIC))) {
-		printk(KERN_WARNING "Could not enable APIC!\n");
+		pr_warning("Could not enable APIC!\n");
 		return -1;
 	}
 	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
@@ -1501,14 +1490,14 @@ static int __init detect_init_APIC(void)
 	if (l & MSR_IA32_APICBASE_ENABLE)
 		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
-	printk(KERN_INFO "Found and enabled local APIC!\n");
+	pr_info("Found and enabled local APIC!\n");
 
 	apic_pm_activate();
 
 	return 0;
 
 no_apic:
-	printk(KERN_INFO "No local APIC present or hardware disabled\n");
+	pr_info("No local APIC present or hardware disabled\n");
 	return -1;
 }
 #endif
@@ -1584,12 +1573,12 @@ int __init APIC_init_uniprocessor(void)
 {
 #ifdef CONFIG_X86_64
 	if (disable_apic) {
-		printk(KERN_INFO "Apic disabled\n");
+		pr_info("Apic disabled\n");
 		return -1;
 	}
 	if (!cpu_has_apic) {
 		disable_apic = 1;
-		printk(KERN_INFO "Apic disabled by BIOS\n");
+		pr_info("Apic disabled by BIOS\n");
 		return -1;
 	}
 #else
@@ -1601,8 +1590,8 @@ int __init APIC_init_uniprocessor(void)
 	 */
 	if (!cpu_has_apic &&
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		printk(KERN_ERR "BIOS bug, local APIC 0x%x not detected!...\n",
-		       boot_cpu_physical_apicid);
+		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
+			boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
@@ -1695,8 +1684,8 @@ void smp_spurious_interrupt(struct pt_re
 	add_pda(irq_spurious_count, 1);
 #else
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
-	       "should never happen.\n", smp_processor_id());
+	pr_info("spurious APIC interrupt on CPU#%d, "
+		"should never happen.\n", smp_processor_id());
 	__get_cpu_var(irq_stat).irq_spurious_count++;
 #endif
 	irq_exit();
@@ -1720,17 +1709,18 @@ void smp_error_interrupt(struct pt_regs 
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
 
-	/* Here is what the APIC error bits mean:
-	   0: Send CS error
-	   1: Receive CS error
-	   2: Send accept error
-	   3: Receive accept error
-	   4: Reserved
-	   5: Send illegal vector
-	   6: Received illegal vector
-	   7: Illegal register address
-	*/
-	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
+	/*
+	 * Here is what the APIC error bits mean:
+	 * 0: Send CS error
+	 * 1: Receive CS error
+	 * 2: Send accept error
+	 * 3: Receive accept error
+	 * 4: Reserved
+	 * 5: Send illegal vector
+	 * 6: Received illegal vector
+	 * 7: Illegal register address
+	 */
+	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
 	irq_exit();
 }
@@ -1834,15 +1824,15 @@ void __cpuinit generic_processor_info(in
 	 * Validate version
 	 */
 	if (version == 0x0) {
-		printk(KERN_WARNING "BIOS bug, APIC version is 0 for CPU#%d! "
-				"fixing up to 0x10. (tell your hw vendor)\n",
-				version);
+		pr_warning("BIOS bug, APIC version is 0 for CPU#%d! "
+			"fixing up to 0x10. (tell your hw vendor)\n",
+			version);
 		version = 0x10;
 	}
 	apic_version[apicid] = version;
 
 	if (num_processors >= NR_CPUS) {
-		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
+		pr_warning("WARNING: NR_CPUS limit of %i reached."
 			"  Processor ignored.\n", NR_CPUS);
 		return;
 	}
@@ -2205,7 +2195,7 @@ static int __init apic_set_verbosity(cha
 	else if (strcmp("verbose", arg) == 0)
 		apic_verbosity = APIC_VERBOSE;
 	else {
-		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
+		pr_warning("APIC Verbosity level %s not recognised"
 			" use apic=verbose or apic=debug\n", arg);
 		return -EINVAL;
 	}

-- 
