Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYBRC5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYBRC5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYBRC5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:57:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbYBRC46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:56:58 -0500
Date: Mon, 18 Feb 2008 03:56:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Coding style fixes for
	arch/x86/kernel/cpu/centaur.c
Message-ID: <20080218025645.GB30201@elte.hu>
References: <20080217233023.26764dc9@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217233023.26764dc9@paolo-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> [PATCH] x86: Coding style fixes for arch/x86/kernel/cpu/centaur.c
> 
> Kills more than 150 errors/warnings

thanks Paolo, applied. This file was _really_ unclean.

btw., there were more style inconsistencies in this file, some of which 
were reported by checkpatch.pl - the patch below (ontop of yours) fixes 
them. Feel free to do such type of changes in future cleanup patches. 
Some of them are real CodingStyle problems, some of them are just 
arbitrary taste details. Now the file looks very clean in all of its 
details, and is completely checkpatch.pl --file clean as well. (If any 
of the changes i did is unclear, please ask.)

	Ingo

------------------->
Subject: x86: more coding style fixes in centaur.c
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Feb 18 03:30:47 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/centaur.c |  394 +++++++++++++++++++++---------------------
 1 file changed, 199 insertions(+), 195 deletions(-)

Index: linux-x86.q/arch/x86/kernel/cpu/centaur.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/centaur.c
+++ linux-x86.q/arch/x86/kernel/cpu/centaur.c
@@ -1,10 +1,12 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
+
 #include "cpu.h"
 
 #ifdef CONFIG_X86_OOSTORE
@@ -12,16 +14,17 @@
 static u32 __cpuinit power2(u32 x)
 {
 	u32 s = 1;
-	while(s <= x)
+
+	while (s <= x)
 		s <<= 1;
+
 	return s >>= 1;
 }
 
 
 /*
- *	Set up an actual MCR
+ * Set up an actual MCR
  */
-
 static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
 {
 	u32 lo, hi;
@@ -35,16 +38,15 @@ static void __cpuinit centaur_mcr_insert
 }
 
 /*
- *	Figure what we can cover with MCR's
+ * Figure what we can cover with MCR's
  *
- *	Shortcut: We know you can't put 4Gig of RAM on a winchip
+ * Shortcut: We know you can't put 4Gig of RAM on a winchip
  */
