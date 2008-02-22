Return-Path: <linux-kernel-owner+w=401wt.eu-S936400AbYBVWTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400AbYBVWTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbYBVWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:36 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16303 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764274AbYBVWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=RdG3G4lX1hBKxRv4eeC++zyZ2oEivbhvZEKGI2+sXDFoNdtH3hyDIT7J/sj+ViUv2B3GRvxV2VPmM6m2Y87j4sqimEBYXc48iyJktQ4/OTOKzzoGFZDwS1mPjO06k3dQKPRsqNu/rD/8lMPW/jNWcFI4dST209shSlnlMidtNU4=
Date: Fri, 22 Feb 2008 23:11:23 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/cyrix.c
Message-ID: <20080222231123.01f54f6d@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/cyrix.c |  115 +++++++++++++++++++++----------------------
 1 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 9c4ee98..a8b241b 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -19,7 +19,7 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
 	unsigned long flags;
-	
+
 	/* we test for DEVID by checking whether CCR3 is writable */
 	local_irq_save(flags);
 	ccr3 = getCx86(CX86_CCR3);
@@ -37,8 +37,7 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 			setCx86(CX86_CCR2, ccr2);
 			*dir0 = 0xfe;
 		}
-	}
-	else {
+	} else {
 		setCx86(CX86_CCR3, ccr3);  /* restore CCR3 */
 
 		/* read DIR0 and DIR1 CPU registers */
@@ -55,7 +54,7 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
  * Actually since bugs.h doesn't even reference this perhaps someone should
  * fix the documentation ???
  */
-static unsigned char Cx86_dir0_msb __cpuinitdata = 0;
+static unsigned char Cx86_dir0_msb __cpuinitdata;
 
 static char Cx86_model[][9] __cpuinitdata = {
 	"Cx486", "Cx486", "5x86 ", "6x86", "MediaGX ", "6x86MX ",
@@ -86,7 +85,7 @@ static char cyrix_model_mult2[] __cpuinitdata = "12233445";
 static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 {
 	unsigned long flags;
-	
+
 	if (Cx86_dir0_msb == 3) {
 		unsigned char ccr3, ccr5;
 
@@ -132,7 +131,7 @@ static void __cpuinit set_cx86_memwb(void)
 	/* set 'Not Write-through' */
 	write_cr0(read_cr0() | X86_CR0_NW);
 	/* CCR2 bit 2: lock NW bit and set WT1 */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14 );
+	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
 }
 
 static void __cpuinit set_cx86_inc(void)
@@ -148,7 +147,7 @@ static void __cpuinit set_cx86_inc(void)
 	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
 	/* PCR0 -- Performance Control */
 	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04); 
+	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
 	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
 }
 
@@ -167,16 +166,16 @@ static void __cpuinit geode_configure(void)
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
-	
+
 
 	/* FPU fast, DTE cache, Mem bypass */
 	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
 	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
-	
+
 	set_cx86_memwb();
-	set_cx86_reorder();	
+	set_cx86_reorder();
 	set_cx86_inc();
-	
+
 	local_irq_restore(flags);
 }
 
@@ -187,12 +186,14 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 	char *buf = c->x86_model_id;
 	const char *p = NULL;
 
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
 	clear_bit(0*32+31, c->x86_capability);
 
 	/* Cyrix used bit 24 in extended (AMD) CPUID for Cyrix MMX extensions */
