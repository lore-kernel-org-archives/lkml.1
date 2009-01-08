Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbZAHKQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbZAHKQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbZAHKQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:16:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbZAHKQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:16:13 -0500
Subject: [PATCH -tip 2/2] x86: rename all fields of mpf_intel mpf_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 15:43:26 +0530
Message-Id: <1231409606.7119.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, solve 80 columns wrap problems

It would be cleaner to rename all the mpf->mpf_X fields to
mpf->X - that alone would give 4 characters per usage site.
(we already know that it's an 'mpf' entity -
no need to duplicate that in the field too)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |   20 +++++++-------
 arch/x86/kernel/mpparse.c         |   50 ++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 187dc92..4a7f96d 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -26,16 +26,16 @@
 
 /* Intel MP Floating Pointer Structure */
 struct mpf_intel {
-	char mpf_signature[4];		/* "_MP_"			*/
-	unsigned int mpf_physptr;	/* Configuration table address	*/
-	unsigned char mpf_length;	/* Our length (paragraphs)	*/
-	unsigned char mpf_specification;/* Specification version	*/
-	unsigned char mpf_checksum;	/* Checksum (makes sum 0)	*/
-	unsigned char mpf_feature1;	/* Standard or configuration ?	*/
-	unsigned char mpf_feature2;	/* Bit7 set for IMCR|PIC	*/
-	unsigned char mpf_feature3;	/* Unused (0)			*/
-	unsigned char mpf_feature4;	/* Unused (0)			*/
-	unsigned char mpf_feature5;	/* Unused (0)			*/
+	char signature[4];		/* "_MP_"			*/
+	unsigned int physptr;		/* Configuration table address	*/
+	unsigned char length;		/* Our length (paragraphs)	*/
+	unsigned char specification;	/* Specification version	*/
+	unsigned char checksum;		/* Checksum (makes sum 0)	*/
+	unsigned char feature1;		/* Standard or configuration ?	*/
+	unsigned char feature2;		/* Bit7 set for IMCR|PIC	*/
+	unsigned char feature3;		/* Unused (0)			*/
+	unsigned char feature4;		/* Unused (0)			*/
+	unsigned char feature5;		/* Unused (0)			*/
 };
 
 #define MPC_SIGNATURE "PCMP"
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6cea941..8385d4e 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -597,9 +597,9 @@ static void __init __get_smp_config(unsigned int early)
 	}
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
-	       mpf->mpf_specification);
+	       mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
-	if (mpf->mpf_feature2 & (1 << 7)) {
+	if (mpf->feature2 & (1 << 7)) {
 		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
 	} else {
@@ -610,7 +610,7 @@ static void __init __get_smp_config(unsigned int early)
 	/*
 	 * Now see if we need to read further.
 	 */
-	if (mpf->mpf_feature1 != 0) {
+	if (mpf->feature1 != 0) {
 		if (early) {
 			/*
 			 * local APIC has default address
@@ -620,16 +620,16 @@ static void __init __get_smp_config(unsigned int early)
 		}
 
 		printk(KERN_INFO "Default MP configuration #%d\n",
-		       mpf->mpf_feature1);
-		construct_default_ISA_mptable(mpf->mpf_feature1);
+		       mpf->feature1);
+		construct_default_ISA_mptable(mpf->feature1);
 
-	} else if (mpf->mpf_physptr) {
+	} else if (mpf->physptr) {
 
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr), early)) {
+		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -696,10 +696,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	while (length > 0) {
 		mpf = (struct mpf_intel *)bp;
 		if ((*bp == SMP_MAGIC_IDENT) &&
-		    (mpf->mpf_length == 1) &&
+		    (mpf->length == 1) &&
 		    !mpf_checksum((unsigned char *)bp, 16) &&
-		    ((mpf->mpf_specification == 1)
-		     || (mpf->mpf_specification == 4))) {
+		    ((mpf->specification == 1)
+		     || (mpf->specification == 4))) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 1;
 #endif
@@ -712,7 +712,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				return 1;
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
-			if (mpf->mpf_physptr) {
+			if (mpf->physptr) {
 				unsigned long size = PAGE_SIZE;
 #ifdef CONFIG_X86_32
 				/*
@@ -721,14 +721,14 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				 * the bottom is mapped now.
 				 * PC-9800's MPC table places on the very last
 				 * of physical memory; so that simply reserving
-				 * PAGE_SIZE from mpg->mpf_physptr yields BUG()
+				 * PAGE_SIZE from mpf->physptr yields BUG()
 				 * in reserve_bootmem.
 				 */
 				unsigned long end = max_low_pfn * PAGE_SIZE;
-				if (mpf->mpf_physptr + size > end)
-					size = end - mpf->mpf_physptr;
+				if (mpf->physptr + size > end)
+					size = end - mpf->physptr;
 #endif
-				reserve_bootmem_generic(mpf->mpf_physptr, size,
+				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
 			}
 
@@ -1013,19 +1013,19 @@ static int __init update_mp_table(void)
 	/*
 	 * Now see if we need to go further.
 	 */
-	if (mpf->mpf_feature1 != 0)
+	if (mpf->feature1 != 0)
 		return 0;
 
-	if (!mpf->mpf_physptr)
+	if (!mpf->physptr)
 		return 0;
 
-	mpc = phys_to_virt(mpf->mpf_physptr);
+	mpc = phys_to_virt(mpf->physptr);
 
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
 	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
-	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
+	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
@@ -1046,23 +1046,23 @@ static int __init update_mp_table(void)
 		}
 		printk(KERN_INFO "use in-positon replacing\n");
 	} else {
-		mpf->mpf_physptr = mpc_new_phys;
+		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
 		memcpy(mpc_new, mpc, mpc->length);
 		mpc = mpc_new;
 		/* check if we can modify that */
-		if (mpc_new_phys - mpf->mpf_physptr) {
+		if (mpc_new_phys - mpf->physptr) {
 			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
 			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
 			memcpy(mpf_new, mpf, 16);
 			mpf = mpf_new;
-			mpf->mpf_physptr = mpc_new_phys;
+			mpf->physptr = mpc_new_phys;
 		}
-		mpf->mpf_checksum = 0;
-		mpf->mpf_checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		printk(KERN_INFO "mpf_physptr new: %x\n", mpf->mpf_physptr);
+		mpf->checksum = 0;
+		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
+		printk(KERN_INFO "physptr new: %x\n", mpf->physptr);
 	}
 
 	/*
-- 
1.5.6.6



