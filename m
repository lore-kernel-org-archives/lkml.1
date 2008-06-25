Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbYFYQaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYFYQaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbYFYQ2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:28:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46197 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759134AbYFYQ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:28:07 -0400
Date: Wed, 25 Jun 2008 19:26:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/page_alloc.c: cleanups
Message-ID: <20080625162602.GL10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global variables static:
  - required_kernelcore
  - zone_movable_pfn[]
- make the following needlessly global functions static:
  - move_freepages()
  - move_freepages_block()
  - setup_pageset()
  - find_usable_zone_for_movable()
  - adjust_zone_range_for_zone_movable()
  - __absent_pages_in_range()
  - find_min_pfn_for_node()
  - find_zone_movable_pfns_for_nodes()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 mm/page_alloc.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -152,9 +152,9 @@ static unsigned long __meminitdata dma_reserve;
   static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
-  unsigned long __initdata required_kernelcore;
+  static unsigned long __initdata required_kernelcore;
   static unsigned long __initdata required_movablecore;
-  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
   int movable_zone;
@@ -697,9 +697,9 @@ static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
-int move_freepages(struct zone *zone,
-			struct page *start_page, struct page *end_page,
-			int migratetype)
+static int move_freepages(struct zone *zone,
+			  struct page *start_page, struct page *end_page,
+			  int migratetype)
 {
 	struct page *page;
 	unsigned long order;
@@ -738,7 +738,8 @@ int move_freepages(struct zone *zone,
 	return pages_moved;
 }
 
-int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
+static int move_freepages_block(struct zone *zone, struct page *page,
+				int migratetype)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
@@ -2604,7 +2600,7 @@ static int zone_batchsize(struct zone *zone)
 	return batch;
 }
 
-inline void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
 
@@ -3033,7 +3029,7 @@ void __meminit get_pfn_range_for_nid(unsigned int nid,
  * assumption is made that zones within a node are ordered in monotonic
  * increasing memory addresses so that the "highest" populated zone is used
  */
-void __init find_usable_zone_for_movable(void)
+static void __init find_usable_zone_for_movable(void)
 {
 	int zone_index;
 	for (zone_index = MAX_NR_ZONES - 1; zone_index >= 0; zone_index--) {
@@ -3059,7 +3055,7 @@ void __init find_usable_zone_for_movable(void)
  * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
  * zones within a node are in order of monotonic increases memory addresses
  */
-void __meminit adjust_zone_range_for_zone_movable(int nid,
+static void __meminit adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
@@ -3120,7 +3116,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __meminit __absent_pages_in_range(int nid,
+static unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -3604,7 +3600,7 @@ static void __init sort_node_map(void)
 }
 
 /* Find the lowest pfn for a node */
-unsigned long __init find_min_pfn_for_node(unsigned long nid)
+static unsigned long __init find_min_pfn_for_node(unsigned long nid)
 {
 	int i;
 	unsigned long min_pfn = ULONG_MAX;
@@ -3676,7 +3672,7 @@ static unsigned long __init early_calculate_totalpages(void)
  * memory. When they don't, some nodes will have more kernelcore than
  * others
  */
-void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
+static void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
 {
 	int i, nid;
 	unsigned long usable_startpfn;

