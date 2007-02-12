Return-Path: <linux-kernel-owner+w=401wt.eu-S964979AbXBLQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbXBLQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXBLQ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:17 -0500
Received: from ns1.suse.de ([195.135.220.2]:47943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964990AbXBLQvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:37 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: "Bob Picco" <bob.picco@hp.com>, Andi Kleen <ak@muc.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [4/29] x86_64: clean up sparsemem memory_present call
Message-Id: <20070212165123.DDBA613F81@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Bob Picco" <bob.picco@hp.com>

Eliminate arch specific memory_present call x86_64 NUMA by utilizing
sparse_memory_present_with_active_regions.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -460,20 +460,6 @@ unsigned long __init numa_free_all_bootm
 	return pages;
 } 
 
-#ifdef CONFIG_SPARSEMEM
-static void __init arch_sparse_init(void)
-{
-	int i;
-
-	for_each_online_node(i)
-		memory_present(i, node_start_pfn(i), node_end_pfn(i));
-
-	sparse_init();
-}
-#else
-#define arch_sparse_init() do {} while (0)
-#endif
-
 void __init paging_init(void)
 { 
 	int i;
@@ -483,7 +469,8 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
-	arch_sparse_init();
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
+	sparse_init();
 
 	for_each_online_node(i) {
 		setup_node_zones(i); 
