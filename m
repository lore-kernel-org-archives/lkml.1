Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZGDKH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZGDKH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZGDKHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:07:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:47389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbZGDKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:07:38 -0400
Date: Sat, 4 Jul 2009 10:07:01 GMT
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
Subject: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
Message-ID: <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
Git-Commit-ID: 63f9600fadb10ea739108ae93e3e842d9843c58b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63f9600fadb10ea739108ae93e3e842d9843c58b
Gitweb:     http://git.kernel.org/tip/63f9600fadb10ea739108ae93e3e842d9843c58b
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:51:32 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:10:46 +0200

x86: Clean up mtrr/cleanup.c

Fix trivial style problems:

  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
  WARNING: Use #include <linux/kvm_para.h> instead of <asm/kvm_para.h>

Also, nr_mtrr_spare_reg should be unsigned long.

arch/x86/kernel/cpu/mtrr/cleanup.o:

   text	   data	    bss	    dec	    hex	filename
   6241	   8992	   2056	  17289	   4389	cleanup.o.before
   6241	   8992	   2056	  17289	   4389	cleanup.o.after

The md5 has changed:
   1a7a27513aef1825236daf29110fe657  cleanup.o.before.asm
   bcea358efa2532b6020e338e158447af  cleanup.o.after.asm

Because a WARN_ON()'s __LINE__ value changed by 3 lines.

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ Did lots of other cleanups to make the code look more consistent. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/cleanup.c |  350 ++++++++++++++++++------------------
 1 files changed, 176 insertions(+), 174 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 1d584a1..b8aba81 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -1,51 +1,52 @@
-/*  MTRR (Memory Type Range Register) cleanup
-
-    Copyright (C) 2009 Yinghai Lu
-
-    This library is free software; you can redistribute it and/or
-    modify it under the terms of the GNU Library General Public
-    License as published by the Free Software Foundation; either
-    version 2 of the License, or (at your option) any later version.
-
-    This library is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-    Library General Public License for more details.
-
-    You should have received a copy of the GNU Library General Public
-    License along with this library; if not, write to the Free
-    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
+/*
+ * MTRR (Memory Type Range Register) cleanup
+ *
+ *  Copyright (C) 2009 Yinghai Lu
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
-#include <linux/mutex.h>
 #include <linux/sort.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_para.h>
 
+#include <asm/processor.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
+
 #include "mtrr.h"
 
-/* should be related to MTRR_VAR_RANGES nums */
+/* Should be related to MTRR_VAR_RANGES nums */
 #define RANGE_NUM 256
 
 struct res_range {
-	unsigned long start;
-	unsigned long end;
+	unsigned long	start;
+	unsigned long	end;
 };
 
 static int __init
-add_range(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end)
+add_range(struct res_range *range, int nr_range,
+	  unsigned long start, unsigned long end)
 {
-	/* out of slots */
+	/* Out of slots: */
 	if (nr_range >= RANGE_NUM)
 		return nr_range;
 
@@ -58,12 +59,12 @@ add_range(struct res_range *range, int nr_range, unsigned long start,
 }
 
 static int __init
-add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end)
+add_range_with_merge(struct res_range *range, int nr_range,
+		     unsigned long start, unsigned long end)
 {
 	int i;
 
-	/* try to merge it with old one */
+	/* Try to merge it with old one: */
 	for (i = 0; i < nr_range; i++) {
 		unsigned long final_start, final_end;
 		unsigned long common_start, common_end;
@@ -84,7 +85,7 @@ add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
 		return nr_range;
 	}
 
-	/* need to add that */
+	/* Need to add it: */
 	return add_range(range, nr_range, start, end);
 }
 
