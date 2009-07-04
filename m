Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZGDCbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZGDCbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZGDCbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:31:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:50447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZGDCbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:31:02 -0400
Subject: [PATCH 2/9 -tip] x86: mtrr/centaur.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674000.2642.6.camel@ht.satnam>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>  <1246673939.2642.5.camel@ht.satnam>
	 <1246674000.2642.6.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:50:44 +0530
Message-Id: <1246674044.2642.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove dead code.

and fix trivial style problems:

  ERROR: trailing whitespace X 2
  WARNING: line over 80 characters X 3
  ROR: trailing whitespace
  ERROR: do not use C99 // comments X 2

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/centaur.c |  127 ++++--------------------------------
 1 files changed, 12 insertions(+), 115 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index cb9aa3a..1350ab3 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -13,7 +13,7 @@ static u8 centaur_mcr_reserved;
 static u8 centaur_mcr_type;	/* 0 for winchip, 1 for winchip2 */
 
 /*
- *	Report boot time MCR setups 
+ *	Report boot time MCR setups
  */
 
 static int
@@ -54,7 +54,8 @@ centaur_get_mcr(unsigned int reg, unsigned long *base,
 {
 	*base = centaur_mcr[reg].high >> PAGE_SHIFT;
 	*size = -(centaur_mcr[reg].low & 0xfffff000) >> PAGE_SHIFT;
-	*type = MTRR_TYPE_WRCOMB;	/*  If it is there, it is write-combining  */
+	*type = MTRR_TYPE_WRCOMB;		/* write-combining  */
+
 	if (centaur_mcr_type == 1 && ((centaur_mcr[reg].low & 31) & 2))
 		*type = MTRR_TYPE_UNCACHABLE;
 	if (centaur_mcr_type == 1 && (centaur_mcr[reg].low & 31) == 25)
@@ -75,12 +76,13 @@ static void centaur_set_mcr(unsigned int reg, unsigned long base,
 	} else {
 		high = base << PAGE_SHIFT;
 		if (centaur_mcr_type == 0)
-			low = -size << PAGE_SHIFT | 0x1f;	/* only support write-combining... */
+			/* only support write-combining... */
+			low = -size << PAGE_SHIFT | 0x1f;
 		else {
 			if (type == MTRR_TYPE_UNCACHABLE)
-				low = -size << PAGE_SHIFT | 0x02;	/* NC */
+				low = -size << PAGE_SHIFT | 0x02; /* NC */
 			else
-				low = -size << PAGE_SHIFT | 0x09;	/* WWO,WC */
+				low = -size << PAGE_SHIFT | 0x09; /* WWO,WC */
 		}
 	}
 	centaur_mcr[reg].high = high;
@@ -88,118 +90,16 @@ static void centaur_set_mcr(unsigned int reg, unsigned long base,
 	wrmsr(MSR_IDT_MCR0 + reg, low, high);
 }
 
-#if 0
-/*
- *	Initialise the later (saner) Winchip MCR variant. In this version
- *	the BIOS can pass us the registers it has used (but not their values)
- *	and the control register is read/write
- */
-
-static void __init
-centaur_mcr1_init(void)
-{
-	unsigned i;
-	u32 lo, hi;
-
-	/* Unfortunately, MCR's are read-only, so there is no way to
-	 * find out what the bios might have done.
-	 */
-
-	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-	if (((lo >> 17) & 7) == 1) {	/* Type 1 Winchip2 MCR */
-		lo &= ~0x1C0;	/* clear key */
-		lo |= 0x040;	/* set key to 1 */
-		wrmsr(MSR_IDT_MCR_CTRL, lo, hi);	/* unlock MCR */
-	}
-
-	centaur_mcr_type = 1;
-
-	/*
-	 *  Clear any unconfigured MCR's.
-	 */
-
-	for (i = 0; i < 8; ++i) {
-		if (centaur_mcr[i].high == 0 && centaur_mcr[i].low == 0) {
-			if (!(lo & (1 << (9 + i))))
-				wrmsr(MSR_IDT_MCR0 + i, 0, 0);
-			else
-				/*
-				 *      If the BIOS set up an MCR we cannot see it
-				 *      but we don't wish to obliterate it
-				 */
-				centaur_mcr_reserved |= (1 << i);
-		}
-	}
-	/*  
-	 *  Throw the main write-combining switch... 
-	 *  However if OOSTORE is enabled then people have already done far
-	 *  cleverer things and we should behave. 
-	 */
-
-	lo |= 15;		/* Write combine enables */
-	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-}
-
-/*
- *	Initialise the original winchip with read only MCR registers
- *	no used bitmask for the BIOS to pass on and write only control
- */
-
-static void __init
-centaur_mcr0_init(void)
-{
-	unsigned i;
-
-	/* Unfortunately, MCR's are read-only, so there is no way to
-	 * find out what the bios might have done.
-	 */
-
-	/* Clear any unconfigured MCR's.
-	 * This way we are sure that the centaur_mcr array contains the actual
-	 * values. The disadvantage is that any BIOS tweaks are thus undone.
-	 *
-	 */
-	for (i = 0; i < 8; ++i) {
-		if (centaur_mcr[i].high == 0 && centaur_mcr[i].low == 0)
-			wrmsr(MSR_IDT_MCR0 + i, 0, 0);
-	}
-
-	wrmsr(MSR_IDT_MCR_CTRL, 0x01F0001F, 0);	/* Write only */
-}
-
-/*
- *	Initialise Winchip series MCR registers
- */
-
-static void __init
-centaur_mcr_init(void)
-{
-	struct set_mtrr_context ctxt;
-
-	set_mtrr_prepare_save(&ctxt);
-	set_mtrr_cache_disable(&ctxt);
-
-	if (boot_cpu_data.x86_model == 4)
-		centaur_mcr0_init();
-	else if (boot_cpu_data.x86_model == 8 || boot_cpu_data.x86_model == 9)
-		centaur_mcr1_init();
-
-	set_mtrr_done(&ctxt);
-}
-#endif
-
-static int centaur_validate_add_page(unsigned long base, 
-				     unsigned long size, unsigned int type)
+static int centaur_validate_add_page(unsigned long base, unsigned long size,
+				     unsigned int type)
 {
 	/*
 	 *  FIXME: Winchip2 supports uncached
 	 */
-	if (type != MTRR_TYPE_WRCOMB && 
+	if (type != MTRR_TYPE_WRCOMB &&
 	    (centaur_mcr_type == 0 || type != MTRR_TYPE_UNCACHABLE)) {
-		printk(KERN_WARNING
-		       "mtrr: only write-combining%s supported\n",
-		       centaur_mcr_type ? " and uncacheable are"
-		       : " is");
+		pr_warning("mtrr: only write-combining%s supported\n",
+			   centaur_mcr_type ? " and uncacheable are" : " is");
 		return -EINVAL;
 	}
 	return 0;
@@ -207,7 +107,6 @@ static int centaur_validate_add_page(unsigned long base,
 
 static struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
-//	.init              = centaur_mcr_init,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
 	.get_free_region   = centaur_get_free_region,
@@ -220,5 +119,3 @@ int __init centaur_init_mtrr(void)
 	set_mtrr_ops(&centaur_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(centaur_init_mtrr);
-- 
1.6.0.6



