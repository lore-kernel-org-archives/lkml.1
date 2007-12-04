Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXLDUnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXLDUnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXLDUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:42:39 -0500
Received: from mga07.intel.com ([143.182.124.22]:10860 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbXLDUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,250,1194249600"; 
   d="scan'208";a="332758443"
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/7] dmapool: Fix style problems
Date: Tue,  4 Dec 2007 13:26:03 -0800
Message-Id: <11968035681680-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11968035682899-git-send-email-matthew@wil.cx>
References: <20071204170915.GE9405@parisc-linux.org> <11968035682899-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run Lindent and fix all issues reported by checkpatch.pl

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |  288 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 142 insertions(+), 146 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index b5034dc..92e886d 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -15,32 +15,32 @@
  * This should probably be sharing the guts of the slab allocator.
  */
 
-struct dma_pool {	/* the pool */
-	struct list_head	page_list;
-	spinlock_t		lock;
-	size_t			blocks_per_page;
-	size_t			size;
-	struct device		*dev;
-	size_t			allocation;
-	char			name [32];
-	wait_queue_head_t	waitq;
-	struct list_head	pools;
+struct dma_pool {		/* the pool */
+	struct list_head page_list;
+	spinlock_t lock;
+	size_t blocks_per_page;
+	size_t size;
+	struct device *dev;
+	size_t allocation;
+	char name[32];
+	wait_queue_head_t waitq;
+	struct list_head pools;
 };
 
-struct dma_page {	/* cacheable header for 'allocation' bytes */
-	struct list_head	page_list;
-	void			*vaddr;
-	dma_addr_t		dma;
-	unsigned		in_use;
-	unsigned long		bitmap [0];
+struct dma_page {		/* cacheable header for 'allocation' bytes */
+	struct list_head page_list;
+	void *vaddr;
+	dma_addr_t dma;
+	unsigned in_use;
+	unsigned long bitmap[0];
 };
 
 #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
 
-static DEFINE_MUTEX (pools_lock);
+static DEFINE_MUTEX(pools_lock);
 
 static ssize_t
-show_pools (struct device *dev, struct device_attribute *attr, char *buf)
+show_pools(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	unsigned temp;
 	unsigned size;
@@ -67,9 +67,9 @@ show_pools (struct device *dev, struct device_attribute *attr, char *buf)
 
 		/* per-pool info, no real statistics yet */
 		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
-				pool->name,
-				blocks, pages * pool->blocks_per_page,
-				pool->size, pages);
+				 pool->name,
+				 blocks, pages * pool->blocks_per_page,
+				 pool->size, pages);
 		size -= temp;
 		next += temp;
 	}
@@ -77,7 +77,8 @@ show_pools (struct device *dev, struct device_attribute *attr, char *buf)
 
 	return PAGE_SIZE - size;
 }
-static DEVICE_ATTR (pools, S_IRUGO, show_pools, NULL);
+
+static DEVICE_ATTR(pools, S_IRUGO, show_pools, NULL);
 
 /**
  * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
@@ -100,11 +101,10 @@ static DEVICE_ATTR (pools, S_IRUGO, show_pools, NULL);
  * addressing restrictions on individual DMA transfers, such as not crossing
  * boundaries of 4KBytes.
  */
-struct dma_pool *
-dma_pool_create (const char *name, struct device *dev,
-	size_t size, size_t align, size_t allocation)
+struct dma_pool *dma_pool_create(const char *name, struct device *dev,
+				 size_t size, size_t align, size_t allocation)
 {
-	struct dma_pool		*retval;
+	struct dma_pool *retval;
 
 	if (align == 0)
 		align = 1;
@@ -122,81 +122,79 @@ dma_pool_create (const char *name, struct device *dev,
 			allocation = size;
 		else
 			allocation = PAGE_SIZE;
-		// FIXME: round up for less fragmentation
+		/* FIXME: round up for less fragmentation */
 	} else if (allocation < size)
 		return NULL;
 
-	if (!(retval = kmalloc_node (sizeof *retval, GFP_KERNEL, dev_to_node(dev))))
+	if (!
+	    (retval =
+	     kmalloc_node(sizeof *retval, GFP_KERNEL, dev_to_node(dev))))
 		return retval;
 
-	strlcpy (retval->name, name, sizeof retval->name);
+	strlcpy(retval->name, name, sizeof retval->name);
 
 	retval->dev = dev;
 
-	INIT_LIST_HEAD (&retval->page_list);
-	spin_lock_init (&retval->lock);
+	INIT_LIST_HEAD(&retval->page_list);
+	spin_lock_init(&retval->lock);
 	retval->size = size;
 	retval->allocation = allocation;
 	retval->blocks_per_page = allocation / size;
-	init_waitqueue_head (&retval->waitq);
+	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
 		int ret;
 
 		mutex_lock(&pools_lock);
-		if (list_empty (&dev->dma_pools))
-			ret = device_create_file (dev, &dev_attr_pools);
+		if (list_empty(&dev->dma_pools))
+			ret = device_create_file(dev, &dev_attr_pools);
 		else
 			ret = 0;
 		/* note:  not currently insisting "name" be unique */
 		if (!ret)
-			list_add (&retval->pools, &dev->dma_pools);
+			list_add(&retval->pools, &dev->dma_pools);
 		else {
 			kfree(retval);
 			retval = NULL;
 		}
 		mutex_unlock(&pools_lock);
 	} else
