Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZGDKH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZGDKH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZGDKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:07:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:47366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZGDKHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:07:20 -0400
Date: Sat, 4 Jul 2009 10:06:36 GMT
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
Subject: [tip:x86/cleanups] x86: Clean up mtrr/amd.c:
Message-ID: <tip-42204455f160dab0c47f19e1be23f5c927af2d17@git.kernel.org>
Git-Commit-ID: 42204455f160dab0c47f19e1be23f5c927af2d17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42204455f160dab0c47f19e1be23f5c927af2d17
Gitweb:     http://git.kernel.org/tip/42204455f160dab0c47f19e1be23f5c927af2d17
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:50:00 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:10:45 +0200

x86: Clean up mtrr/amd.c:

Fix trivial style problems :

  ERROR: trailing whitespace
  WARNING: line over 80 characters
  ERROR: do not use C99 // comments

arch/x86/kernel/cpu/mtrr/amd.o:

   text	   data	    bss	    dec	    hex	filename
    501	     32	      0	    533	    215	amd.o.before
    501	     32	      0	    533	    215	amd.o.after

md5:
   62f795eb840ee2d17b03df89e789e76c  amd.o.before.asm
   62f795eb840ee2d17b03df89e789e76c  amd.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ Also restructured comments to be standard, removed stray return,
  converted function description to DocBook style, etc. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/amd.c |   97 +++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index ee2331b..33af141 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -7,15 +7,15 @@
 
 static void
 amd_get_mtrr(unsigned int reg, unsigned long *base,
-	     unsigned long *size, mtrr_type * type)
+	     unsigned long *size, mtrr_type *type)
 {
 	unsigned long low, high;
 
 	rdmsr(MSR_K6_UWCCR, low, high);
-	/*  Upper dword is region 1, lower is region 0  */
+	/* Upper dword is region 1, lower is region 0 */
 	if (reg == 1)
 		low = high;
-	/*  The base masks off on the right alignment  */
+	/* The base masks off on the right alignment */
 	*base = (low & 0xFFFE0000) >> PAGE_SHIFT;
 	*type = 0;
 	if (low & 1)
@@ -27,74 +27,81 @@ amd_get_mtrr(unsigned int reg, unsigned long *base,
 		return;
 	}
 	/*
-	 *  This needs a little explaining. The size is stored as an
-	 *  inverted mask of bits of 128K granularity 15 bits long offset
-	 *  2 bits
+	 * This needs a little explaining. The size is stored as an
+	 * inverted mask of bits of 128K granularity 15 bits long offset
+	 * 2 bits.
 	 *
-	 *  So to get a size we do invert the mask and add 1 to the lowest
-	 *  mask bit (4 as its 2 bits in). This gives us a size we then shift
-	 *  to turn into 128K blocks
+	 * So to get a size we do invert the mask and add 1 to the lowest
+	 * mask bit (4 as its 2 bits in). This gives us a size we then shift
+	 * to turn into 128K blocks.
 	 *
-	 *  eg              111 1111 1111 1100      is 512K
+	 * eg              111 1111 1111 1100      is 512K
 	 *
-	 *  invert          000 0000 0000 0011
-	 *  +1              000 0000 0000 0100
-	 *  *128K   ...
+	 * invert          000 0000 0000 0011
+	 * +1              000 0000 0000 0100
+	 * *128K   ...
 	 */
 	low = (~low) & 0x1FFFC;
 	*size = (low + 4) << (15 - PAGE_SHIFT);
-	return;
 }
 
-static void amd_set_mtrr(unsigned int reg, unsigned long base,
-			 unsigned long size, mtrr_type type)
-/*  [SUMMARY] Set variable MTRR register on the local CPU.
-    <reg> The register to set.
-    <base> The base address of the region.
-    <size> The size of the region. If this is 0 the region is disabled.
-    <type> The type of the region.
-    [RETURNS] Nothing.
-*/
+/**
+ * amd_set_mtrr - Set variable MTRR register on the local CPU.
+ *
+ * @reg The register to set.
+ * @base The base address of the region.
+ * @size The size of the region. If this is 0 the region is disabled.
+ * @type The type of the region.
+ *
+ * Returns nothing.
+ */
+static void
+amd_set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
 	u32 regs[2];
 
 	/*
-	 *  Low is MTRR0 , High MTRR 1
+	 * Low is MTRR0, High MTRR 1
 	 */
 	rdmsr(MSR_K6_UWCCR, regs[0], regs[1]);
 	/*
-	 *  Blank to disable
+	 * Blank to disable
 	 */
-	if (size == 0)
+	if (size == 0) {
 		regs[reg] = 0;
-	else
-		/* Set the register to the base, the type (off by one) and an
-		   inverted bitmask of the size The size is the only odd
-		   bit. We are fed say 512K We invert this and we get 111 1111
-		   1111 1011 but if you subtract one and invert you get the   
-		   desired 111 1111 1111 1100 mask
-
-		   But ~(x - 1) == ~x + 1 == -x. Two's complement rocks!  */
+	} else {
+		/*
+		 * Set the register to the base, the type (off by one) and an
+		 * inverted bitmask of the size The size is the only odd
+		 * bit. We are fed say 512K We invert this and we get 111 1111
+		 * 1111 1011 but if you subtract one and invert you get the
+		 * desired 111 1111 1111 1100 mask
+		 *
+		 *  But ~(x - 1) == ~x + 1 == -x. Two's complement rocks!
+		 */
 		regs[reg] = (-size >> (15 - PAGE_SHIFT) & 0x0001FFFC)
 		    | (base << PAGE_SHIFT) | (type + 1);
+	}
 
 	/*
-	 *  The writeback rule is quite specific. See the manual. Its
-	 *  disable local interrupts, write back the cache, set the mtrr
+	 * The writeback rule is quite specific. See the manual. Its
+	 * disable local interrupts, write back the cache, set the mtrr
 	 */
 	wbinvd();
 	wrmsr(MSR_K6_UWCCR, regs[0], regs[1]);
 }
 
-static int amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+static int
+amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 {
-	/* Apply the K6 block alignment and size rules
-	   In order
-	   o Uncached or gathering only
-	   o 128K or bigger block
-	   o Power of 2 block
-	   o base suitably aligned to the power
-	*/
+	/*
+	 * Apply the K6 block alignment and size rules
+	 * In order
+	 * o Uncached or gathering only
+	 * o 128K or bigger block
+	 * o Power of 2 block
+	 * o base suitably aligned to the power
+	 */
 	if (type > MTRR_TYPE_WRCOMB || size < (1 << (17 - PAGE_SHIFT))
 	    || (size & ~(size - 1)) - size || (base & (size - 1)))
 		return -EINVAL;
@@ -115,5 +122,3 @@ int __init amd_init_mtrr(void)
 	set_mtrr_ops(&amd_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(amd_mtrr_init);
