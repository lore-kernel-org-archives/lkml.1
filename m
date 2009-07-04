Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZGDCbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZGDCbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbZGDCbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:31:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:50453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838AbZGDCbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:31:19 -0400
Subject: [PATCH 3/9 -tip] x86: mtrr/cleanup.c fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674044.2642.7.camel@ht.satnam>
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
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:51:32 +0530
Message-Id: <1246674092.2642.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix trivial style problems:

  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
  WARNING: Use #include <linux/kvm_para.h> instead of <asm/kvm_para.h>
  WARNING: consider using strict_strtoul in preference to simple_strtoul

nr_mtrr_spare_reg should be unsigned long

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 1d584a1..9cbf207 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -24,13 +24,13 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/sort.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_para.h>
 
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
 #include "mtrr.h"
 
 /* should be related to MTRR_VAR_RANGES nums */
@@ -59,7 +59,7 @@ add_range(struct res_range *range, int nr_range, unsigned long start,
 
 static int __init
 add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end)
+		     unsigned long end)
 {
 	int i;
 
@@ -577,13 +577,13 @@ static int __init parse_mtrr_gran_size_opt(char *p)
 }
 early_param("mtrr_gran_size", parse_mtrr_gran_size_opt);
 
-static int nr_mtrr_spare_reg __initdata =
+static unsigned long nr_mtrr_spare_reg __initdata =
 				 CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT;
 
 static int __init parse_mtrr_spare_reg(char *arg)
 {
 	if (arg)
-		nr_mtrr_spare_reg = simple_strtoul(arg, NULL, 0);
+		return strict_strtoul(arg, 0, &nr_mtrr_spare_reg);
 	return 0;
 }
 
@@ -661,7 +661,7 @@ static void __init print_out_mtrr_range_state(void)
 		start_base = to_size_factor(start_base, &start_factor),
 		type = range_state[i].type;
 
-		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
+		pr_debug("reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
 			i, start_base, start_factor,
 			size_base, size_factor,
 			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
@@ -699,7 +699,7 @@ static int __init mtrr_need_cleanup(void)
 
 	/* check if we only had WB and UC */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
-		num_var_ranges - num[MTRR_NUM_TYPES])
+	    num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
 
 	return 1;
@@ -708,8 +708,7 @@ static int __init mtrr_need_cleanup(void)
 static unsigned long __initdata range_sums;
 static void __init mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
 					 unsigned long extra_remove_base,
-					 unsigned long extra_remove_size,
-					 int i)
+					 unsigned long extra_remove_size, int i)
 {
 	int num_reg;
 	static struct res_range range_new[RANGE_NUM];
@@ -1098,4 +1097,3 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	return 0;
 }
-
-- 
1.6.0.6



