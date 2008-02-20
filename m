Return-Path: <linux-kernel-owner+w=401wt.eu-S1765759AbYBTXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765759AbYBTXLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYBTXLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:11:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28892 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYBTXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=aieZemowQJj3h9bsriSY9sQEDguiKt5gRZh4oedTlwQil+xY22I/vKHhQtBLn4G67s26JkWR/hW+yD83ha+QRc6yFy2kYZPRctxHPBhu6SokOPhR/W2t7pOJAzNoczYxAuY/omj/AWCP7UHx04trEblWogxtqPg0OVGk/oUomV4=
Date: Thu, 21 Feb 2008 00:10:54 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: Coding style fixes to
 arch/x86/kernel/cpu/mcheck/p6.c
Message-ID: <20080221001054.5ea6c872@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this time the patches will reach the list :-)

After the patch:
total: 0 errors, 0 warnings, 122 lines checked
arch/x86/kernel/cpu/mcheck/p6.c has no obvious style problems and is ready for submission.

Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/p6.c |   48 +++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index 7434260..62efc9c 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -9,23 +9,23 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 
-#include <asm/processor.h> 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/msr.h>
 
 #include "mce.h"
 
 /* Machine Check Handler For PII/PIII */
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
@@ -55,30 +55,30 @@ static void intel_machine_check(struct pt_regs * regs, long error_code)
 	}
 
 	if (recover & 2)
-		panic ("CPU context corrupt");
+		panic("CPU context corrupt");
 	if (recover & 1)
-		panic ("Unable to continue");
+		panic("Unable to continue");
 
-	printk (KERN_EMERG "Attempting to continue.\n");
-	/* 
-	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not 
+	printk(KERN_EMERG "Attempting to continue.\n");
+	/*
+	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not
 	 * recoverable/continuable.This will allow BIOS to look at the MSRs
 	 * for errors if the OS could not log the error.
 	 */
-	for (i=0; i<nr_mce_banks; i++) {
+	for (i = 0; i < nr_mce_banks; i++) {
 		unsigned int msr;
 		msr = MSR_IA32_MC0_STATUS+i*4;
-		rdmsr (msr,low, high);
+		rdmsr(msr, low, high);
 		if (high & (1<<31)) {
 			/* Clear it */
-			wrmsr (msr, 0UL, 0UL);
+			wrmsr(msr, 0UL, 0UL);
 			/* Serialize */
 			wmb();
 			add_taint(TAINT_MACHINE_CHECK);
 		}
 	}
 	mcgstl &= ~(1<<2);
-	wrmsr (MSR_IA32_MCG_STATUS,mcgstl, mcgsth);
+	wrmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 }
 
 /* Set up machine check reporting for processors with Intel style MCE */
@@ -86,21 +86,21 @@ void intel_p6_mcheck_init(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int i;
-	
+
 	/* Check for MCE support */
 	if (!cpu_has(c, X86_FEATURE_MCE))
 		return;
 
 	/* Check for PPro style MCA */
- 	if (!cpu_has(c, X86_FEATURE_MCA))
+	if (!cpu_has(c, X86_FEATURE_MCA))
 		return;
 
 	/* Ok machine check is available */
 	machine_check_vector = intel_machine_check;
 	wmb();
 
-	printk (KERN_INFO "Intel machine check architecture supported.\n");
-	rdmsr (MSR_IA32_MCG_CAP, l, h);
+	printk(KERN_INFO "Intel machine check architecture supported.\n");
+	rdmsr(MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 	nr_mce_banks = l & 0xff;
@@ -110,13 +110,13 @@ void intel_p6_mcheck_init(struct cpuinfo_x86 *c)
 	 * - MC0_CTL should not be written
 	 * - Status registers on all banks should be cleared on reset
 	 */
-	for (i=1; i<nr_mce_banks; i++)
-		wrmsr (MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
+	for (i = 1; i < nr_mce_banks; i++)
+		wrmsr(MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
 
-	for (i=0; i<nr_mce_banks; i++)
-		wrmsr (MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
+	for (i = 0; i < nr_mce_banks; i++)
+		wrmsr(MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
 
-	set_in_cr4 (X86_CR4_MCE);
-	printk (KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
+	set_in_cr4(X86_CR4_MCE);
+	printk(KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
 		smp_processor_id());
 }
-- 
1.5.4.1.183.gf873

