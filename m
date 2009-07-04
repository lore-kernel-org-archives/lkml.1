Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZGDCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZGDCcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZGDCcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:32:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:47353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbZGDCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:32:00 -0400
Subject: [PATCH 5/9 -tip] x86: mtrr/generic.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674128.2642.9.camel@ht.satnam>
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
	 <1246674000.2642.6.camel@ht.satnam>  <1246674044.2642.7.camel@ht.satnam>
	 <1246674092.2642.8.camel@ht.satnam>  <1246674128.2642.9.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:53:00 +0530
Message-Id: <1246674180.2642.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use pr_debug and pr_warning where possible.

Rename fixed_range_blocks to mtrrfix_blocks to avoid line breaks.

Fix following trivial style problems:

ERROR: trailing whitespace X 4
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: braces {} are not necessary for single statement blocks X 3
ERROR: "foo * bar" should be "foo *bar"
WARNING: line over 80 characters X 6
ERROR: "foo * bar" should be "foo *bar"
ERROR: spaces required around that '=' (ctx:VxO)
ERROR: space required before that '-' (ctx:OxV)
WARNING: suspect code indent for conditional statements (8, 12)
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: do not initialise statics to 0 or NULL
ERROR: space prohibited after that open parenthesis '(' X 2
ERROR: space prohibited before that close parenthesis ')' X 2
ERROR: trailing statements should be on next line
ERROR: return is not a function, parentheses are not required

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |  147 +++++++++++++++++++-----------------
 1 files changed, 78 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0543f69..1538197 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -1,10 +1,12 @@
-/* This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
-   because MTRRs can span upto 40 bits (36bits on most modern x86) */ 
+/*
+ * This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
+ * because MTRRs can span upto 40 bits (36bits on most modern x86)
+ */
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/system.h>
@@ -15,11 +17,11 @@
 #include "mtrr.h"
 
 struct fixed_range_block {
-	int base_msr; /* start address of an MTRR block */
-	int ranges;   /* number of MTRRs in this block  */
+	int base_msr;		/* start address of an MTRR block */
+	int ranges;		/* number of MTRRs in this block  */
 };
 
