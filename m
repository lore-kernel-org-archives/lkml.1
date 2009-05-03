Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZECMP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZECMP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZECMPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:15:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43866 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZECMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:15:10 -0400
Date: Sun, 3 May 2009 15:15:10 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: npiggin@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SLQB: Coding style cleanups
Message-ID: <Pine.LNX.4.64.0905031514330.32397@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch cleans up SQLB to make the code checkpatch clean.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slqb.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index f538f2c..44a91c0 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -59,7 +59,7 @@ static inline void struct_slqb_page_wrong_size(void)
 /*
  * slqb_min_order: minimum allocation order for slabs
  */
-static int slqb_min_order = 0;
+static int slqb_min_order;
 
 /*
  * slqb_min_objects: minimum number of objects per slab. Increasing this
@@ -193,12 +193,12 @@ static inline void __free_slqb_pages(struct slqb_page *page, unsigned int order)
 #ifdef CONFIG_SLQB_DEBUG
 static inline int slab_debug(struct kmem_cache *s)
 {
-	return (s->flags &
+	return s->flags &
 			(SLAB_DEBUG_FREE |
 			 SLAB_RED_ZONE |
 			 SLAB_POISON |
 			 SLAB_STORE_USER |
-			 SLAB_TRACE));
+			 SLAB_TRACE);
 }
 static inline int slab_poison(struct kmem_cache *s)
 {
@@ -945,7 +945,7 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	return flags;
 }
 
-static const int slqb_debug = 0;
+static const int slqb_debug;
 #endif
 
 /*
@@ -1954,8 +1954,11 @@ static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 				int cpu)
 {
 	struct kmem_cache_cpu *c;
+	int node;
+
+	node = cpu_to_node(cpu);
 
-	c = kmem_cache_alloc_node(&kmem_cpu_cache, GFP_KERNEL, cpu_to_node(cpu));
+	c = kmem_cache_alloc_node(&kmem_cpu_cache, GFP_KERNEL, node);
 	if (!c)
 		return NULL;
 
@@ -2292,7 +2295,7 @@ error_lock:
 	up_write(&slqb_lock);
 error:
 	if (flags & SLAB_PANIC)
-		panic("kmem_cache_create(): failed to create slab `%s'\n", name);
+		panic("%s: failed to create slab `%s'\n", __func__, name);
 	return 0;
 }
 
@@ -3006,7 +3009,7 @@ static int kmem_cache_create_ok(const char *name, size_t size,
 
 		if (!strcmp(tmp->name, name)) {
 			printk(KERN_ERR
-			       "kmem_cache_create(): duplicate cache %s\n", name);
+			       "SLAB: duplicate cache %s\n", name);
 			dump_stack();
 			up_read(&slqb_lock);
 
@@ -3042,7 +3045,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 
 err:
 	if (flags & SLAB_PANIC)
-		panic("kmem_cache_create(): failed to create slab `%s'\n", name);
+		panic("%s: failed to create slab `%s'\n", __func__, name);
 
 	return NULL;
 }
@@ -3676,7 +3679,7 @@ static struct kset_uevent_ops slab_uevent_ops = {
 
 static struct kset *slab_kset;
 
-static int sysfs_available __read_mostly = 0;
+static int sysfs_available __read_mostly;
 
 static int sysfs_slab_add(struct kmem_cache *s)
 {
-- 
1.5.6.3

