Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYDLFWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYDLFWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYDLFW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:22:28 -0400
Received: from ozlabs.org ([203.10.76.45]:48543 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYDLFW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:22:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18432.18107.29491.115996@cargo.ozlabs.ibm.com>
Date: Sat, 12 Apr 2008 15:20:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: davem@davemloft.net
Subject: [LMB][1/2] Fix some whitespace and other formatting issues, use pr_debug
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes no semantic changes.  It fixes the whitespace and formatting
a bit, gets rid of a local DBG macro and uses the equivalent pr_debug
instead, and restructures one while loop that had a function call and
assignment in the condition to be a bit more readable.  Some comments
about functions being called with relocation disabled were also removed
as they would just be confusing to most readers now that the code is
in lib/.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This goes on top of Dave Miller's "LMB: Add lmb_alloc_nid()" patch.

diff --git a/lib/lmb.c b/lib/lmb.c
index 549fbb3..265daf5 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -15,14 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/lmb.h>
 
-#undef DEBUG
-
-#ifdef DEBUG
-#define DBG(fmt...) LMB_DBG(fmt)
-#else
-#define DBG(fmt...)
-#endif
-
 #define LMB_ALLOC_ANYWHERE	0
 
 struct lmb lmb;
@@ -32,32 +24,32 @@ void lmb_dump_all(void)
 #ifdef DEBUG
 	unsigned long i;
 
-	DBG("lmb_dump_all:\n");
-	DBG("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
-	DBG("    memory.size		  = 0x%llx\n",
+	pr_debug("lmb_dump_all:\n");
+	pr_debug("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
+	pr_debug("    memory.size		  = 0x%llx\n",
 	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.memory.cnt ;i++) {
-		DBG("    memory.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    memory.region[0x%x].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.memory.region[i].base);
-		DBG("		      .size     = 0x%llx\n",
+		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.memory.region[i].size);
 	}
 
-	DBG("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
-	DBG("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
+	pr_debug("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
+	pr_debug("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
-		DBG("    reserved.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    reserved.region[0x%x].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.reserved.region[i].base);
-		DBG("		      .size     = 0x%llx\n",
+		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.reserved.region[i].size);
 	}
 #endif /* DEBUG */
 }
 
-static unsigned long __init lmb_addrs_overlap(u64 base1,
-		u64 size1, u64 base2, u64 size2)
+static unsigned long __init lmb_addrs_overlap(u64 base1, u64 size1,
+		u64 base2, u64 size2)
 {
-	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
+	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
 
 static long __init lmb_addrs_adjacent(u64 base1, u64 size1,
@@ -101,7 +93,6 @@ static void __init lmb_coalesce_regions(struct lmb_region *rgn,
 	lmb_remove_region(rgn, r2);
 }
 
-/* This routine called with relocation disabled. */
 void __init lmb_init(void)
 {
 	/* Create a dummy zero size LMB which will get coalesced away later.
@@ -117,7 +108,6 @@ void __init lmb_init(void)
 	lmb.reserved.cnt = 1;
 }
 
-/* This routine may be called with relocation disabled. */
 void __init lmb_analyze(void)
 {
 	int i;
@@ -128,7 +118,6 @@ void __init lmb_analyze(void)
 		lmb.memory.size += lmb.memory.region[i].size;
 }
 
-/* This routine called with relocation disabled. */
 static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 {
 	unsigned long coalesced = 0;
@@ -141,7 +130,7 @@ static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 	}
 
 	/* First try and coalesce this LMB with another. */
-	for (i=0; i < rgn->cnt; i++) {
+	for (i = 0; i < rgn->cnt; i++) {
 		u64 rgnbase = rgn->region[i].base;
 		u64 rgnsize = rgn->region[i].size;
 
@@ -149,21 +138,20 @@ static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 			/* Already have this region, so we're done */
 			return 0;
 
-		adjacent = lmb_addrs_adjacent(base,size,rgnbase,rgnsize);
-		if ( adjacent > 0 ) {
+		adjacent = lmb_addrs_adjacent(base, size, rgnbase, rgnsize);
+		if (adjacent > 0) {
 			rgn->region[i].base -= size;
 			rgn->region[i].size += size;
 			coalesced++;
 			break;
-		}
-		else if ( adjacent < 0 ) {
+		} else if (adjacent < 0) {
 			rgn->region[i].size += size;
 			coalesced++;
 			break;
 		}
 	}
 
-	if ((i < rgn->cnt-1) && lmb_regions_adjacent(rgn, i, i+1) ) {
+	if ((i < rgn->cnt - 1) && lmb_regions_adjacent(rgn, i, i+1)) {
 		lmb_coalesce_regions(rgn, i, i+1);
 		coalesced++;
 	}
@@ -174,7 +162,7 @@ static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 		return -1;
 
 	/* Couldn't coalesce the LMB, so add it to the sorted table. */
-	for (i = rgn->cnt-1; i >= 0; i--) {
+	for (i = rgn->cnt - 1; i >= 0; i--) {
 		if (base < rgn->region[i].base) {
 			rgn->region[i+1].base = rgn->region[i].base;
 			rgn->region[i+1].size = rgn->region[i].size;
@@ -194,10 +182,9 @@ static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 	return 0;
 }
 
-/* This routine may be called with relocation disabled. */
 long __init lmb_add(u64 base, u64 size)
 {
-	struct lmb_region *_rgn = &(lmb.memory);
+	struct lmb_region *_rgn = &lmb.memory;
 
 	/* On pSeries LPAR systems, the first LMB is our RMO region. */
 	if (base == 0)
@@ -209,24 +196,22 @@ long __init lmb_add(u64 base, u64 size)
 
 long __init lmb_reserve(u64 base, u64 size)
 {
-	struct lmb_region *_rgn = &(lmb.reserved);
+	struct lmb_region *_rgn = &lmb.reserved;
 
 	BUG_ON(0 == size);
 
 	return lmb_add_region(_rgn, base, size);
 }
 
-long __init lmb_overlaps_region(struct lmb_region *rgn, u64 base,
-				u64 size)
+long __init lmb_overlaps_region(struct lmb_region *rgn, u64 base, u64 size)
 {
 	unsigned long i;
 
-	for (i=0; i < rgn->cnt; i++) {
+	for (i = 0; i < rgn->cnt; i++) {
 		u64 rgnbase = rgn->region[i].base;
 		u64 rgnsize = rgn->region[i].size;
-		if ( lmb_addrs_overlap(base,size,rgnbase,rgnsize) ) {
+		if (lmb_addrs_overlap(base, size, rgnbase, rgnsize))
 			break;
-		}
 	}
 
 	return (i < rgn->cnt) ? i : -1;
@@ -337,7 +322,7 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 	if (max_addr == LMB_ALLOC_ANYWHERE)
 		max_addr = LMB_REAL_LIMIT;
 
-	for (i = lmb.memory.cnt-1; i >= 0; i--) {
+	for (i = lmb.memory.cnt - 1; i >= 0; i--) {
 		u64 lmbbase = lmb.memory.region[i].base;
 		u64 lmbsize = lmb.memory.region[i].size;
 
@@ -349,10 +334,13 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 		} else
 			continue;
 
-		while ((lmbbase <= base) &&
-		       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0) )
+		while (lmbbase <= base) {
+			j = lmb_overlaps_region(&lmb.reserved, base, size);
+			if (j < 0)
+				break;
 			base = lmb_align_down(lmb.reserved.region[j].base - size,
 					      align);
+		}
 
 		if ((base != 0) && (lmbbase <= base))
 			break;
@@ -387,7 +375,7 @@ void __init lmb_enforce_memory_limit(u64 memory_limit)
 	u64 limit;
 	struct lmb_property *p;
 
-	if (! memory_limit)
+	if (!memory_limit)
 		return;
 
 	/* Truncate the lmb regions to satisfy the memory limit. */