-static struct fixed_range_block fixed_range_blocks[] = {
+static struct fixed_range_block mtrrfix_blocks[] = {
 	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
 	{ MSR_MTRRfix16K_80000, 2 }, /* two  16k MTRRs */
 	{ MSR_MTRRfix4K_C0000,  8 }, /* eight 4k MTRRs */
@@ -104,9 +106,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!(mtrr_state.enabled & 2)) {
+	if (!(mtrr_state.enabled & 2))
 		return mtrr_state.def_type;
-	}
 
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -125,9 +126,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 		if (start_state != end_state)
 			return 0xFE;
 
-		if ((start & mask) != (base & mask)) {
+		if ((start & mask) != (base & mask))
 			continue;
-		}
 
 		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
 		if (prev_match == 0xFF) {
@@ -148,9 +148,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 			curr_match = MTRR_TYPE_WRTHROUGH;
 		}
 
-		if (prev_match != curr_match) {
+		if (prev_match != curr_match)
 			return MTRR_TYPE_UNCACHABLE;
-		}
 	}
 
 	if (mtrr_tom2) {
@@ -186,10 +185,9 @@ void fill_mtrr_var_range(unsigned int index,
 	vr[index].mask_hi = mask_hi;
 }
 
-static void
-get_fixed_ranges(mtrr_type * frs)
+static void get_fixed_ranges(mtrr_type *frs)
 {
-	unsigned int *p = (unsigned int *) frs;
+	unsigned int *p = (unsigned int *)frs;
 	int i;
 
 	k8_check_syscfg_dram_mod_en();
@@ -217,14 +215,14 @@ static void __init print_fixed_last(void)
 	if (!last_fixed_end)
 		return;
 
-	printk(KERN_DEBUG "  %05X-%05X %s\n", last_fixed_start,
-		last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
+	pr_debug("  %05X-%05X %s\n", last_fixed_start,
+		 last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
 
 	last_fixed_end = 0;
 }
 
 static void __init update_fixed_last(unsigned base, unsigned end,
-				       mtrr_type type)
+				     mtrr_type type)
 {
 	last_fixed_start = base;
 	last_fixed_end = end;
@@ -259,45 +257,46 @@ static void __init print_mtrr_state(void)
 	unsigned int i;
 	int high_width;
 
-	printk(KERN_DEBUG "MTRR default type: %s\n",
-			 mtrr_attrib_to_str(mtrr_state.def_type));
+	pr_debug("MTRR default type: %s\n",
+		 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
-		printk(KERN_DEBUG "MTRR fixed ranges %sabled:\n",
-		       mtrr_state.enabled & 1 ? "en" : "dis");
+		pr_debug("MTRR fixed ranges %sabled:\n",
+			 mtrr_state.enabled & 1 ? "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
-			print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
+			print_fixed(0x80000 + i * 0x20000, 0x04000,
+				    mtrr_state.fixed_ranges + (i + 1) * 8);
 		for (i = 0; i < 8; ++i)
-			print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
+			print_fixed(0xC0000 + i * 0x08000, 0x01000,
+				    mtrr_state.fixed_ranges + (i + 3) * 8);
 
 		/* tail */
 		print_fixed_last();
 	}
-	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
-	       mtrr_state.enabled & 2 ? "en" : "dis");
+	pr_debug("MTRR variable ranges %sabled:\n",
+		 mtrr_state.enabled & 2 ? "en" : "dis");
 	if (size_or_mask & 0xffffffffUL)
 		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
 	else
 		high_width = ffs(size_or_mask>>32) + 32 - 1;
 	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
+
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
-			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
-			       i,
-			       high_width,
-			       mtrr_state.var_ranges[i].base_hi,
-			       mtrr_state.var_ranges[i].base_lo >> 12,
-			       high_width,
-			       mtrr_state.var_ranges[i].mask_hi,
-			       mtrr_state.var_ranges[i].mask_lo >> 12,
-			       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
+			pr_debug("  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
+				 i,
+				 high_width,
+				 mtrr_state.var_ranges[i].base_hi,
+				 mtrr_state.var_ranges[i].base_lo >> 12,
+				 high_width,
+				 mtrr_state.var_ranges[i].mask_hi,
+				 mtrr_state.var_ranges[i].mask_lo >> 12,
+				 mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
 		else
-			printk(KERN_DEBUG "  %u disabled\n", i);
-	}
-	if (mtrr_tom2) {
-		printk(KERN_DEBUG "TOM2: %016llx aka %lldM\n",
-				  mtrr_tom2, mtrr_tom2>>20);
+			pr_debug("  %u disabled\n", i);
 	}
+	if (mtrr_tom2)
+		pr_debug("TOM2: %016llx aka %lldM\n", mtrr_tom2, mtrr_tom2>>20);
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
@@ -355,11 +354,11 @@ void __init mtrr_state_warn(void)
 	if (!mask)
 		return;
 	if (mask & MTRR_CHANGE_MASK_FIXED)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent fixed MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent fixed MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_VARIABLE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent variable MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent variable MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_DEFTYPE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent MTRRdefType settings\n");
 	printk(KERN_INFO "mtrr: probably your BIOS does not setup all CPUs.\n");
 	printk(KERN_INFO "mtrr: corrected configuration.\n");
 }
@@ -401,7 +400,8 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
  *
  * Returns: The index of the region on success, else negative on error.
  */
-int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
+int
+generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 {
 	int i, max;
 	mtrr_type ltype;
@@ -474,18 +474,18 @@ out_put_cpu:
  * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
  * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
-static int set_fixed_ranges(mtrr_type * frs)
+static int set_fixed_ranges(mtrr_type *frs)
 {
-	unsigned long long *saved = (unsigned long long *) frs;
+	unsigned long long *saved = (unsigned long long *)frs;
 	bool changed = false;
-	int block=-1, range;
+	int block = -1, range;
 
 	k8_check_syscfg_dram_mod_en();
 
-	while (fixed_range_blocks[++block].ranges)
-	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
-		set_fixed_range(fixed_range_blocks[block].base_msr + range,
-		    &changed, (unsigned int *) saved++);
+	while (mtrrfix_blocks[++block].ranges)
+		for (range = 0; range < mtrrfix_blocks[block].ranges; range++)
+			set_fixed_range(mtrrfix_blocks[block].base_msr + range,
+					&changed, (unsigned int *)saved++);
 
 	return changed;
 }
@@ -540,7 +540,8 @@ static unsigned long set_mtrr_state(void)
 	   so to set it we fiddle with the saved value  */
 	if ((deftype_lo & 0xff) != mtrr_state.def_type
 	    || ((deftype_lo & 0xc00) >> 10) != mtrr_state.enabled) {
-		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type | (mtrr_state.enabled << 10);
+		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type |
+			     (mtrr_state.enabled << 10);
 		change_mask |= MTRR_CHANGE_MASK_DEFTYPE;
 	}
 
@@ -548,7 +549,7 @@ static unsigned long set_mtrr_state(void)
 }
 
 
-static unsigned long cr4 = 0;
+static unsigned long cr4;
 static DEFINE_SPINLOCK(set_atomicity_lock);
 
 /*
@@ -562,9 +563,12 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 {
 	unsigned long cr0;
 
-	/*  Note that this is not ideal, since the cache is only flushed/disabled
-	   for this CPU while the MTRRs are changed, but changing this requires
-	   more invasive changes to the way the kernel boots  */
+	/*
+	 * Note that this is not ideal
+	 * since the cache is only flushed/disabled for this CPU while the
+	 * MTRRs are changed, but changing this requires more invasive
+	 * changes to the way the kernel boots
+	 */
 
 	spin_lock(&set_atomicity_lock);
 
@@ -574,7 +578,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	wbinvd();
 
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
+	if (cpu_has_pge) {
 		cr4 = read_cr4();
 		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
@@ -596,12 +600,12 @@ static void post_set(void) __releases(set_atomicity_lock)
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
-		
+
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
 
 	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	if (cpu_has_pge)
 		write_cr4(cr4);
 	spin_unlock(&set_atomicity_lock);
 }
@@ -629,7 +633,7 @@ static void generic_set_all(void)
 			set_bit(count, &smp_changes_mask);
 		mask >>= 1;
 	}
-	
+
 }
 
 static void generic_set_mtrr(unsigned int reg, unsigned long base,
@@ -669,23 +673,26 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	local_irq_restore(flags);
 }
 
