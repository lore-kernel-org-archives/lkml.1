Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZGDKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZGDKIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbZGDKHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:07:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:47397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbZGDKHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:07:50 -0400
Date: Sat, 4 Jul 2009 10:07:13 GMT
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
Subject: [tip:x86/cleanups] x86: Clean up mtrr/cyrix.c
Message-ID: <tip-2311037708c170977506fbcbe0a2ba0c6d221940@git.kernel.org>
Git-Commit-ID: 2311037708c170977506fbcbe0a2ba0c6d221940
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:07:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2311037708c170977506fbcbe0a2ba0c6d221940
Gitweb:     http://git.kernel.org/tip/2311037708c170977506fbcbe0a2ba0c6d221940
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:52:08 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:10:47 +0200

x86: Clean up mtrr/cyrix.c

Fix trivial style problems:

  WARNING: Use #include <linux/io.h> instead of <asm/io.h>
  WARNING: line over 80 characters
  ERROR: do not initialise statics to 0 or NULL
  ERROR: space prohibited after that open parenthesis '(' X 2
  ERROR: space prohibited before that close parenthesis ')' X 2
  ERROR: trailing whitespace X 2
  ERROR: trailing statements should be on next line
  ERROR: do not use C99 // comments X 2

arch/x86/kernel/cpu/mtrr/cyrix.o:

   text	   data	    bss	    dec	    hex	filename
   1637	     32	      8	   1677	    68d	cyrix.o.before
   1637	     32	      8	   1677	    68d	cyrix.o.after

md5:
   6f52abd06905be3f4cabb5239f9b0ff0  cyrix.o.before.asm
   6f52abd06905be3f4cabb5239f9b0ff0  cyrix.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ Made the code more consistent ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/cyrix.c |   94 ++++++++++++++++++++-----------------
 1 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index ff14c32..228d982 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -1,38 +1,40 @@
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/mm.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-#include <asm/io.h>
+
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
+#include <asm/mtrr.h>
+#include <asm/msr.h>
+
 #include "mtrr.h"
 
 static void
 cyrix_get_arr(unsigned int reg, unsigned long *base,
 	      unsigned long *size, mtrr_type * type)
 {
-	unsigned long flags;
 	unsigned char arr, ccr3, rcr, shift;
+	unsigned long flags;
 
 	arr = CX86_ARR_BASE + (reg << 1) + reg;	/* avoid multiplication by 3 */
 
-	/* Save flags and disable interrupts */
 	local_irq_save(flags);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
-	((unsigned char *) base)[3] = getCx86(arr);
-	((unsigned char *) base)[2] = getCx86(arr + 1);
-	((unsigned char *) base)[1] = getCx86(arr + 2);
+	((unsigned char *)base)[3] = getCx86(arr);
+	((unsigned char *)base)[2] = getCx86(arr + 1);
+	((unsigned char *)base)[1] = getCx86(arr + 2);
 	rcr = getCx86(CX86_RCR_BASE + reg);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
+	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 
-	/* Enable interrupts if it was enabled previously */
 	local_irq_restore(flags);
+
 	shift = ((unsigned char *) base)[1] & 0x0f;
 	*base >>= PAGE_SHIFT;
 
-	/* Power of two, at least 4K on ARR0-ARR6, 256K on ARR7
+	/*
+	 * Power of two, at least 4K on ARR0-ARR6, 256K on ARR7
 	 * Note: shift==0xf means 4G, this is unsupported.
 	 */
 	if (shift)
@@ -76,17 +78,20 @@ cyrix_get_arr(unsigned int reg, unsigned long *base,
 	}
 }
 
+/*
+ * cyrix_get_free_region - get a free ARR.
+ *
+ * @base: the starting (base) address of the region.
+ * @size: the size (in bytes) of the region.
+ *
+ * Returns: the index of the region on success, else -1 on error.
+*/
 static int
 cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free ARR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