-	if ( test_bit(1*32+24, c->x86_capability) ) {
+	if (test_bit(1*32+24, c->x86_capability)) {
 		clear_bit(1*32+24, c->x86_capability);
 		set_bit(X86_FEATURE_CXMMX, c->x86_capability);
 	}
@@ -213,7 +214,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 	 * the model, multiplier and stepping.  Black magic included,
 	 * to make the silicon step/rev numbers match the printed ones.
 	 */
-	 
+
 	switch (dir0_msn) {
 		unsigned char tmp;
 
@@ -250,17 +251,18 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 #ifdef CONFIG_PCI
 	{
 		u32 vendor, device;
-		/* It isn't really a PCI quirk directly, but the cure is the
-		   same. The MediaGX has deep magic SMM stuff that handles the
-		   SB emulation. It throws away the fifo on disable_dma() which
-		   is wrong and ruins the audio. 
-
-		   Bug2: VSA1 has a wrap bug so that using maximum sized DMA 
-		   causes bad things. According to NatSemi VSA2 has another
-		   bug to do with 'hlt'. I've not seen any boards using VSA2
-		   and X doesn't seem to support it either so who cares 8).
-		   VSA1 we work around however.
-		*/
+		/*
+		 * It isn't really a PCI quirk directly, but the cure is the
+		 * same. The MediaGX has deep magic SMM stuff that handles the
+		 * SB emulation. It throws away the fifo on disable_dma() which
+		 * is wrong and ruins the audio.
+		 *
+		 *  Bug2: VSA1 has a wrap bug so that using maximum sized DMA
+		 *  causes bad things. According to NatSemi VSA2 has another
+		 *  bug to do with 'hlt'. I've not seen any boards using VSA2
+		 *  and X doesn't seem to support it either so who cares 8).
+		 *  VSA1 we work around however.
+		 */
 
 		printk(KERN_INFO "Working around Cyrix MediaGX virtual DMA bugs.\n");
 		isa_dma_bridge_buggy = 2;
@@ -273,52 +275,48 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 
 		/*
 		 *  The 5510/5520 companion chips have a funky PIT.
-		 */  
+		 */
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
 	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
 			mark_tsc_unstable("cyrix 5510/5520 detected");
 	}
 #endif
-		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
+		c->x86_cache_size = 16;	/* Yep 16K integrated cache thats it */
 
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
 			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
-			
+
 			/*
 			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
 			 * GXlv: 0x6x          GXlv datasheet 54
 			 *  ?  : 0x7x
 			 * GX1 : 0x8x          GX1  datasheet 56
 			 */
-			if((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <=dir1 && dir1 <= 0x8f))
+			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
 				geode_configure();
 			get_model_name(c);  /* get CPU marketing name */
 			return;
-		}
-		else {  /* MediaGX */
+		} else { /* MediaGX */
 			Cx86_cb[2] = (dir0_lsn & 1) ? '3' : '4';
 			p = Cx86_cb+2;
 			c->x86_model = (dir1 & 0x20) ? 1 : 2;
 		}
 		break;
 
-        case 5: /* 6x86MX/M II */
-		if (dir1 > 7)
-		{
+	case 5: /* 6x86MX/M II */
+		if (dir1 > 7) {
 			dir0_msn++;  /* M II */
 			/* Enable MMX extensions (App note 108) */
 			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
-		}
-		else
-		{
+		} else {
 			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
 		}
 		tmp = (!(dir0_lsn & 7) || dir0_lsn & 1) ? 2 : 0;
 		Cx86_cb[tmp] = cyrix_model_mult2[dir0_lsn & 7];
 		p = Cx86_cb+tmp;
-        	if (((dir1 & 0x0f) > 4) || ((dir1 & 0xf0) == 0x20))
+		if (((dir1 & 0x0f) > 4) || ((dir1 & 0xf0) == 0x20))
 			(c->x86_model)++;
 		/* Emulate MTRRs using Cyrix's ARRs. */
 		set_bit(X86_FEATURE_CYRIX_ARR, c->x86_capability);
@@ -343,7 +341,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		break;
 	}
 	strcpy(buf, Cx86_model[dir0_msn & 7]);
-	if (p) strcat(buf, p);
+	if (p)
+		strcat(buf, p);
 	return;
 }
 
@@ -352,7 +351,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
  */
 static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
 {
-	/* There may be GX1 processors in the wild that are branded
+	/*
+	 * There may be GX1 processors in the wild that are branded
 	 * NSC and not Cyrix.
 	 *
 	 * This function only handles the GX processor, and kicks every
@@ -377,7 +377,7 @@ static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
  * by the fact that they preserve the flags across the division of 5/2.
  * PII and PPro exhibit this behavior too, but they have cpuid available.
  */
- 
+
 /*
  * Perform the Cyrix 5/2 test. A Cyrix won't change
  * the flags, while other 486 chips will.
@@ -398,27 +398,26 @@ static inline int test_cyrix_52div(void)
 	return (unsigned char) (test >> 8) == 0x02;
 }
 
-static void __cpuinit cyrix_identify(struct cpuinfo_x86 * c)
+static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 {
 	/* Detect Cyrix with disabled CPUID */
-	if ( c->x86 == 4 && test_cyrix_52div() ) {
+	if (c->x86 == 4 && test_cyrix_52div()) {
 		unsigned char dir0, dir1;
-		
+
 		strcpy(c->x86_vendor_id, "CyrixInstead");
-	        c->x86_vendor = X86_VENDOR_CYRIX;
-	        
-	        /* Actually enable cpuid on the older cyrix */
-	    
-	    	/* Retrieve CPU revisions */
-	    	
+		c->x86_vendor = X86_VENDOR_CYRIX;
+
+		/* Actually enable cpuid on the older cyrix */
+
+		/* Retrieve CPU revisions */
+
 		do_cyrix_devid(&dir0, &dir1);
 
-		dir0>>=4;		
-		
+		dir0 >>= 4;
+
 		/* Check it is an affected model */
-		
-   	        if (dir0 == 5 || dir0 == 3)
-   	        {
+
+		if (dir0 == 5 || dir0 == 3) {
 			unsigned char ccr3;
 			unsigned long flags;
 			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
@@ -434,7 +433,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 * c)
 
 static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Cyrix",
-	.c_ident 	= { "CyrixInstead" },
+	.c_ident	= { "CyrixInstead" },
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
 };
@@ -443,7 +442,7 @@ cpu_vendor_dev_register(X86_VENDOR_CYRIX, &cyrix_cpu_dev);
 
 static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
 	.c_vendor	= "NSC",
-	.c_ident 	= { "Geode by NSC" },
+	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
 };
 
-- 
1.5.4.GIT