@@ -117,7 +118,7 @@ subtract_range(struct res_range *range, unsigned long start, unsigned long end)
 		}
 
 		if (start > range[j].start && end < range[j].end) {
-			/* find the new spare */
+			/* Find the new spare: */
 			for (i = 0; i < RANGE_NUM; i++) {
 				if (range[i].end == 0)
 					break;
@@ -147,13 +148,19 @@ static int __init cmp_range(const void *x1, const void *x2)
 }
 
 struct var_mtrr_range_state {
-	unsigned long base_pfn;
-	unsigned long size_pfn;
-	mtrr_type type;
+	unsigned long	base_pfn;
+	unsigned long	size_pfn;
+	mtrr_type	type;
 };
 
 static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
+
 static int __initdata debug_print;
+#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
+
+
+#define BIOS_BUG_MSG KERN_WARNING \
+	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
 static int __init
 x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
@@ -180,7 +187,7 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 				 range[i].start, range[i].end + 1);
 	}
 
-	/* take out UC ranges */
+	/* Take out UC ranges: */
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
 		if (type != MTRR_TYPE_UNCACHABLE &&
@@ -244,10 +251,9 @@ static int __initdata nr_range;
 
 static unsigned long __init sum_ranges(struct res_range *range, int nr_range)
 {
-	unsigned long sum;
+	unsigned long sum = 0;
 	int i;
 
-	sum = 0;
 	for (i = 0; i < nr_range; i++)
 		sum += range[i].end + 1 - range[i].start;
 
@@ -288,7 +294,7 @@ struct var_mtrr_state {
 
 static void __init
 set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
-		unsigned char type, unsigned int address_bits)
+	     unsigned char type, unsigned int address_bits)
 {
 	u32 base_lo, base_hi, mask_lo, mask_hi;
 	u64 base, mask;
@@ -301,7 +307,7 @@ set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
 	mask = (1ULL << address_bits) - 1;
 	mask &= ~((((u64)sizek) << 10) - 1);
 
-	base  = ((u64)basek) << 10;
+	base = ((u64)basek) << 10;
 
 	base |= type;
 	mask |= 0x800;
@@ -317,15 +323,14 @@ set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
 
 static void __init
 save_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
-		unsigned char type)
+	      unsigned char type)
 {
 	range_state[reg].base_pfn = basek >> (PAGE_SHIFT - 10);
 	range_state[reg].size_pfn = sizek >> (PAGE_SHIFT - 10);
 	range_state[reg].type = type;
 }
 