-
-static u32 __cpuinit ramtop(void)		/* 16388 */
+static u32 __cpuinit ramtop(void)
 {
-	int i;
-	u32 top = 0;
 	u32 clip = 0xFFFFFFFFUL;
+	u32 top = 0;
+	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
 		unsigned long start, end;
@@ -52,13 +54,12 @@ static u32 __cpuinit ramtop(void)		/* 16
 		if (e820.map[i].addr > 0xFFFFFFFFUL)
 			continue;
 		/*
-		 *	Don't MCR over reserved space. Ignore the ISA hole
-		 *	we frob around that catastrophe already
+		 * Don't MCR over reserved space. Ignore the ISA hole
+		 * we frob around that catastrophe already
 		 */
-
-		if (e820.map[i].type == E820_RESERVED)
-		{
-			if (e820.map[i].addr >= 0x100000UL && e820.map[i].addr < clip)
+		if (e820.map[i].type == E820_RESERVED) {
+			if (e820.map[i].addr >= 0x100000UL &&
+						e820.map[i].addr < clip)
 				clip = e820.map[i].addr;
 			continue;
 		}
@@ -69,64 +70,61 @@ static u32 __cpuinit ramtop(void)		/* 16
 		if (end > top)
 			top = end;
 	}
-	/* Everything below 'top' should be RAM except for the ISA hole.
-	   Because of the limited MCR's we want to map NV/ACPI into our
-	   MCR range for gunk in RAM
-
-	   Clip might cause us to MCR insufficient RAM but that is an
-	   acceptable failure mode and should only bite obscure boxes with
-	   a VESA hole at 15Mb
-
-	   The second case Clip sometimes kicks in is when the EBDA is marked
-	   as reserved. Again we fail safe with reasonable results
-	*/
-
-	if(top > clip)
+	/*
+	 * Everything below 'top' should be RAM except for the ISA hole.
+	 * Because of the limited MCR's we want to map NV/ACPI into our
+	 * MCR range for gunk in RAM
+	 *
+	 * Clip might cause us to MCR insufficient RAM but that is an
+	 * acceptable failure mode and should only bite obscure boxes with
+	 * a VESA hole at 15Mb
+	 *
+	 * The second case Clip sometimes kicks in is when the EBDA is marked
+	 * as reserved. Again we fail safe with reasonable results
+	 */
+	if (top > clip)
 		top = clip;
 
 	return top;
 }
 
 /*
- *	Compute a set of MCR's to give maximum coverage
+ * Compute a set of MCR's to give maximum coverage
  */
-
 static int __cpuinit centaur_mcr_compute(int nr, int key)
 {
-	u32 mem = ramtop();
 	u32 root = power2(mem);
+	u32 mem = ramtop();
 	u32 base = root;
 	u32 top = root;
 	u32 floor = 0;
 	int ct = 0;
 
-	while (ct < nr)
-	{
+	while (ct < nr) {
 		u32 fspace = 0;
+		u32 high;
+		u32 low;
 
 		/*
-		 *	Find the largest block we will fill going upwards
+		 * Find the largest block we will fill going upwards
 		 */
-
-		u32 high = power2(mem-top);
+		high = power2(mem-top);
 
 		/*
-		 *	Find the largest block we will fill going downwards
+		 * Find the largest block we will fill going downwards
 		 */
-
 		u32 low = base/2;
 
 		/*
-		 *	Don't fill below 1Mb going downwards as there
-		 *	is an ISA hole in the way.
+		 * Don't fill below 1Mb going downwards as there
+		 * is an ISA hole in the way.
 		 */
-
 		if (base <= 1024*1024)
 			low = 0;
 
 		/*
-		 *	See how much space we could cover by filling below
-		 *	the ISA hole
+		 * See how much space we could cover by filling below
+		 * the ISA hole
 		 */
 
 		if (floor == 0)
@@ -137,52 +135,48 @@ static int __cpuinit centaur_mcr_compute
 		/* And forget ROM space */
 
 		/*
-		 *	Now install the largest coverage we get
+		 * Now install the largest coverage we get
 		 */
-
-		if (fspace > high && fspace > low)
-		{
+		if (fspace > high && fspace > low) {
 			centaur_mcr_insert(ct, floor, fspace, key);
 			floor += fspace;
-		}
-		else if (high > low) {
+		} else if (high > low) {
 			centaur_mcr_insert(ct, top, high, key);
 			top += high;
-		}
-		else if (low > 0) {
+		} else if (low > 0) {
 			base -= low;
 			centaur_mcr_insert(ct, base, low, key);
-		}
-		else break;
+		} else
+			break;
 		ct++;
 	}
 	/*
-	 *	We loaded ct values. We now need to set the mask. The caller
-	 *	must do this bit.
+	 * We loaded ct values. We now need to set the mask. The caller
+	 * must do this bit.
 	 */
-
 	return ct;
 }
 
 static void __cpuinit centaur_create_optimal_mcr(void)
 {
+	int used;
 	int i;
+
 	/*
-	 *	Allocate up to 6 mcrs to mark as much of ram as possible
-	 *	as write combining and weak write ordered.
+	 * Allocate up to 6 mcrs to mark as much of ram as possible
+	 * as write combining and weak write ordered.
 	 *
-	 *	To experiment with: Linux never uses stack operations for
-	 *	mmio spaces so we could globally enable stack operation wc
+	 * To experiment with: Linux never uses stack operations for
+	 * mmio spaces so we could globally enable stack operation wc
 	 *
-	 *	Load the registers with type 31 - full write combining, all
-	 *	writes weakly ordered.
+	 * Load the registers with type 31 - full write combining, all
+	 * writes weakly ordered.
 	 */
-	int used = centaur_mcr_compute(6, 31);
+	used = centaur_mcr_compute(6, 31);
 
 	/*
-	 *	Wipe unused MCRs
+	 * Wipe unused MCRs
 	 */
-
 	for (i = used; i < 8; i++)
 		wrmsr(MSR_IDT_MCR0+i, 0, 0);
 }
@@ -190,31 +184,30 @@ static void __cpuinit centaur_create_opt
 static void __cpuinit winchip2_create_optimal_mcr(void)
 {
 	u32 lo, hi;
+	int used;
 	int i;
 
 	/*
-	 *	Allocate up to 6 mcrs to mark as much of ram as possible
-	 *	as write combining, weak store ordered.
+	 * Allocate up to 6 mcrs to mark as much of ram as possible
+	 * as write combining, weak store ordered.
 	 *
-	 *	Load the registers with type 25
-	 *		8	-	weak write ordering
-	 *		16	-	weak read ordering
-	 *		1	-	write combining
+	 * Load the registers with type 25
+	 *	8	-	weak write ordering
+	 *	16	-	weak read ordering
+	 *	1	-	write combining
 	 */
-
-	int used = centaur_mcr_compute(6, 25);
+	used = centaur_mcr_compute(6, 25);
 
 	/*
-	 *	Mark the registers we are using.
+	 * Mark the registers we are using.
 	 */
-
 	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
 	for (i = 0; i < used; i++)
 		lo |= 1<<(9+i);
 	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
 
 	/*
-	 *	Wipe unused MCRs
+	 * Wipe unused MCRs
 	 */
 
 	for (i = used; i < 8; i++)
@@ -222,9 +215,8 @@ static void __cpuinit winchip2_create_op
 }
 
 /*
- *	Handle the MCR key on the Winchip 2.
+ * Handle the MCR key on the Winchip 2.
  */
-
 static void __cpuinit winchip2_unprotect_mcr(void)
 {
 	u32 lo, hi;
@@ -301,28 +293,29 @@ static void __cpuinit init_c3(struct cpu
 	display_cacheinfo(c);
 }
 
+enum {
+		ECX8		= 1<<1,
+		EIERRINT	= 1<<2,
+		DPM		= 1<<3,
+		DMCE		= 1<<4,
+		DSTPCLK		= 1<<5,
+		ELINEAR		= 1<<6,
+		DSMC		= 1<<7,
+		DTLOCK		= 1<<8,
+		EDCTLB		= 1<<8,
+		EMMX		= 1<<9,
+		DPDC		= 1<<11,
+		EBRPRED		= 1<<12,
+		DIC		= 1<<13,
+		DDC		= 1<<14,
+		DNA		= 1<<15,
+		ERETSTK		= 1<<16,
+		E2MMX		= 1<<19,
+		EAMD3D		= 1<<20,
+};
+
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
-	enum {
-		ECX8 = 1<<1,
-		EIERRINT = 1<<2,
-		DPM = 1<<3,
-		DMCE = 1<<4,
-		DSTPCLK = 1<<5,
-		ELINEAR = 1<<6,
-		DSMC = 1<<7,
-		DTLOCK = 1<<8,
-		EDCTLB = 1<<8,
-		EMMX = 1<<9,
-		DPDC = 1<<11,
-		EBRPRED = 1<<12,
-		DIC = 1<<13,
-		DDC = 1<<14,
-		DNA = 1<<15,
-		ERETSTK = 1<<16,
-		E2MMX = 1<<19,
-		EAMD3D = 1<<20,
-	};
 
 	char *name;
 	u32  fcr_set = 0;
@@ -330,126 +323,137 @@ static void __cpuinit init_centaur(struc
 	u32  lo, hi, newlo;
 	u32  aa, bb, cc, dd;
 
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
 	clear_bit(0*32+31, c->x86_capability);
 
 	switch (c->x86) {
-
 	case 5:
-			switch (c->x86_model) {
-			case 4:
-				name = "C6";
-				fcr_set = ECX8|DSMC|EDCTLB|EMMX|ERETSTK;
-				fcr_clr = DPDC;
-				printk(KERN_NOTICE "Disabling bugged TSC.\n");
-				clear_bit(X86_FEATURE_TSC, c->x86_capability);
+		switch (c->x86_model) {
+		case 4:
+			name = "C6";
+			fcr_set = ECX8|DSMC|EDCTLB|EMMX|ERETSTK;
+			fcr_clr = DPDC;
+			printk(KERN_NOTICE "Disabling bugged TSC.\n");
+			clear_bit(X86_FEATURE_TSC, c->x86_capability);
 #ifdef CONFIG_X86_OOSTORE
-				centaur_create_optimal_mcr();
-				/* Enable
-					write combining on non-stack, non-string
-					write combining on string, all types
-					weak write ordering
-
-				   The C6 original lacks weak read order
-
-				   Note 0x120 is write only on Winchip 1 */
-
-				wrmsr(MSR_IDT_MCR_CTRL, 0x01F0001F, 0);
+			centaur_create_optimal_mcr();
+			/*
+			 * Enable:
+			 *	write combining on non-stack, non-string
+			 *	write combining on string, all types
+			 *	weak write ordering
+			 *
+			 * The C6 original lacks weak read order
+			 *
+			 * Note 0x120 is write only on Winchip 1
+			 */
+			wrmsr(MSR_IDT_MCR_CTRL, 0x01F0001F, 0);
 #endif
+			break;
+		case 8:
+			switch (c->x86_mask) {
+			default:
+			name = "2";
 				break;
-			case 8:
-				switch (c->x86_mask) {
-				default:
-					name = "2";
-					break;
-				case 7 ... 9:
-					name = "2A";
-					break;
-				case 10 ... 15:
-					name = "2B";
-					break;
-				}
-				fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|E2MMX|EAMD3D;
-				fcr_clr = DPDC;
+			case 7 ... 9:
+				name = "2A";
+				break;
+			case 10 ... 15:
+				name = "2B";
+				break;
+			}
+			fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|
+				  E2MMX|EAMD3D;
+			fcr_clr = DPDC;
 #ifdef CONFIG_X86_OOSTORE
-				winchip2_unprotect_mcr();
-				winchip2_create_optimal_mcr();
-				rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-				/* Enable
-					write combining on non-stack, non-string
-					write combining on string, all types
-					weak write ordering
-				*/
-				lo |= 31;
-				wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-				winchip2_protect_mcr();
+			winchip2_unprotect_mcr();
+			winchip2_create_optimal_mcr();
+			rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
+			/*
+			 * Enable:
+			 *	write combining on non-stack, non-string
+			 *	write combining on string, all types
+			 *	weak write ordering
+			 */
+			lo |= 31;
+			wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
+			winchip2_protect_mcr();
 #endif
-				break;
-			case 9:
-				name = "3";
-				fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|E2MMX|EAMD3D;
-				fcr_clr = DPDC;
+			break;
+		case 9:
+			name = "3";
+			fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|
+				  E2MMX|EAMD3D;
+			fcr_clr = DPDC;
 #ifdef CONFIG_X86_OOSTORE
-				winchip2_unprotect_mcr();
-				winchip2_create_optimal_mcr();
-				rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-				/* Enable
-					write combining on non-stack, non-string
-					write combining on string, all types
-					weak write ordering
-				*/
-				lo |= 31;
-				wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-				winchip2_protect_mcr();
+			winchip2_unprotect_mcr();
+			winchip2_create_optimal_mcr();
+			rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
+			/*
+			 * Enable:
+			 *	write combining on non-stack, non-string
+			 *	write combining on string, all types
+			 *	weak write ordering
+			 */
+			lo |= 31;
+			wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
+			winchip2_protect_mcr();
 #endif
-				break;
-			default:
-				name = "??";
-			}
+			break;
+		default:
+			name = "??";
+		}
 
-			rdmsr(MSR_IDT_FCR1, lo, hi);
-			newlo = (lo|fcr_set) & (~fcr_clr);
+		rdmsr(MSR_IDT_FCR1, lo, hi);
+		newlo = (lo|fcr_set) & (~fcr_clr);
 
-			if (newlo != lo) {
-				printk(KERN_INFO "Centaur FCR was 0x%X now 0x%X\n", lo, newlo);
-				wrmsr(MSR_IDT_FCR1, newlo, hi);
-			} else {
-				printk(KERN_INFO "Centaur FCR is 0x%X\n", lo);
-			}
-			/* Emulate MTRRs using Centaur's MCR. */
-			set_bit(X86_FEATURE_CENTAUR_MCR, c->x86_capability);
-			/* Report CX8 */
-			set_bit(X86_FEATURE_CX8, c->x86_capability);
-			/* Set 3DNow! on Winchip 2 and above. */
-			if (c->x86_model >= 8)
-				set_bit(X86_FEATURE_3DNOW, c->x86_capability);
-			/* See if we can find out some more. */
-			if (cpuid_eax(0x80000000) >= 0x80000005) {
-				/* Yes, we can. */
-				cpuid(0x80000005, &aa, &bb, &cc, &dd);
-				/* Add L1 data and code cache sizes. */
-				c->x86_cache_size = (cc>>24)+(dd>>24);
-			}
-			sprintf(c->x86_model_id, "WinChip %s", name);
-			break;
+		if (newlo != lo) {
+			printk(KERN_INFO "Centaur FCR was 0x%X now 0x%X\n",
+				lo, newlo);
+			wrmsr(MSR_IDT_FCR1, newlo, hi);
+		} else {
+			printk(KERN_INFO "Centaur FCR is 0x%X\n", lo);
+		}
+		/* Emulate MTRRs using Centaur's MCR. */
+		set_bit(X86_FEATURE_CENTAUR_MCR, c->x86_capability);
+		/* Report CX8 */
+		set_bit(X86_FEATURE_CX8, c->x86_capability);
+		/* Set 3DNow! on Winchip 2 and above. */
+		if (c->x86_model >= 8)
+			set_bit(X86_FEATURE_3DNOW, c->x86_capability);
+		/* See if we can find out some more. */
+		if (cpuid_eax(0x80000000) >= 0x80000005) {
+			/* Yes, we can. */
+			cpuid(0x80000005, &aa, &bb, &cc, &dd);
+			/* Add L1 data and code cache sizes. */
+			c->x86_cache_size = (cc>>24)+(dd>>24);
+		}
+		sprintf(c->x86_model_id, "WinChip %s", name);
+		break;
 
 	case 6:
-			init_c3(c);
-			break;
+		init_c3(c);
+		break;
 	}
 }
 
-static unsigned int __cpuinit centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+static unsigned int __cpuinit
+centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* VIA C3 CPUs (670-68F) need further shifting. */
 	if ((c->x86 == 6) && ((c->x86_model == 7) || (c->x86_model == 8)))
 		size >>= 8;
 
-	/* VIA also screwed up Nehemiah stepping 1, and made
-	   it return '65KB' instead of '64KB'
-	   - Note, it seems this may only be in engineering samples. */
-	if ((c->x86 == 6) && (c->x86_model == 9) && (c->x86_mask == 1) && (size == 65))
+	/*
+	 * There's also an erratum in Nehemiah stepping 1, which
+	 * returns '65KB' instead of '64KB'
+	 *  - Note, it seems this may only be in engineering samples.
+	 */
+	if ((c->x86 == 6) && (c->x86_model == 9) &&
+				(c->x86_mask == 1) && (size == 65))
 		size -= 1;
 
 	return size;