-		INIT_LIST_HEAD (&retval->pools);
+		INIT_LIST_HEAD(&retval->pools);
 
 	return retval;
 }
+EXPORT_SYMBOL(dma_pool_create);
 
-
-static struct dma_page *
-pool_alloc_page (struct dma_pool *pool, gfp_t mem_flags)
+static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 {
-	struct dma_page	*page;
-	int		mapsize;
+	struct dma_page *page;
+	int mapsize;
 
 	mapsize = pool->blocks_per_page;
 	mapsize = (mapsize + BITS_PER_LONG - 1) / BITS_PER_LONG;
-	mapsize *= sizeof (long);
+	mapsize *= sizeof(long);
 
 	page = kmalloc(mapsize + sizeof *page, mem_flags);
 	if (!page)
 		return NULL;
-	page->vaddr = dma_alloc_coherent (pool->dev,
-					    pool->allocation,
-					    &page->dma,
-					    mem_flags);
+	page->vaddr = dma_alloc_coherent(pool->dev,
+					 pool->allocation,
+					 &page->dma, mem_flags);
 	if (page->vaddr) {
-		memset (page->bitmap, 0xff, mapsize);	// bit set == free
+		memset(page->bitmap, 0xff, mapsize);	/* bit set == free */
 #ifdef	CONFIG_DEBUG_SLAB
-		memset (page->vaddr, POOL_POISON_FREED, pool->allocation);
+		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
-		list_add (&page->page_list, &pool->page_list);
+		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
 	} else {
-		kfree (page);
+		kfree(page);
 		page = NULL;
 	}
 	return page;
 }
 
