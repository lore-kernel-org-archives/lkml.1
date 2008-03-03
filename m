Return-Path: <linux-kernel-owner+w=401wt.eu-S1761231AbYCCBiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbYCCBiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYCCBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:37:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:65472 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYCCBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l+6Os9ivZNra+cJD0RFPCLLtgk+Ds53Z8PZlEdzMVd7PWAwOIBxUmZvx0xjNUVgXZ9A+RNe8BbknECJkFaBNqSoJM69g9qMc9Xvzr5Rgx+2hUduZGkP4eqBWIsIqB9XwN1u++aWL6AWEA44VIaWFuYcDlBRbvL4J+xJ/FooW/wU=
Subject: [RFC PATCH 1/5] mm: remove remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 17:37:55 -0800
Message-Id: <1204508275.3266.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/slab.c   |    4 ++--
 mm/sparse.c |    4 ++--
 mm/vmscan.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 473e6c2..161c3e5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -862,7 +862,7 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }
 
-#define slab_error(cachep, msg) __slab_error(__FUNCTION__, cachep, msg)
+#define slab_error(cachep, msg) __slab_error(__func__, cachep, msg)
 
 static void __slab_error(const char *function, struct kmem_cache *cachep,
 			char *msg)
@@ -2158,7 +2158,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	 */
 	if (!name || in_interrupt() || (size < BYTES_PER_WORD) ||
 	    size > KMALLOC_MAX_SIZE) {
-		printk(KERN_ERR "%s: Early error in slab %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: Early error in slab %s\n", __func__,
 				name);
 		BUG();
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index f6a43c0..a61a107 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -250,7 +250,7 @@ static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: allocation failed\n", __func__);
 	return NULL;
 }
 
@@ -280,7 +280,7 @@ struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 		return map;
 
 	printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __FUNCTION__);
+			"some memory will not be available.\n", __func__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a26dabd..dd54ee6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -198,7 +198,7 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
 			printk(KERN_ERR "%s: nr=%ld\n",
-					__FUNCTION__, shrinker->nr);
+					__func__, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
@@ -346,7 +346,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 		if (PagePrivate(page)) {
 			if (try_to_free_buffers(page)) {
 				ClearPageDirty(page);
-				printk("%s: orphaned page\n", __FUNCTION__);
+				printk("%s: orphaned page\n", __func__);
 				return PAGE_CLEAN;
 			}
 		}
-- 
1.5.4.3.409.g8811