-static void __init
-set_var_mtrr_all(unsigned int address_bits)
+static void __init set_var_mtrr_all(unsigned int address_bits)
 {
 	unsigned long basek, sizek;
 	unsigned char type;
@@ -342,11 +347,11 @@ set_var_mtrr_all(unsigned int address_bits)
 
 static unsigned long to_size_factor(unsigned long sizek, char *factorp)
 {
-	char factor;
 	unsigned long base = sizek;
+	char factor;
 
 	if (base & ((1<<10) - 1)) {
-		/* not MB alignment */
+		/* Not MB-aligned: */
 		factor = 'K';
 	} else if (base & ((1<<20) - 1)) {
 		factor = 'M';
@@ -372,11 +377,12 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 		unsigned long max_align, align;
 		unsigned long sizek;
 
-		/* Compute the maximum size I can make a range */
+		/* Compute the maximum size with which we can make a range: */
 		if (range_startk)
 			max_align = ffs(range_startk) - 1;
 		else
 			max_align = 32;
+
 		align = fls(range_sizek) - 1;
 		if (align > max_align)
 			align = max_align;
@@ -386,11 +392,10 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 			char start_factor = 'K', size_factor = 'K';
 			unsigned long start_base, size_base;
 
-			start_base = to_size_factor(range_startk,
-							 &start_factor),
-			size_base = to_size_factor(sizek, &size_factor),
+			start_base = to_size_factor(range_startk, &start_factor);
+			size_base = to_size_factor(sizek, &size_factor);
 
-			printk(KERN_DEBUG "Setting variable MTRR %d, "
+			Dprintk("Setting variable MTRR %d, "
 				"base: %ld%cB, range: %ld%cB, type %s\n",
 				reg, start_base, start_factor,
 				size_base, size_factor,
@@ -425,10 +430,11 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 	chunk_sizek = state->chunk_sizek;
 	gran_sizek = state->gran_sizek;
 
-	/* align with gran size, prevent small block used up MTRRs */
+	/* Align with gran size, prevent small block used up MTRRs: */
 	range_basek = ALIGN(state->range_startk, gran_sizek);
 	if ((range_basek > basek) && basek)
 		return second_sizek;
+
 	state->range_sizek -= (range_basek - state->range_startk);
 	range_sizek = ALIGN(state->range_sizek, gran_sizek);
 
@@ -439,22 +445,21 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 	}
 	state->range_sizek = range_sizek;
 
-	/* try to append some small hole */
+	/* Try to append some small hole: */
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
 
-	/* no increase */
+	/* No increase: */
 	if (range0_sizek == state->range_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "rangeX: %016lx - %016lx\n",
-				range0_basek<<10,
-				(range0_basek + state->range_sizek)<<10);
+		Dprintk("rangeX: %016lx - %016lx\n",
+			range0_basek<<10,
+			(range0_basek + state->range_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				state->range_sizek, MTRR_TYPE_WRBACK);
 		return 0;
 	}
 
-	/* only cut back, when it is not the last */
+	/* Only cut back when it is not the last: */
 	if (sizek) {
 		while (range0_basek + range0_sizek > (basek + sizek)) {
 			if (range0_sizek >= chunk_sizek)
@@ -470,16 +475,16 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 second_try:
 	range_basek = range0_basek + range0_sizek;
 
-	/* one hole in the middle */
+	/* One hole in the middle: */
 	if (range_basek > basek && range_basek <= (basek + sizek))
 		second_sizek = range_basek - basek;
 
 	if (range0_sizek > state->range_sizek) {
 
-		/* one hole in middle or at end */
+		/* One hole in middle or at the end: */
 		hole_sizek = range0_sizek - state->range_sizek - second_sizek;
 
-		/* hole size should be less than half of range0 size */
+		/* Hole size should be less than half of range0 size: */
 		if (hole_sizek >= (range0_sizek >> 1) &&
 		    range0_sizek >= chunk_sizek) {
 			range0_sizek -= chunk_sizek;
@@ -491,32 +496,30 @@ second_try:
 	}
 
 	if (range0_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "range0: %016lx - %016lx\n",
-				range0_basek<<10,
-				(range0_basek + range0_sizek)<<10);
+		Dprintk("range0: %016lx - %016lx\n",
+			range0_basek<<10,
+			(range0_basek + range0_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				range0_sizek, MTRR_TYPE_WRBACK);
 	}
 
 	if (range0_sizek < state->range_sizek) {
-		/* need to handle left over */
+		/* Need to handle left over range: */
 		range_sizek = state->range_sizek - range0_sizek;
 
-		if (debug_print)
-			printk(KERN_DEBUG "range: %016lx - %016lx\n",
-				 range_basek<<10,
-				 (range_basek + range_sizek)<<10);
+		Dprintk("range: %016lx - %016lx\n",
+			 range_basek<<10,
+			 (range_basek + range_sizek)<<10);
+
 		state->reg = range_to_mtrr(state->reg, range_basek,
 				 range_sizek, MTRR_TYPE_WRBACK);
 	}
 
 	if (hole_sizek) {
 		hole_basek = range_basek - hole_sizek - second_sizek;
-		if (debug_print)
-			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
-				 hole_basek<<10,
-				 (hole_basek + hole_sizek)<<10);
+		Dprintk("hole: %016lx - %016lx\n",
+			 hole_basek<<10,
+			 (hole_basek + hole_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, hole_basek,
 				 hole_sizek, MTRR_TYPE_UNCACHABLE);
 	}
@@ -537,23 +540,23 @@ set_var_mtrr_range(struct var_mtrr_state *state, unsigned long base_pfn,
 	basek = base_pfn << (PAGE_SHIFT - 10);
 	sizek = size_pfn << (PAGE_SHIFT - 10);
 
-	/* See if I can merge with the last range */
+	/* See if I can merge with the last range: */
 	if ((basek <= 1024) ||
 	    (state->range_startk + state->range_sizek == basek)) {
 		unsigned long endk = basek + sizek;
 		state->range_sizek = endk - state->range_startk;
 		return;
 	}
-	/* Write the range mtrrs */
+	/* Write the range mtrrs: */
 	if (state->range_sizek != 0)
 		second_sizek = range_to_mtrr_with_hole(state, basek, sizek);
 
-	/* Allocate an msr */
+	/* Allocate an msr: */
 	state->range_startk = basek + second_sizek;
 	state->range_sizek  = sizek - second_sizek;
 }
 
-/* mininum size of mtrr block that can take hole */
+/* Mininum size of mtrr block that can take hole: */
 static u64 mtrr_chunk_size __initdata = (256ULL<<20);
 
 static int __init parse_mtrr_chunk_size_opt(char *p)
@@ -565,7 +568,7 @@ static int __init parse_mtrr_chunk_size_opt(char *p)
 }
 early_param("mtrr_chunk_size", parse_mtrr_chunk_size_opt);
 
-/* granity of mtrr of block */
+/* Granularity of mtrr of block: */
 static u64 mtrr_gran_size __initdata;
 
 static int __init parse_mtrr_gran_size_opt(char *p)
@@ -577,7 +580,7 @@ static int __init parse_mtrr_gran_size_opt(char *p)
 }
 early_param("mtrr_gran_size", parse_mtrr_gran_size_opt);
 
-static int nr_mtrr_spare_reg __initdata =
+static unsigned long nr_mtrr_spare_reg __initdata =
 				 CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT;
 
 static int __init parse_mtrr_spare_reg(char *arg)
@@ -586,7 +589,6 @@ static int __init parse_mtrr_spare_reg(char *arg)
 		nr_mtrr_spare_reg = simple_strtoul(arg, NULL, 0);
 	return 0;
 }
-
 early_param("mtrr_spare_reg_nr", parse_mtrr_spare_reg);
 
 static int __init
@@ -594,8 +596,8 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 		    u64 chunk_size, u64 gran_size)
 {
 	struct var_mtrr_state var_state;
-	int i;
 	int num_reg;
+	int i;
 
 	var_state.range_startk	= 0;
 	var_state.range_sizek	= 0;
@@ -605,17 +607,18 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 
 	memset(range_state, 0, sizeof(range_state));
 
-	/* Write the range etc */
-	for (i = 0; i < nr_range; i++)
+	/* Write the range: */
+	for (i = 0; i < nr_range; i++) {
 		set_var_mtrr_range(&var_state, range[i].start,
 				   range[i].end - range[i].start + 1);
+	}
 
-	/* Write the last range */
+	/* Write the last range: */
 	if (var_state.range_sizek != 0)
 		range_to_mtrr_with_hole(&var_state, 0, 0);
 
 	num_reg = var_state.reg;
-	/* Clear out the extra MTRR's */
+	/* Clear out the extra MTRR's: */
 	while (var_state.reg < num_var_ranges) {
 		save_var_mtrr(var_state.reg, 0, 0, 0);
 		var_state.reg++;
@@ -625,11 +628,11 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 }
 
 struct mtrr_cleanup_result {
-	unsigned long gran_sizek;
-	unsigned long chunk_sizek;
-	unsigned long lose_cover_sizek;
-	unsigned int num_reg;
-	int bad;
+	unsigned long	gran_sizek;
+	unsigned long	chunk_sizek;
+	unsigned long	lose_cover_sizek;
+	unsigned int	num_reg;
+	int		bad;
 };
 
 /*
@@ -645,10 +648,10 @@ static unsigned long __initdata min_loss_pfn[RANGE_NUM];
 
 static void __init print_out_mtrr_range_state(void)
 {
-	int i;
 	char start_factor = 'K', size_factor = 'K';
 	unsigned long start_base, size_base;
 	mtrr_type type;
+	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
 
@@ -676,10 +679,10 @@ static int __init mtrr_need_cleanup(void)
 	int i;
 	mtrr_type type;
 	unsigned long size;
-	/* extra one for all 0 */
+	/* Extra one for all 0: */
 	int num[MTRR_NUM_TYPES + 1];
 
-	/* check entries number */
+	/* Check entries number: */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
@@ -693,88 +696,86 @@ static int __init mtrr_need_cleanup(void)
 		num[type]++;
 	}
 
-	/* check if we got UC entries */
+	/* Check if we got UC entries: */
 	if (!num[MTRR_TYPE_UNCACHABLE])
 		return 0;
 
-	/* check if we only had WB and UC */
+	/* Check if we only had WB and UC */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
-		num_var_ranges - num[MTRR_NUM_TYPES])
+	    num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
 
 	return 1;
 }
 
 static unsigned long __initdata range_sums;
-static void __init mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
-					 unsigned long extra_remove_base,
-					 unsigned long extra_remove_size,
-					 int i)
+
+static void __init
+mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
+		      unsigned long x_remove_base,
+		      unsigned long x_remove_size, int i)
 {
-	int num_reg;
 	static struct res_range range_new[RANGE_NUM];
-	static int nr_range_new;
 	unsigned long range_sums_new;
+	static int nr_range_new;
+	int num_reg;
 
-	/* convert ranges to var ranges state */
-	num_reg = x86_setup_var_mtrrs(range, nr_range,
-						chunk_size, gran_size);
+	/* Convert ranges to var ranges state: */
+	num_reg = x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
 
-	/* we got new setting in range_state, check it */
+	/* We got new setting in range_state, check it: */
 	memset(range_new, 0, sizeof(range_new));
 	nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
-				extra_remove_base, extra_remove_size);
+				x_remove_base, x_remove_size);
 	range_sums_new = sum_ranges(range_new, nr_range_new);
 
 	result[i].chunk_sizek = chunk_size >> 10;
 	result[i].gran_sizek = gran_size >> 10;
 	result[i].num_reg = num_reg;
