Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYFNMGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYFNMGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYFNMG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:06:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFNMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=q4O8ijaGJ3UyIuzq8U2p/zYXorme03JBy0vD8Jb8FktozEfmxpSF2XFM7S1xFGMu45
         pPIFaisDesy8iiEWJMUCh5hlyz8NF+FvZWxzczohsD2clU3ugNkxyCDFFj8jjwCwSnWZ
         ze6Y3MwJ2k1dlAmfZXTOgm3VnRRjliRoOuvf4=
Date: Sat, 14 Jun 2008 14:06:19 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p4.c
Message-ID: <20080614140619.3666c4f4@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 16 errors, 34 warnings, 257 lines checked

After:
total: 0 errors, 2 warnings, 257 lines checked

No changes in the compiled code:

paolo@paolo-desktop:~/linux.trees.git$ size /tmp/p4*
   text    data     bss     dec     hex filename
   2644       4       4    2652     a5c /tmp/p4.o.after
   2644       4       4    2652     a5c /tmp/p4.o.before

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/p4*
13f1b21c4246b31a28aaff38184586ca  /tmp/p4.o.after
13f1b21c4246b31a28aaff38184586ca  /tmp/p4.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/p4.c |   90 +++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index cb03345..eef001a 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -8,7 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 
-#include <asm/processor.h> 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -32,12 +32,12 @@ struct intel_mce_extended_msrs {
 	/* u32 *reserved[]; */
 };
 
-static int mce_num_extended_msrs = 0;
+static int mce_num_extended_msrs;
 
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
 static void unexpected_thermal_interrupt(struct pt_regs *regs)
