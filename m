Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZGDKHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZGDKHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZGDKHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:07:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbZGDKH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:07:28 -0400
Date: Sat, 4 Jul 2009 10:06:49 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/centaur.c
Message-ID: <tip-6c4caa1ab737502190e416b76e6c10d2bf24276a@git.kernel.org>
Git-Commit-ID: 6c4caa1ab737502190e416b76e6c10d2bf24276a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c4caa1ab737502190e416b76e6c10d2bf24276a
Gitweb:     http://git.kernel.org/tip/6c4caa1ab737502190e416b76e6c10d2bf24276a
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:50:44 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:10:45 +0200

x86: Clean up mtrr/centaur.c

Remove dead code and fix trivial style problems:

  ERROR: trailing whitespace X 2
  WARNING: line over 80 characters X 3
  ROR: trailing whitespace
  ERROR: do not use C99 // comments X 2

arch/x86/kernel/cpu/mtrr/centaur.o:

   text	   data	    bss	    dec	    hex	filename
    605	     32	     68	    705	    2c1	centaur.o.before
    605	     32	     68	    705	    2c1	centaur.o.after

md5:
   a4865ea98ce3c163bb1d376a3949b3e3  centaur.o.before.asm
   a4865ea98ce3c163bb1d376a3949b3e3  centaur.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ Standardized comments, DocBook, curly braces, newlines. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/centaur.c |  168 ++++++++----------------------------
 1 files changed, 35 insertions(+), 133 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index cb9aa3a..de89f14 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/mm.h>
+
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+
 #include "mtrr.h"
 
 static struct {
@@ -12,25 +14,25 @@ static struct {
 static u8 centaur_mcr_reserved;
 static u8 centaur_mcr_type;	/* 0 for winchip, 1 for winchip2 */
 
-/*
- *	Report boot time MCR setups 
+/**
+ * centaur_get_free_region - Get a free MTRR.
+ *
+ * @base: The starting (base) address of the region.
+ * @size: The size (in bytes) of the region.
+ *
+ * Returns: the index of the region on success, else -1 on error.
  */
-
 static int
 centaur_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free MTRR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
-	int i, max;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i, max;
 
 	max = num_var_ranges;
 	if (replace_reg >= 0 && replace_reg < max)
 		return replace_reg;
+
 	for (i = 0; i < max; ++i) {
 		if (centaur_mcr_reserved & (1 << i))
 			continue;
@@ -38,11 +40,14 @@ centaur_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 		if (lsize == 0)
 			return i;
 	}
+
 	return -ENOSPC;
 }
 
-void
-mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
+/*
+ * Report boot time MCR setups
+ */
+void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 {
 	centaur_mcr[mcr].low = lo;
 	centaur_mcr[mcr].high = hi;
@@ -54,33 +59,35 @@ centaur_get_mcr(unsigned int reg, unsigned long *base,
 {
 	*base = centaur_mcr[reg].high >> PAGE_SHIFT;
 	*size = -(centaur_mcr[reg].low & 0xfffff000) >> PAGE_SHIFT;
-	*type = MTRR_TYPE_WRCOMB;	/*  If it is there, it is write-combining  */
+	*type = MTRR_TYPE_WRCOMB;		/* write-combining  */
+
 	if (centaur_mcr_type == 1 && ((centaur_mcr[reg].low & 31) & 2))
 		*type = MTRR_TYPE_UNCACHABLE;
 	if (centaur_mcr_type == 1 && (centaur_mcr[reg].low & 31) == 25)
 		*type = MTRR_TYPE_WRBACK;
 	if (centaur_mcr_type == 0 && (centaur_mcr[reg].low & 31) == 31)
 		*type = MTRR_TYPE_WRBACK;
-
 }
 
-static void centaur_set_mcr(unsigned int reg, unsigned long base,
-			    unsigned long size, mtrr_type type)
+static void
+centaur_set_mcr(unsigned int reg, unsigned long base,
+		unsigned long size, mtrr_type type)
 {
 	unsigned long low, high;
 
 	if (size == 0) {
-		/*  Disable  */
+		/* Disable */
 		high = low = 0;
 	} else {
 		high = base << PAGE_SHIFT;
-		if (centaur_mcr_type == 0)
-			low = -size << PAGE_SHIFT | 0x1f;	/* only support write-combining... */
-		else {
+		if (centaur_mcr_type == 0) {
+			/* Only support write-combining... */
+			low = -size << PAGE_SHIFT | 0x1f;
+		} else {
 			if (type == MTRR_TYPE_UNCACHABLE)
-				low = -size << PAGE_SHIFT | 0x02;	/* NC */
+				low = -size << PAGE_SHIFT | 0x02; /* NC */
 			else
-				low = -size << PAGE_SHIFT | 0x09;	/* WWO,WC */
+				low = -size << PAGE_SHIFT | 0x09; /* WWO, WC */
 		}
 	}
 	centaur_mcr[reg].high = high;
@@ -88,118 +95,16 @@ static void centaur_set_mcr(unsigned int reg, unsigned long base,
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
+static int
+centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 {
 	/*
-	 *  FIXME: Winchip2 supports uncached
+	 * FIXME: Winchip2 supports uncached
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
@@ -207,7 +112,6 @@ static int centaur_validate_add_page(unsigned long base,
 
 static struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
-//	.init              = centaur_mcr_init,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
 	.get_free_region   = centaur_get_free_region,
@@ -220,5 +124,3 @@ int __init centaur_init_mtrr(void)
 	set_mtrr_ops(&centaur_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(centaur_init_mtrr);