+
 	if (range_sums < range_sums_new) {
-		result[i].lose_cover_sizek =
-			(range_sums_new - range_sums) << PSHIFT;
+		result[i].lose_cover_sizek = (range_sums_new - range_sums) << PSHIFT;
 		result[i].bad = 1;
-	} else
-		result[i].lose_cover_sizek =
-			(range_sums - range_sums_new) << PSHIFT;
+	} else {
+		result[i].lose_cover_sizek = (range_sums - range_sums_new) << PSHIFT;
+	}
 
-	/* double check it */
+	/* Double check it: */
 	if (!result[i].bad && !result[i].lose_cover_sizek) {
-		if (nr_range_new != nr_range ||
-			memcmp(range, range_new, sizeof(range)))
-				result[i].bad = 1;
+		if (nr_range_new != nr_range || memcmp(range, range_new, sizeof(range)))
+			result[i].bad = 1;
 	}
 
-	if (!result[i].bad && (range_sums - range_sums_new <
-				min_loss_pfn[num_reg])) {
-		min_loss_pfn[num_reg] =
-			range_sums - range_sums_new;
-	}
+	if (!result[i].bad && (range_sums - range_sums_new < min_loss_pfn[num_reg]))
+		min_loss_pfn[num_reg] = range_sums - range_sums_new;
 }
 
 static void __init mtrr_print_out_one_result(int i)
 {
-	char gran_factor, chunk_factor, lose_factor;
 	unsigned long gran_base, chunk_base, lose_base;
+	char gran_factor, chunk_factor, lose_factor;
 
 	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
 	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
 	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
-	printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
-			result[i].bad ? "*BAD*" : " ",
-			gran_base, gran_factor, chunk_base, chunk_factor);
-	printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
-			result[i].num_reg, result[i].bad ? "-" : "",
-			lose_base, lose_factor);
+
+	pr_info("%sgran_size: %ld%c \tchunk_size: %ld%c \t",
+		result[i].bad ? "*BAD*" : " ",
+		gran_base, gran_factor, chunk_base, chunk_factor);
+	pr_cont("num_reg: %d  \tlose cover RAM: %s%ld%c\n",
+		result[i].num_reg, result[i].bad ? "-" : "",
+		lose_base, lose_factor);
 }
 
 static int __init mtrr_search_optimal_index(void)
 {
-	int i;
 	int num_reg_good;
 	int index_good;
+	int i;
 
 	if (nr_mtrr_spare_reg >= num_var_ranges)
 		nr_mtrr_spare_reg = num_var_ranges - 1;
+
 	num_reg_good = -1;
 	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
 		if (!min_loss_pfn[i])
@@ -796,24 +797,24 @@ static int __init mtrr_search_optimal_index(void)
 	return index_good;
 }
 