-	int i;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i;
 
 	switch (replace_reg) {
 	case 7:
@@ -107,14 +112,17 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 		cyrix_get_arr(7, &lbase, &lsize, &ltype);
 		if (lsize == 0)
 			return 7;
-		/*  Else try ARR0-ARR6 first  */
+		/* Else try ARR0-ARR6 first  */
 	} else {
 		for (i = 0; i < 7; i++) {
 			cyrix_get_arr(i, &lbase, &lsize, &ltype);
 			if (lsize == 0)
 				return i;
 		}
-		/* ARR0-ARR6 isn't free, try ARR7 but its size must be at least 256K */
+		/*
+		 * ARR0-ARR6 isn't free
+		 * try ARR7 but its size must be at least 256K
+		 */
 		cyrix_get_arr(i, &lbase, &lsize, &ltype);
 		if ((lsize == 0) && (size >= 0x40))
 			return i;
@@ -122,21 +130,22 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 	return -ENOSPC;
 }
 
-static u32 cr4 = 0;
-static u32 ccr3;
+static u32 cr4, ccr3;
 
 static void prepare_set(void)
 {
 	u32 cr0;
 
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
+	if (cpu_has_pge) {
 		cr4 = read_cr4();
 		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
-	/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
-	    a side-effect  */
+	/*
+	 * Disable and flush caches.
+	 * Note that wbinvd flushes the TLBs as a side-effect
+	 */
 	cr0 = read_cr0() | X86_CR0_CD;
 	wbinvd();
 	write_cr0(cr0);
@@ -147,22 +156,21 @@ static void prepare_set(void)
 
 	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
-
 }
 
 static void post_set(void)
 {
-	/*  Flush caches and TLBs  */
+	/* Flush caches and TLBs */
 	wbinvd();
 
 	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, ccr3);
-		
-	/*  Enable caches  */
+
+	/* Enable caches */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	/* Restore value of CR4 */
+	if (cpu_has_pge)
 		write_cr4(cr4);
 }
 
@@ -178,7 +186,8 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 		size >>= 6;
 
 	size &= 0x7fff;		/* make sure arr_size <= 14 */
-	for (arr_size = 0; size; arr_size++, size >>= 1) ;
+	for (arr_size = 0; size; arr_size++, size >>= 1)
+		;
 
 	if (reg < 7) {
 		switch (type) {
@@ -215,18 +224,18 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 	prepare_set();
 
 	base <<= PAGE_SHIFT;
-	setCx86(arr, ((unsigned char *) &base)[3]);
-	setCx86(arr + 1, ((unsigned char *) &base)[2]);
-	setCx86(arr + 2, (((unsigned char *) &base)[1]) | arr_size);
+	setCx86(arr + 0,  ((unsigned char *)&base)[3]);
+	setCx86(arr + 1,  ((unsigned char *)&base)[2]);
+	setCx86(arr + 2, (((unsigned char *)&base)[1]) | arr_size);
 	setCx86(CX86_RCR_BASE + reg, arr_type);
 
 	post_set();
 }
 
 typedef struct {
-	unsigned long base;
-	unsigned long size;
-	mtrr_type type;
+	unsigned long	base;
+	unsigned long	size;
+	mtrr_type	type;
 } arr_state_t;
 
 static arr_state_t arr_state[8] = {
@@ -247,16 +256,17 @@ static void cyrix_set_all(void)
 		setCx86(CX86_CCR0 + i, ccr_state[i]);
 	for (; i < 7; i++)
 		setCx86(CX86_CCR4 + i, ccr_state[i]);
-	for (i = 0; i < 8; i++)
-		cyrix_set_arr(i, arr_state[i].base, 
+
+	for (i = 0; i < 8; i++) {
+		cyrix_set_arr(i, arr_state[i].base,
 			      arr_state[i].size, arr_state[i].type);
+	}
 
 	post_set();
 }
 
 static struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
-//	.init              = cyrix_arr_init,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
 	.get               = cyrix_get_arr,
@@ -270,5 +280,3 @@ int __init cyrix_init_mtrr(void)
 	set_mtrr_ops(&cyrix_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(cyrix_init_mtrr);
