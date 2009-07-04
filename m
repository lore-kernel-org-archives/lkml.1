Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZGDCbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZGDCbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbZGDCbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:31:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:50465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069AbZGDCbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:31:40 -0400
Subject: [PATCH 4/9 -tip] x86: mtrr/cyrix.c fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674092.2642.8.camel@ht.satnam>
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
	 <1246674092.2642.8.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:52:08 +0530
Message-Id: <1246674128.2642.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix trivial style problems :

  WARNING: Use #include <linux/io.h> instead of <asm/io.h>
  WARNING: line over 80 characters
  ERROR: do not initialise statics to 0 or NULL
  ERROR: space prohibited after that open parenthesis '(' X 2
  ERROR: space prohibited before that close parenthesis ')' X 2
  ERROR: trailing whitespace X 2
  ERROR: trailing statements should be on next line
  ERROR: do not use C99 // comments X 2

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cyrix.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index ff14c32..f01c723 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -1,8 +1,8 @@
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/mm.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
-#include <asm/io.h>
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
 #include "mtrr.h"
@@ -114,7 +114,10 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
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
@@ -122,21 +125,22 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
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
@@ -157,12 +161,12 @@ static void post_set(void)
 
 	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, ccr3);
-		
+
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
 
 	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	if (cpu_has_pge)
 		write_cr4(cr4);
 }
 
@@ -178,7 +182,8 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 		size >>= 6;
 
 	size &= 0x7fff;		/* make sure arr_size <= 14 */
-	for (arr_size = 0; size; arr_size++, size >>= 1) ;
+	for (arr_size = 0; size; arr_size++, size >>= 1)
+		;
 
 	if (reg < 7) {
 		switch (type) {
@@ -248,7 +253,7 @@ static void cyrix_set_all(void)
 	for (; i < 7; i++)
 		setCx86(CX86_CCR4 + i, ccr_state[i]);
 	for (i = 0; i < 8; i++)
-		cyrix_set_arr(i, arr_state[i].base, 
+		cyrix_set_arr(i, arr_state[i].base,
 			      arr_state[i].size, arr_state[i].type);
 
 	post_set();
@@ -256,7 +261,6 @@ static void cyrix_set_all(void)
 
 static struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
-//	.init              = cyrix_arr_init,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
 	.get               = cyrix_get_arr,
@@ -270,5 +274,3 @@ int __init cyrix_init_mtrr(void)
 	set_mtrr_ops(&cyrix_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(cyrix_init_mtrr);
-- 
1.6.0.6