-
 int __init mtrr_cleanup(unsigned address_bits)
 {
-	unsigned long extra_remove_base, extra_remove_size;
+	unsigned long x_remove_base, x_remove_size;
 	unsigned long base, size, def, dummy;
-	mtrr_type type;
 	u64 chunk_size, gran_size;
+	mtrr_type type;
 	int index_good;
 	int i;
 
 	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
 		return 0;
+
 	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	/* get it and store it aside */
+	/* Get it and store it aside: */
 	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -822,29 +823,28 @@ int __init mtrr_cleanup(unsigned address_bits)
 		range_state[i].type = type;
 	}
 
-	/* check if we need handle it and can handle it */
+	/* Check if we need handle it and can handle it: */
 	if (!mtrr_need_cleanup())
 		return 0;
 
-	/* print original var MTRRs at first, for debugging: */
+	/* Print original var MTRRs at first, for debugging: */
 	printk(KERN_DEBUG "original variable MTRRs\n");
 	print_out_mtrr_range_state();
 
 	memset(range, 0, sizeof(range));
-	extra_remove_size = 0;
-	extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	x_remove_size = 0;
+	x_remove_base = 1 << (32 - PAGE_SHIFT);
 	if (mtrr_tom2)
-		extra_remove_size =
-			(mtrr_tom2 >> PAGE_SHIFT) - extra_remove_base;
-	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
-					  extra_remove_size);
+		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
+
+	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
-	 * [0, 1M) should always be coverred by var mtrr with WB
-	 * and fixed mtrrs should take effective before var mtrr for it
+	 * [0, 1M) should always be covered by var mtrr with WB
+	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
 	nr_range = add_range_with_merge(range, nr_range, 0,
 					(1ULL<<(20 - PAGE_SHIFT)) - 1);