-
-static inline int
-is_page_busy (int blocks, unsigned long *bitmap)
+static inline int is_page_busy(int blocks, unsigned long *bitmap)
 {
 	while (blocks > 0) {
 		if (*bitmap++ != ~0UL)
@@ -206,20 +204,18 @@ is_page_busy (int blocks, unsigned long *bitmap)
 	return 0;
 }
 
-static void
-pool_free_page (struct dma_pool *pool, struct dma_page *page)
+static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
 {
-	dma_addr_t	dma = page->dma;
+	dma_addr_t dma = page->dma;
 
 #ifdef	CONFIG_DEBUG_SLAB
-	memset (page->vaddr, POOL_POISON_FREED, pool->allocation);
+	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
-	dma_free_coherent (pool->dev, pool->allocation, page->vaddr, dma);
-	list_del (&page->page_list);
-	kfree (page);
+	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
+	list_del(&page->page_list);
+	kfree(page);
 }
 
-
 /**
  * dma_pool_destroy - destroys a pool of dma memory blocks.
  * @pool: dma pool that will be destroyed
@@ -228,36 +224,37 @@ pool_free_page (struct dma_pool *pool, struct dma_page *page)
  * Caller guarantees that no more memory from the pool is in use,
  * and that nothing will try to use the pool after this call.
  */
-void
-dma_pool_destroy (struct dma_pool *pool)
+void dma_pool_destroy(struct dma_pool *pool)
 {
 	mutex_lock(&pools_lock);
-	list_del (&pool->pools);
-	if (pool->dev && list_empty (&pool->dev->dma_pools))
-		device_remove_file (pool->dev, &dev_attr_pools);
+	list_del(&pool->pools);
+	if (pool->dev && list_empty(&pool->dev->dma_pools))
+		device_remove_file(pool->dev, &dev_attr_pools);
 	mutex_unlock(&pools_lock);
 
-	while (!list_empty (&pool->page_list)) {
-		struct dma_page		*page;
-		page = list_entry (pool->page_list.next,
-				struct dma_page, page_list);
-		if (is_page_busy (pool->blocks_per_page, page->bitmap)) {
+	while (!list_empty(&pool->page_list)) {
+		struct dma_page *page;
+		page = list_entry(pool->page_list.next,
+				  struct dma_page, page_list);
+		if (is_page_busy(pool->blocks_per_page, page->bitmap)) {
 			if (pool->dev)
-				dev_err(pool->dev, "dma_pool_destroy %s, %p busy\n",
+				dev_err(pool->dev,
+					"dma_pool_destroy %s, %p busy\n",
 					pool->name, page->vaddr);
 			else
-				printk (KERN_ERR "dma_pool_destroy %s, %p busy\n",
-					pool->name, page->vaddr);
+				printk(KERN_ERR
+				       "dma_pool_destroy %s, %p busy\n",
+				       pool->name, page->vaddr);
 			/* leak the still-in-use consistent memory */
-			list_del (&page->page_list);
-			kfree (page);
+			list_del(&page->page_list);
+			kfree(page);
 		} else
-			pool_free_page (pool, page);
+			pool_free_page(pool, page);
 	}
 
-	kfree (pool);
+	kfree(pool);
 }
-
+EXPORT_SYMBOL(dma_pool_destroy);
 
 /**
  * dma_pool_alloc - get a block of consistent memory
@@ -269,73 +266,72 @@ dma_pool_destroy (struct dma_pool *pool)
  * and reports its dma address through the handle.
  * If such a memory block can't be allocated, null is returned.
  */
-void *
-dma_pool_alloc (struct dma_pool *pool, gfp_t mem_flags, dma_addr_t *handle)
+void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
+		     dma_addr_t *handle)
 {
-	unsigned long		flags;
-	struct dma_page		*page;
-	int			map, block;
-	size_t			offset;
-	void			*retval;
-
-restart:
-	spin_lock_irqsave (&pool->lock, flags);
+	unsigned long flags;
+	struct dma_page *page;
+	int map, block;
+	size_t offset;
+	void *retval;
+
+ restart:
+	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
-		int		i;
+		int i;
 		/* only cachable accesses here ... */
 		for (map = 0, i = 0;
-				i < pool->blocks_per_page;
-				i += BITS_PER_LONG, map++) {
-			if (page->bitmap [map] == 0)
+		     i < pool->blocks_per_page; i += BITS_PER_LONG, map++) {
+			if (page->bitmap[map] == 0)
 				continue;
-			block = ffz (~ page->bitmap [map]);
+			block = ffz(~page->bitmap[map]);
 			if ((i + block) < pool->blocks_per_page) {
-				clear_bit (block, &page->bitmap [map]);
+				clear_bit(block, &page->bitmap[map]);
 				offset = (BITS_PER_LONG * map) + block;
 				offset *= pool->size;
 				goto ready;
 			}
 		}
 	}
-	if (!(page = pool_alloc_page (pool, GFP_ATOMIC))) {
+	page = pool_alloc_page(pool, GFP_ATOMIC);
+	if (!page) {
 		if (mem_flags & __GFP_WAIT) {
-			DECLARE_WAITQUEUE (wait, current);
+			DECLARE_WAITQUEUE(wait, current);
 
 			__set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue (&pool->waitq, &wait);
-			spin_unlock_irqrestore (&pool->lock, flags);
+			add_wait_queue(&pool->waitq, &wait);
+			spin_unlock_irqrestore(&pool->lock, flags);
 
-			schedule_timeout (POOL_TIMEOUT_JIFFIES);
+			schedule_timeout(POOL_TIMEOUT_JIFFIES);
 
-			remove_wait_queue (&pool->waitq, &wait);
+			remove_wait_queue(&pool->waitq, &wait);
 			goto restart;
 		}
 		retval = NULL;
 		goto done;
 	}
 
-	clear_bit (0, &page->bitmap [0]);
+	clear_bit(0, &page->bitmap[0]);
 	offset = 0;
-ready:
+ ready:
 	page->in_use++;
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	CONFIG_DEBUG_SLAB
-	memset (retval, POOL_POISON_ALLOCATED, pool->size);
+	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
-done:
-	spin_unlock_irqrestore (&pool->lock, flags);
+ done:
+	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
+EXPORT_SYMBOL(dma_pool_alloc);
 
-
-static struct dma_page *
-pool_find_page (struct dma_pool *pool, dma_addr_t dma)
+static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 {
-	unsigned long		flags;
-	struct dma_page		*page;
+	unsigned long flags;
+	struct dma_page *page;
 
-	spin_lock_irqsave (&pool->lock, flags);
+	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (dma < page->dma)
 			continue;
@@ -343,12 +339,11 @@ pool_find_page (struct dma_pool *pool, dma_addr_t dma)
 			goto done;
 	}
 	page = NULL;
-done:
-	spin_unlock_irqrestore (&pool->lock, flags);
+ done:
+	spin_unlock_irqrestore(&pool->lock, flags);
 	return page;
 }
 
-
 /**
  * dma_pool_free - put block back into dma pool
  * @pool: the dma pool holding the block
@@ -358,20 +353,21 @@ done:
  * Caller promises neither device nor driver will again touch this block
  * unless it is first re-allocated.
  */
-void
-dma_pool_free (struct dma_pool *pool, void *vaddr, dma_addr_t dma)
+void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
-	struct dma_page		*page;
-	unsigned long		flags;
-	int			map, block;
+	struct dma_page *page;
+	unsigned long flags;
+	int map, block;
 
-	if ((page = pool_find_page(pool, dma)) == NULL) {
+	page = pool_find_page(pool, dma);
+	if (!page) {
 		if (pool->dev)
-			dev_err(pool->dev, "dma_pool_free %s, %p/%lx (bad dma)\n",
-				pool->name, vaddr, (unsigned long) dma);
+			dev_err(pool->dev,
+				"dma_pool_free %s, %p/%lx (bad dma)\n",
+				pool->name, vaddr, (unsigned long)dma);
 		else
-			printk (KERN_ERR "dma_pool_free %s, %p/%lx (bad dma)\n",
-				pool->name, vaddr, (unsigned long) dma);
+			printk(KERN_ERR "dma_pool_free %s, %p/%lx (bad dma)\n",
+			       pool->name, vaddr, (unsigned long)dma);
 		return;
 	}
 
@@ -383,37 +379,42 @@ dma_pool_free (struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 #ifdef	CONFIG_DEBUG_SLAB
 	if (((dma - page->dma) + (void *)page->vaddr) != vaddr) {
 		if (pool->dev)
-			dev_err(pool->dev, "dma_pool_free %s, %p (bad vaddr)/%Lx\n",
-				pool->name, vaddr, (unsigned long long) dma);
+			dev_err(pool->dev,
+				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
+				pool->name, vaddr, (unsigned long long)dma);
 		else
-			printk (KERN_ERR "dma_pool_free %s, %p (bad vaddr)/%Lx\n",
-				pool->name, vaddr, (unsigned long long) dma);
+			printk(KERN_ERR
+			       "dma_pool_free %s, %p (bad vaddr)/%Lx\n",
+			       pool->name, vaddr, (unsigned long long)dma);
 		return;
 	}
-	if (page->bitmap [map] & (1UL << block)) {
+	if (page->bitmap[map] & (1UL << block)) {
 		if (pool->dev)
-			dev_err(pool->dev, "dma_pool_free %s, dma %Lx already free\n",
+			dev_err(pool->dev,
+				"dma_pool_free %s, dma %Lx already free\n",
 				pool->name, (unsigned long long)dma);
 		else
-			printk (KERN_ERR "dma_pool_free %s, dma %Lx already free\n",
-				pool->name, (unsigned long long)dma);
+			printk(KERN_ERR
+			       "dma_pool_free %s, dma %Lx already free\n",
+			       pool->name, (unsigned long long)dma);
 		return;
 	}
-	memset (vaddr, POOL_POISON_FREED, pool->size);
+	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
-	spin_lock_irqsave (&pool->lock, flags);
+	spin_lock_irqsave(&pool->lock, flags);
 	page->in_use--;
-	set_bit (block, &page->bitmap [map]);
-	if (waitqueue_active (&pool->waitq))
-		wake_up (&pool->waitq);
+	set_bit(block, &page->bitmap[map]);
+	if (waitqueue_active(&pool->waitq))
+		wake_up(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(bpp, page->bitmap)) pool_free_page(pool, page);
 	 * Better have a few empty pages hang around.
 	 */
-	spin_unlock_irqrestore (&pool->lock, flags);
+	spin_unlock_irqrestore(&pool->lock, flags);
 }
+EXPORT_SYMBOL(dma_pool_free);
 
 /*
  * Managed DMA pool
@@ -458,6 +459,7 @@ struct dma_pool *dmam_pool_create(const char *name, struct device *dev,
 
 	return pool;
 }
+EXPORT_SYMBOL(dmam_pool_create);
 
 /**
  * dmam_pool_destroy - Managed dma_pool_destroy()
@@ -472,10 +474,4 @@ void dmam_pool_destroy(struct dma_pool *pool)
 	dma_pool_destroy(pool);
 	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
 }
-
-EXPORT_SYMBOL (dma_pool_create);
-EXPORT_SYMBOL (dma_pool_destroy);
-EXPORT_SYMBOL (dma_pool_alloc);
-EXPORT_SYMBOL (dma_pool_free);
-EXPORT_SYMBOL (dmam_pool_create);
-EXPORT_SYMBOL (dmam_pool_destroy);
+EXPORT_SYMBOL(dmam_pool_destroy);
-- 
1.4.4.4