-int generic_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+int generic_validate_add_page(unsigned long base, unsigned long size,
+			      unsigned int type)
 {
 	unsigned long lbase, last;
 
-	/*  For Intel PPro stepping <= 7, must be 4 MiB aligned 
-	    and not touch 0x70000000->0x7003FFFF */
+	/*
+	 * For Intel PPro stepping <= 7
+	 * must be 4 MiB aligned and not touch 0x70000000 -> 0x7003FFFF
+	 */
 	if (is_cpu(INTEL) && boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask <= 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
-			printk(KERN_WARNING "mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
+			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
 			return -EINVAL;
 		}
 		if (!(base + size < 0x70000 || base > 0x7003F) &&
 		    (type == MTRR_TYPE_WRCOMB
 		     || type == MTRR_TYPE_WRBACK)) {
-			printk(KERN_WARNING "mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
+			pr_warning("mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
 			return -EINVAL;
 		}
 	}
@@ -694,9 +701,10 @@ int generic_validate_add_page(unsigned long base, unsigned long size, unsigned i
 	    for base and 1 for last  */
 	last = base + size - 1;
 	for (lbase = base; !(lbase & 1) && (last & 1);
-	     lbase = lbase >> 1, last = last >> 1) ;
+	     lbase = lbase >> 1, last = last >> 1)
+		;
 	if (lbase != last) {
-		printk(KERN_WARNING "mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n",
+		pr_warning("mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n",
 		       base, size);
 		return -EINVAL;
 	}
@@ -708,7 +716,7 @@ static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
 	rdmsr(MSR_MTRRcap, config, dummy);
-	return (config & (1 << 10));
+	return config & (1 << 10);
 }
 
 int positive_have_wrcomb(void)
@@ -716,7 +724,8 @@ int positive_have_wrcomb(void)
 	return 1;
 }
 
-/* generic structure...
+/*
+ * generic structure...
  */
 struct mtrr_ops generic_mtrr_ops = {
 	.use_intel_if      = 1,
-- 
1.6.0.6