-	/* sort the ranges */
+	/* Sort the ranges: */
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 
 	range_sums = sum_ranges(range, nr_range);
@@ -854,7 +854,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		i = 0;
 		mtrr_calc_range_state(mtrr_chunk_size, mtrr_gran_size,
-				      extra_remove_base, extra_remove_size, i);
+				      x_remove_base, x_remove_size, i);
 
 		mtrr_print_out_one_result(i);
 
@@ -880,7 +880,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 				continue;
 
 			mtrr_calc_range_state(chunk_size, gran_size,
-				      extra_remove_base, extra_remove_size, i);
+				      x_remove_base, x_remove_size, i);
 			if (debug_print) {
 				mtrr_print_out_one_result(i);
 				printk(KERN_INFO "\n");
@@ -890,7 +890,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		}
 	}
 
-	/* try to find the optimal index */
+	/* Try to find the optimal index: */
 	index_good = mtrr_search_optimal_index();
 
 	if (index_good != -1) {
@@ -898,7 +898,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		i = index_good;
 		mtrr_print_out_one_result(i);
 
-		/* convert ranges to var ranges state */
+		/* Convert ranges to var ranges state: */
 		chunk_size = result[i].chunk_sizek;
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
@@ -941,8 +941,8 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
  * Note this won't check if the MTRRs < 4GB where the magic bit doesn't
  * apply to are wrong, but so far we don't know of any such case in the wild.
  */
-#define Tom2Enabled (1U << 21)
-#define Tom2ForceMemTypeWB (1U << 22)
+#define Tom2Enabled		(1U << 21)
+#define Tom2ForceMemTypeWB	(1U << 22)
 
 int __init amd_special_default_mtrr(void)
 {
@@ -952,7 +952,7 @@ int __init amd_special_default_mtrr(void)
 		return 0;
 	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
 		return 0;
-	/* In case some hypervisor doesn't pass SYSCFG through */
+	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
 		return 0;
 	/*
@@ -965,19 +965,21 @@ int __init amd_special_default_mtrr(void)
 	return 0;
 }
 
-static u64 __init real_trim_memory(unsigned long start_pfn,
-				   unsigned long limit_pfn)
+static u64 __init
+real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
 {
 	u64 trim_start, trim_size;
+
 	trim_start = start_pfn;
 	trim_start <<= PAGE_SHIFT;
+
 	trim_size = limit_pfn;
 	trim_size <<= PAGE_SHIFT;
 	trim_size -= trim_start;
 
-	return e820_update_range(trim_start, trim_size, E820_RAM,
-				E820_RESERVED);
+	return e820_update_range(trim_start, trim_size, E820_RAM, E820_RESERVED);
 }
+
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
  * @end_pfn: ending page frame number
@@ -985,7 +987,7 @@ static u64 __init real_trim_memory(unsigned long start_pfn,
  * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
  * memory configurations.  This routine checks that the highest MTRR matches
  * the end of memory, to make sure the MTRRs having a write back type cover
- * all of the memory the kernel is intending to use. If not, it'll trim any
+ * all of the memory the kernel is intending to use.  If not, it'll trim any
  * memory off the end by adjusting end_pfn, removing it from the kernel's
  * allocation pools, warning the user with an obnoxious message.
  */
@@ -994,21 +996,22 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
 	u64 total_trim_size;
-
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
+
 	/*
 	 * Make sure we only trim uncachable memory on machines that
 	 * support the Intel MTRR architecture:
 	 */
 	if (!is_cpu(INTEL) || disable_mtrr_trim)
 		return 0;
+
 	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	/* get it and store it aside */
+	/* Get it and store it aside: */
 	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -1017,7 +1020,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		range_state[i].type = type;
 	}
 
-	/* Find highest cached pfn */
+	/* Find highest cached pfn: */
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
 		if (type != MTRR_TYPE_WRBACK)
@@ -1028,13 +1031,13 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 			highest_pfn = base + size;
 	}
 