-{	
+{
 	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
 			smp_processor_id());
 	add_taint(TAINT_MACHINE_CHECK);
@@ -83,7 +83,7 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
 	 * be some SMM goo which handles it, so we can't even put a handler
 	 * since it might be delivered via SMI already -zwanem.
 	 */
-	rdmsr (MSR_IA32_MISC_ENABLE, l, h);
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 	h = apic_read(APIC_LVTTHMR);
 	if ((l & (1<<3)) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG "CPU%d: Thermal monitoring handled by SMI\n",
@@ -91,7 +91,7 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
 		return; /* -EBUSY */
 	}
 
-	/* check whether a vector already exists, temporarily masked? */	
+	/* check whether a vector already exists, temporarily masked? */
 	if (h & APIC_VECTOR_MASK) {
 		printk(KERN_DEBUG "CPU%d: Thermal LVT vector (%#x) already "
 				"installed\n",
@@ -104,18 +104,18 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
 	h |= (APIC_DM_FIXED | APIC_LVT_MASKED);	/* we'll mask till we're ready */
 	apic_write_around(APIC_LVTTHMR, h);
 
-	rdmsr (MSR_IA32_THERM_INTERRUPT, l, h);
-	wrmsr (MSR_IA32_THERM_INTERRUPT, l | 0x03 , h);
+	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
+	wrmsr(MSR_IA32_THERM_INTERRUPT, l | 0x03 , h);
 
 	/* ok we're good to go... */
 	vendor_thermal_interrupt = intel_thermal_interrupt;
-	
-	rdmsr (MSR_IA32_MISC_ENABLE, l, h);
-	wrmsr (MSR_IA32_MISC_ENABLE, l | (1<<3), h);
 
-	l = apic_read (APIC_LVTTHMR);
-	apic_write_around (APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
-	printk (KERN_INFO "CPU%d: Thermal monitoring enabled\n", cpu);
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | (1<<3), h);
+
+	l = apic_read(APIC_LVTTHMR);
+	apic_write_around(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+	printk(KERN_INFO "CPU%d: Thermal monitoring enabled\n", cpu);
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
@@ -129,28 +129,28 @@ static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
 	u32 h;
 
-	rdmsr (MSR_IA32_MCG_EAX, r->eax, h);
-	rdmsr (MSR_IA32_MCG_EBX, r->ebx, h);
-	rdmsr (MSR_IA32_MCG_ECX, r->ecx, h);
-	rdmsr (MSR_IA32_MCG_EDX, r->edx, h);
-	rdmsr (MSR_IA32_MCG_ESI, r->esi, h);
-	rdmsr (MSR_IA32_MCG_EDI, r->edi, h);
-	rdmsr (MSR_IA32_MCG_EBP, r->ebp, h);
-	rdmsr (MSR_IA32_MCG_ESP, r->esp, h);
-	rdmsr (MSR_IA32_MCG_EFLAGS, r->eflags, h);
-	rdmsr (MSR_IA32_MCG_EIP, r->eip, h);
+	rdmsr(MSR_IA32_MCG_EAX, r->eax, h);
+	rdmsr(MSR_IA32_MCG_EBX, r->ebx, h);
+	rdmsr(MSR_IA32_MCG_ECX, r->ecx, h);
+	rdmsr(MSR_IA32_MCG_EDX, r->edx, h);
+	rdmsr(MSR_IA32_MCG_ESI, r->esi, h);
+	rdmsr(MSR_IA32_MCG_EDI, r->edi, h);
+	rdmsr(MSR_IA32_MCG_EBP, r->ebp, h);
+	rdmsr(MSR_IA32_MCG_ESP, r->esp, h);
+	rdmsr(MSR_IA32_MCG_EFLAGS, r->eflags, h);
+	rdmsr(MSR_IA32_MCG_EIP, r->eip, h);
 }
 
-static void intel_machine_check(struct pt_regs * regs, long error_code)
+static void intel_machine_check(struct pt_regs *regs, long error_code)
 {
-	int recover=1;
+	int recover = 1;
 	u32 alow, ahigh, high, low;
 	u32 mcgstl, mcgsth;
 	int i;
 
-	rdmsr (MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
+	rdmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 	if (mcgstl & (1<<0))	/* Recoverable ? */
-		recover=0;
+		recover = 0;
 
 	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
@@ -191,20 +191,20 @@ static void intel_machine_check(struct pt_regs * regs, long error_code)
 	}
 
 	if (recover & 2)
-		panic ("CPU context corrupt");
+		panic("CPU context corrupt");
 	if (recover & 1)
-		panic ("Unable to continue");
+		panic("Unable to continue");
 
 	printk(KERN_EMERG "Attempting to continue.\n");
-	/* 
-	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not 
+	/*
+	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not
 	 * recoverable/continuable.This will allow BIOS to look at the MSRs
 	 * for errors if the OS could not log the error.
 	 */
-	for (i=0; i<nr_mce_banks; i++) {
+	for (i = 0; i < nr_mce_banks; i++) {
 		u32 msr;
 		msr = MSR_IA32_MC0_STATUS+i*4;
-		rdmsr (msr, low, high);
+		rdmsr(msr, low, high);
 		if (high&(1<<31)) {
 			/* Clear it */
 			wrmsr(msr, 0UL, 0UL);
@@ -214,7 +214,7 @@ static void intel_machine_check(struct pt_regs * regs, long error_code)
 		}
 	}
 	mcgstl &= ~(1<<2);
-	wrmsr (MSR_IA32_MCG_STATUS,mcgstl, mcgsth);
+	wrmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 }
 
 
@@ -222,30 +222,30 @@ void intel_p4_mcheck_init(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int i;
-	
+
 	machine_check_vector = intel_machine_check;
 	wmb();
 
-	printk (KERN_INFO "Intel machine check architecture supported.\n");
-	rdmsr (MSR_IA32_MCG_CAP, l, h);
+	printk(KERN_INFO "Intel machine check architecture supported.\n");
+	rdmsr(MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
-		wrmsr (MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
+		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 	nr_mce_banks = l & 0xff;
 
-	for (i=0; i<nr_mce_banks; i++) {
-		wrmsr (MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
-		wrmsr (MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
+	for (i = 0; i < nr_mce_banks; i++) {
+		wrmsr(MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
+		wrmsr(MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
 	}
 
-	set_in_cr4 (X86_CR4_MCE);
-	printk (KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
+	set_in_cr4(X86_CR4_MCE);
+	printk(KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
 		smp_processor_id());
 
 	/* Check for P4/Xeon extended MCE MSRs */
-	rdmsr (MSR_IA32_MCG_CAP, l, h);
+	rdmsr(MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<9))	{/* MCG_EXT_P */
 		mce_num_extended_msrs = (l >> 16) & 0xff;
-		printk (KERN_INFO "CPU%d: Intel P4/Xeon Extended MCE MSRs (%d)"
+		printk(KERN_INFO "CPU%d: Intel P4/Xeon Extended MCE MSRs (%d)"
 				" available\n",
 			smp_processor_id(), mce_num_extended_msrs);
 
-- 
1.5.6.rc1.21.g03300

