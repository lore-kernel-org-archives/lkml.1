Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXFAE02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXFAE02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXFAE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:26:20 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60575 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbXFAE0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:26:20 -0400
Date: Fri, 1 Jun 2007 13:25:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparsemem: Shut up unused symbol compiler warnings.
Message-ID: <20070601042515.GA8628@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__kmalloc_section_memmap()/__kfree_section_memmap() and friends are only
used by the memory hotplug code. Move these in to the existing
CONFIG_MEMORY_HOTPLUG block.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/sparse.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 1302f83..35f739a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -229,6 +229,7 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	return NULL;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
 	struct page *page, *ret;
@@ -269,27 +270,6 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 }
 
 /*
- * Allocate the accumulated non-linear sections, allocate a mem_map
- * for each and record the physical to section mapping.
- */
-void __init sparse_init(void)
-{
-	unsigned long pnum;
-	struct page *map;
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
-			continue;
-
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
-			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
-	}
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
@@ -329,3 +309,23 @@ out:
 	return ret;
 }
 #endif
+
+/*
+ * Allocate the accumulated non-linear sections, allocate a mem_map
+ * for each and record the physical to section mapping.
+ */
+void __init sparse_init(void)
+{
+	unsigned long pnum;
+	struct page *map;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!valid_section_nr(pnum))
+			continue;
+
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+	}
+}