-	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
+	/* kvm/qemu doesn't have mtrr set right, don't trim them all: */
 	if (!highest_pfn) {
 		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 
-	/* check entries number */
+	/* Check entries number: */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
@@ -1046,11 +1049,11 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		num[type]++;
 	}
 
-	/* no entry for WB? */
+	/* No entry for WB? */
 	if (!num[MTRR_TYPE_WRBACK])
 		return 0;
 
-	/* check if we only had WB and UC */
+	/* Check if we only had WB and UC: */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
 		num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
@@ -1066,31 +1069,31 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	}
 	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
 
+	/* Check the head: */
 	total_trim_size = 0;
-	/* check the head */
 	if (range[0].start)
 		total_trim_size += real_trim_memory(0, range[0].start);
-	/* check the holes */
+
+	/* Check the holes: */
 	for (i = 0; i < nr_range - 1; i++) {
 		if (range[i].end + 1 < range[i+1].start)
 			total_trim_size += real_trim_memory(range[i].end + 1,
 							    range[i+1].start);
 	}
-	/* check the top */
+
+	/* Check the top: */
 	i = nr_range - 1;
 	if (range[i].end + 1 < end_pfn)
 		total_trim_size += real_trim_memory(range[i].end + 1,
 							 end_pfn);
 
 	if (total_trim_size) {
-		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
-			" all of memory, losing %lluMB of RAM.\n",
-			total_trim_size >> 20);
+		pr_warning("WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing %lluMB of RAM.\n", total_trim_size >> 20);
 
 		if (!changed_by_mtrr_cleanup)
 			WARN_ON(1);
 
-		printk(KERN_INFO "update e820 for mtrr\n");
+		pr_info("update e820 for mtrr\n");
 		update_e820();
 
 		return 1;
@@ -1098,4 +1101,3 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	return 0;
 }
-
