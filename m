Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXJNMey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXJNMey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXJNMep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:34:45 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:51863 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXJNMeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:34:44 -0400
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 08:34:43 EDT
Message-ID: <4712068F.20005@freemail.hu>
Date: Sun, 14 Oct 2007 14:07:43 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH]: drm: cleanup DRM_DEBUG() parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

As DRM_DEBUG macro already prints out the __FUNCTION__ string (see
drivers/char/drm/drmP.h), it is not worth doing this again. At some
other places the ending "\n" was added.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.23.orig/drivers/char/drm/ati_pcigart.c linux-2.6.23/drivers/char/drm/ati_pcigart.c
--- linux-2.6.23.orig/drivers/char/drm/ati_pcigart.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/ati_pcigart.c	2007-10-13 17:54:48.000000000 +0200
@@ -41,7 +41,7 @@ static void *drm_ati_alloc_pcigart_table
 	struct page *page;
 	int i;

-	DRM_DEBUG("%s: alloc %d order\n", __FUNCTION__, order);
+	DRM_DEBUG("%d order\n", order);

 	address = __get_free_pages(GFP_KERNEL | __GFP_COMP,
 				   order);
@@ -54,7 +54,7 @@ static void *drm_ati_alloc_pcigart_table
 	for (i = 0; i < order; i++, page++)
 		SetPageReserved(page);

-	DRM_DEBUG("%s: returning 0x%08lx\n", __FUNCTION__, address);
+	DRM_DEBUG("returning 0x%08lx\n", address);
 	return (void *)address;
 }

@@ -63,7 +63,7 @@ static void drm_ati_free_pcigart_table(v
 	struct page *page;
 	int i;
 	int num_pages = 1 << order;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	page = virt_to_page((unsigned long)address);

diff -uprN linux-2.6.23.orig/drivers/char/drm/drm_irq.c linux-2.6.23/drivers/char/drm/drm_irq.c
--- linux-2.6.23.orig/drivers/char/drm/drm_irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/drm_irq.c	2007-10-13 17:26:42.000000000 +0200
@@ -113,7 +113,7 @@ static int drm_irq_install(struct drm_de
 	dev->irq_enabled = 1;
 	mutex_unlock(&dev->struct_mutex);

-	DRM_DEBUG("%s: irq=%d\n", __FUNCTION__, dev->irq);
+	DRM_DEBUG("irq=%d\n", dev->irq);

 	if (drm_core_check_feature(dev, DRIVER_IRQ_VBL)) {
 		init_waitqueue_head(&dev->vbl_queue);
@@ -170,7 +170,7 @@ int drm_irq_uninstall(struct drm_device
 	if (!irq_enabled)
 		return -EINVAL;

-	DRM_DEBUG("%s: irq=%d\n", __FUNCTION__, dev->irq);
+	DRM_DEBUG("irq=%d\n", dev->irq);

 	dev->driver->irq_uninstall(dev);

diff -uprN linux-2.6.23.orig/drivers/char/drm/drm_scatter.c linux-2.6.23/drivers/char/drm/drm_scatter.c
--- linux-2.6.23.orig/drivers/char/drm/drm_scatter.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/drm_scatter.c	2007-10-13 17:49:52.000000000 +0200
@@ -72,7 +72,7 @@ int drm_sg_alloc(struct inode *inode, st
 	struct drm_sg_mem *entry;
 	unsigned long pages, i, j;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	if (!drm_core_check_feature(dev, DRIVER_SG))
 		return -EINVAL;
@@ -90,7 +90,7 @@ int drm_sg_alloc(struct inode *inode, st
 	memset(entry, 0, sizeof(*entry));

 	pages = (request.size + PAGE_SIZE - 1) / PAGE_SIZE;
-	DRM_DEBUG("sg size=%ld pages=%ld\n", request.size, pages);
+	DRM_DEBUG("size=%ld pages=%ld\n", request.size, pages);

 	entry->pages = pages;
 	entry->pagelist = drm_alloc(pages * sizeof(*entry->pagelist),
@@ -131,8 +131,8 @@ int drm_sg_alloc(struct inode *inode, st

 	entry->handle = ScatterHandle((unsigned long)entry->virtual);

-	DRM_DEBUG("sg alloc handle  = %08lx\n", entry->handle);
-	DRM_DEBUG("sg alloc virtual = %p\n", entry->virtual);
+	DRM_DEBUG("handle  = %08lx\n", entry->handle);
+	DRM_DEBUG("virtual = %p\n", entry->virtual);

 	for (i = (unsigned long)entry->virtual, j = 0; j < pages;
 	     i += PAGE_SIZE, j++) {
@@ -220,7 +220,7 @@ int drm_sg_free(struct inode *inode, str
 	if (!entry || entry->handle != request.handle)
 		return -EINVAL;

-	DRM_DEBUG("sg free virtual  = %p\n", entry->virtual);
+	DRM_DEBUG("virtual  = %p\n", entry->virtual);

 	drm_sg_cleanup(entry);

diff -uprN linux-2.6.23.orig/drivers/char/drm/drm_vm.c linux-2.6.23/drivers/char/drm/drm_vm.c
--- linux-2.6.23.orig/drivers/char/drm/drm_vm.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/drm_vm.c	2007-10-13 17:48:30.000000000 +0200
@@ -180,7 +180,7 @@ static __inline__ struct page *drm_do_vm
 		return NOPAGE_SIGBUS;
 	get_page(page);

-	DRM_DEBUG("shm_nopage 0x%lx\n", address);
+	DRM_DEBUG("0x%lx\n", address);
 	return page;
 }

@@ -294,7 +294,7 @@ static __inline__ struct page *drm_do_vm

 	get_page(page);

-	DRM_DEBUG("dma_nopage 0x%lx (page %lu)\n", address, page_nr);
+	DRM_DEBUG("0x%lx (page %lu)\n", address, page_nr);
 	return page;
 }

diff -uprN linux-2.6.23.orig/drivers/char/drm/i810_dma.c linux-2.6.23/drivers/char/drm/i810_dma.c
--- linux-2.6.23.orig/drivers/char/drm/i810_dma.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i810_dma.c	2007-10-13 17:46:05.000000000 +0200
@@ -641,7 +641,7 @@ static void i810EmitState(struct drm_dev
 	drm_i810_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;

-	DRM_DEBUG("%s %x\n", __FUNCTION__, dirty);
+	DRM_DEBUG("%x\n", dirty);

 	if (dirty & I810_UPLOAD_BUFFERS) {
 		i810EmitDestVerified(dev, sarea_priv->BufferState);
@@ -873,8 +873,7 @@ static void i810_dma_dispatch_flip(struc
 	int pitch = dev_priv->pitch;
 	RING_LOCALS;

-	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+	DRM_DEBUG("page=%d pfCurrentPage=%d\n",
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);

@@ -1028,7 +1027,7 @@ static int i810_dma_vertex(struct inode

 	LOCK_TEST_WITH_RETURN(dev, filp);

-	DRM_DEBUG("i810 dma vertex, idx %d used %d discard %d\n",
+	DRM_DEBUG("idx %d used %d discard %d\n",
 		  vertex.idx, vertex.used, vertex.discard);

 	if (vertex.idx < 0 || vertex.idx > dma->buf_count)
@@ -1075,7 +1074,7 @@ static int i810_swap_bufs(struct inode *
 	struct drm_file *priv = filp->private_data;
 	struct drm_device *dev = priv->head->dev;

-	DRM_DEBUG("i810_swap_bufs\n");
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

@@ -1165,11 +1164,10 @@ static void i810_dma_dispatch_mc(struct

 	sarea_priv->dirty = 0x7f;

-	DRM_DEBUG("dispatch mc addr 0x%lx, used 0x%x\n", address, used);
+	DRM_DEBUG("addr 0x%lx, used 0x%x\n", address, used);

 	dev_priv->counter++;
 	DRM_DEBUG("dispatch counter : %ld\n", dev_priv->counter);
-	DRM_DEBUG("i810_dma_dispatch_mc\n");
 	DRM_DEBUG("start : %lx\n", start);
 	DRM_DEBUG("used : %d\n", used);
 	DRM_DEBUG("start + used - 4 : %ld\n", start + used - 4);
@@ -1292,7 +1290,7 @@ static void i810_do_init_pageflip(struct
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");
 	dev_priv->page_flipping = 1;
 	dev_priv->current_page = 0;
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
@@ -1302,7 +1300,7 @@ static int i810_do_cleanup_pageflip(stru
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");
 	if (dev_priv->current_page != 0)
 		i810_dma_dispatch_flip(dev);

@@ -1317,7 +1315,7 @@ static int i810_flip_bufs(struct inode *
 	struct drm_device *dev = priv->head->dev;
 	drm_i810_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

diff -uprN linux-2.6.23.orig/drivers/char/drm/i810_drv.h linux-2.6.23/drivers/char/drm/i810_drv.h
--- linux-2.6.23.orig/drivers/char/drm/i810_drv.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i810_drv.h	2007-10-13 17:44:13.000000000 +0200
@@ -144,7 +144,7 @@ extern int i810_max_ioctl;

 #define BEGIN_LP_RING(n) do {						\
 	if (I810_VERBOSE)                                               \
-           DRM_DEBUG("BEGIN_LP_RING(%d) in %s\n", n, __FUNCTION__);	\
+           DRM_DEBUG("BEGIN_LP_RING(%d)\n", n);				\
 	if (dev_priv->ring.space < n*4)					\
 		i810_wait_ring(dev, n*4);				\
 	dev_priv->ring.space -= n*4;					\
diff -uprN linux-2.6.23.orig/drivers/char/drm/i830_dma.c linux-2.6.23/drivers/char/drm/i830_dma.c
--- linux-2.6.23.orig/drivers/char/drm/i830_dma.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i830_dma.c	2007-10-13 17:39:11.000000000 +0200
@@ -698,7 +698,7 @@ static void i830EmitState(struct drm_dev
 	drm_i830_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;

-	DRM_DEBUG("%s %x\n", __FUNCTION__, dirty);
+	DRM_DEBUG("%x\n", dirty);

 	if (dirty & I830_UPLOAD_BUFFERS) {
 		i830EmitDestVerified(dev, sarea_priv->BufferState);
@@ -1048,8 +1048,7 @@ static void i830_dma_dispatch_flip(struc
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;

-	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+	DRM_DEBUG("page=%d pfCurrentPage=%d\n",
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);

@@ -1118,12 +1117,11 @@ static void i830_dma_dispatch_vertex(str
 	if (sarea_priv->dirty)
 		i830EmitState(dev);

-	DRM_DEBUG("dispatch vertex addr 0x%lx, used 0x%x nbox %d\n",
+	DRM_DEBUG("addr 0x%lx, used 0x%x nbox %d\n",
 		  address, used, nbox);

 	dev_priv->counter++;
 	DRM_DEBUG("dispatch counter : %ld\n", dev_priv->counter);
-	DRM_DEBUG("i830_dma_dispatch\n");
 	DRM_DEBUG("start : %lx\n", start);
 	DRM_DEBUG("used : %d\n", used);
 	DRM_DEBUG("start + used - 4 : %ld\n", start + used - 4);
@@ -1308,7 +1306,7 @@ static int i830_dma_vertex(struct inode

 	LOCK_TEST_WITH_RETURN(dev, filp);

-	DRM_DEBUG("i830 dma vertex, idx %d used %d discard %d\n",
+	DRM_DEBUG("idx %d used %d discard %d\n",
 		  vertex.idx, vertex.used, vertex.discard);

 	if (vertex.idx < 0 || vertex.idx > dma->buf_count)
@@ -1354,7 +1352,7 @@ static int i830_swap_bufs(struct inode *
 	struct drm_file *priv = filp->private_data;
 	struct drm_device *dev = priv->head->dev;

-	DRM_DEBUG("i830_swap_bufs\n");
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

@@ -1368,7 +1366,7 @@ static void i830_do_init_pageflip(struct
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");
 	dev_priv->page_flipping = 1;
 	dev_priv->current_page = 0;
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
@@ -1378,7 +1376,7 @@ static int i830_do_cleanup_pageflip(stru
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");
 	if (dev_priv->current_page != 0)
 		i830_dma_dispatch_flip(dev);

@@ -1393,7 +1391,7 @@ static int i830_flip_bufs(struct inode *
 	struct drm_device *dev = priv->head->dev;
 	drm_i830_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

@@ -1430,7 +1428,7 @@ static int i830_getbuf(struct inode *ino
 	drm_i830_sarea_t *sarea_priv = (drm_i830_sarea_t *)
 	    dev_priv->sarea_priv;

-	DRM_DEBUG("getbuf\n");
+	DRM_DEBUG("\n");
 	if (copy_from_user(&d, (drm_i830_dma_t __user *) arg, sizeof(d)))
 		return -EFAULT;

diff -uprN linux-2.6.23.orig/drivers/char/drm/i830_irq.c linux-2.6.23/drivers/char/drm/i830_irq.c
--- linux-2.6.23.orig/drivers/char/drm/i830_irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i830_irq.c	2007-10-13 17:35:59.000000000 +0200
@@ -58,7 +58,7 @@ static int i830_emit_irq(struct drm_devi
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	atomic_inc(&dev_priv->irq_emitted);

@@ -77,7 +77,7 @@ static int i830_wait_irq(struct drm_devi
 	unsigned long end = jiffies + HZ * 3;
 	int ret = 0;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	if (atomic_read(&dev_priv->irq_received) >= irq_nr)
 		return 0;
diff -uprN linux-2.6.23.orig/drivers/char/drm/i915_dma.c linux-2.6.23/drivers/char/drm/i915_dma.c
--- linux-2.6.23.orig/drivers/char/drm/i915_dma.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i915_dma.c	2007-10-13 17:34:58.000000000 +0200
@@ -217,7 +217,7 @@ static int i915_dma_resume(struct drm_de
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	if (!dev_priv->sarea) {
 		DRM_ERROR("can not find sarea!\n");
@@ -547,8 +547,7 @@ static int i915_dispatch_flip(struct drm
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;

-	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+	DRM_DEBUG("page=%d pfCurrentPage=%d\n",
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);

@@ -625,7 +624,7 @@ static int i915_batchbuffer(DRM_IOCTL_AR
 	DRM_COPY_FROM_USER_IOCTL(batch, (drm_i915_batchbuffer_t __user *) data,
 				 sizeof(batch));

-	DRM_DEBUG("i915 batchbuffer, start %x used %d cliprects %d\n",
+	DRM_DEBUG("start %x used %d cliprects %d\n",
 		  batch.start, batch.used, batch.num_cliprects);

 	LOCK_TEST_WITH_RETURN(dev, filp);
@@ -654,7 +653,7 @@ static int i915_cmdbuffer(DRM_IOCTL_ARGS
 	DRM_COPY_FROM_USER_IOCTL(cmdbuf, (drm_i915_cmdbuffer_t __user *) data,
 				 sizeof(cmdbuf));

-	DRM_DEBUG("i915 cmdbuffer, buf %p sz %d cliprects %d\n",
+	DRM_DEBUG("buf %p sz %d cliprects %d\n",
 		  cmdbuf.buf, cmdbuf.sz, cmdbuf.num_cliprects);

 	LOCK_TEST_WITH_RETURN(dev, filp);
@@ -681,7 +680,7 @@ static int i915_flip_bufs(DRM_IOCTL_ARGS
 {
 	DRM_DEVICE;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

diff -uprN linux-2.6.23.orig/drivers/char/drm/i915_drv.h linux-2.6.23/drivers/char/drm/i915_drv.h
--- linux-2.6.23.orig/drivers/char/drm/i915_drv.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i915_drv.h	2007-10-13 17:33:42.000000000 +0200
@@ -163,8 +163,7 @@ extern void i915_mem_release(struct drm_

 #define BEGIN_LP_RING(n) do {				\
 	if (I915_VERBOSE)				\
-		DRM_DEBUG("BEGIN_LP_RING(%d) in %s\n",	\
-			  (n), __FUNCTION__);		\
+		DRM_DEBUG("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < (n)*4)			\
 		i915_wait_ring(dev, (n)*4, __FUNCTION__);		\
 	outcount = 0;					\
diff -uprN linux-2.6.23.orig/drivers/char/drm/i915_irq.c linux-2.6.23/drivers/char/drm/i915_irq.c
--- linux-2.6.23.orig/drivers/char/drm/i915_irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/i915_irq.c	2007-10-13 17:33:04.000000000 +0200
@@ -223,7 +223,7 @@ irqreturn_t i915_driver_irq_handler(DRM_

 	temp &= (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);

-	DRM_DEBUG("%s flag=%08x\n", __FUNCTION__, temp);
+	DRM_DEBUG("flag=%08x\n", temp);

 	if (temp == 0)
 		return IRQ_NONE;
@@ -276,7 +276,7 @@ static int i915_emit_irq(struct drm_devi

 	i915_kernel_lost_context(dev);

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	dev_priv->sarea_priv->last_enqueue = ++dev_priv->counter;

@@ -300,7 +300,7 @@ static int i915_wait_irq(struct drm_devi
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	int ret = 0;

-	DRM_DEBUG("%s irq_nr=%d breadcrumb=%d\n", __FUNCTION__, irq_nr,
+	DRM_DEBUG("irq_nr=%d breadcrumb=%d\n", irq_nr,
 		  READ_BREADCRUMB(dev_priv));

 	if (READ_BREADCRUMB(dev_priv) >= irq_nr)
diff -uprN linux-2.6.23.orig/drivers/char/drm/mga_state.c linux-2.6.23/drivers/char/drm/mga_state.c
--- linux-2.6.23.orig/drivers/char/drm/mga_state.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/mga_state.c	2007-10-13 17:32:05.000000000 +0200
@@ -619,7 +619,7 @@ static void mga_dma_dispatch_swap(struct

 	FLUSH_DMA();

-	DRM_DEBUG("%s... done.\n", __FUNCTION__);
+	DRM_DEBUG("done.\n");
 }

 static void mga_dma_dispatch_vertex(struct drm_device * dev, struct drm_buf * buf)
@@ -631,7 +631,7 @@ static void mga_dma_dispatch_vertex(stru
 	u32 length = (u32) buf->used;
 	int i = 0;
 	DMA_LOCALS;
-	DRM_DEBUG("vertex: buf=%d used=%d\n", buf->idx, buf->used);
+	DRM_DEBUG("buf=%d used=%d\n", buf->idx, buf->used);

 	if (buf->used) {
 		buf_priv->dispatched = 1;
@@ -678,7 +678,7 @@ static void mga_dma_dispatch_indices(str
 	u32 address = (u32) buf->bus_address;
 	int i = 0;
 	DMA_LOCALS;
-	DRM_DEBUG("indices: buf=%d start=%d end=%d\n", buf->idx, start, end);
+	DRM_DEBUG("buf=%d start=%d end=%d\n", buf->idx, start, end);

 	if (start != end) {
 		buf_priv->dispatched = 1;
diff -uprN linux-2.6.23.orig/drivers/char/drm/r128_state.c linux-2.6.23/drivers/char/drm/r128_state.c
--- linux-2.6.23.orig/drivers/char/drm/r128_state.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/r128_state.c	2007-10-13 17:57:20.000000000 +0200
@@ -42,7 +42,7 @@ static void r128_emit_clip_rects(drm_r12
 {
 	u32 aux_sc_cntl = 0x00000000;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING((count < 3 ? count : 3) * 5 + 2);

@@ -85,7 +85,7 @@ static __inline__ void r128_emit_core(dr
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(2);

@@ -100,7 +100,7 @@ static __inline__ void r128_emit_context
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(13);

@@ -126,7 +126,7 @@ static __inline__ void r128_emit_setup(d
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(3);

@@ -142,7 +142,7 @@ static __inline__ void r128_emit_masks(d
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(5);

@@ -161,7 +161,7 @@ static __inline__ void r128_emit_window(
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(2);

@@ -178,7 +178,7 @@ static __inline__ void r128_emit_tex0(dr
 	drm_r128_texture_regs_t *tex = &sarea_priv->tex_state[0];
 	int i;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(7 + R128_MAX_TEXTURE_LEVELS);

@@ -204,7 +204,7 @@ static __inline__ void r128_emit_tex1(dr
 	drm_r128_texture_regs_t *tex = &sarea_priv->tex_state[1];
 	int i;
 	RING_LOCALS;
-	DRM_DEBUG("    %s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(5 + R128_MAX_TEXTURE_LEVELS);

@@ -226,7 +226,7 @@ static void r128_emit_state(drm_r128_pri
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;

-	DRM_DEBUG("%s: dirty=0x%08x\n", __FUNCTION__, dirty);
+	DRM_DEBUG("dirty=0x%08x\n", dirty);

 	if (dirty & R128_UPLOAD_CORE) {
 		r128_emit_core(dev_priv);
@@ -362,7 +362,7 @@ static void r128_cce_dispatch_clear(stru
 	unsigned int flags = clear->flags;
 	int i;
 	RING_LOCALS;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	if (dev_priv->page_flipping && dev_priv->current_page == 1) {
 		unsigned int tmp = flags;
@@ -466,7 +466,7 @@ static void r128_cce_dispatch_swap(struc
 	struct drm_clip_rect *pbox = sarea_priv->boxes;
 	int i;
 	RING_LOCALS;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 #if R128_PERFORMANCE_BOXES
 	/* Do some trivial performance monitoring...
@@ -528,8 +528,7 @@ static void r128_cce_dispatch_flip(struc
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
-	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+	DRM_DEBUG("page=%d pfCurrentPage=%d\n",
 		  dev_priv->current_page, dev_priv->sarea_priv->pfCurrentPage);

 #if R128_PERFORMANCE_BOXES
@@ -643,7 +642,7 @@ static void r128_cce_dispatch_indirect(s
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_buf_priv_t *buf_priv = buf->dev_private;
 	RING_LOCALS;
-	DRM_DEBUG("indirect: buf=%d s=0x%x e=0x%x\n", buf->idx, start, end);
+	DRM_DEBUG("buf=%d s=0x%x e=0x%x\n", buf->idx, start, end);

 	if (start != end) {
 		int offset = buf->bus_address + start;
@@ -706,7 +705,7 @@ static void r128_cce_dispatch_indices(st
 	int dwords;
 	int i = 0;
 	RING_LOCALS;
-	DRM_DEBUG("indices: s=%d e=%d c=%d\n", start, end, count);
+	DRM_DEBUG("s=%d e=%d c=%d\n", start, end, count);

 	if (0)
 		r128_print_dirty("dispatch_indices", sarea_priv->dirty);
@@ -1155,7 +1154,7 @@ static int r128_cce_dispatch_read_pixels
 	int count, *x, *y;
 	int i, xbuf_size, ybuf_size;
 	RING_LOCALS;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	count = depth->n;
 	if (count > 4096 || count <= 0)
@@ -1225,7 +1224,7 @@ static void r128_cce_dispatch_stipple(st
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int i;
 	RING_LOCALS;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	BEGIN_RING(33);

@@ -1313,7 +1312,7 @@ static int r128_cce_flip(DRM_IOCTL_ARGS)
 {
 	DRM_DEVICE;
 	drm_r128_private_t *dev_priv = dev->dev_private;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

@@ -1333,7 +1332,7 @@ static int r128_cce_swap(DRM_IOCTL_ARGS)
 	DRM_DEVICE;
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	LOCK_TEST_WITH_RETURN(dev, filp);

@@ -1589,7 +1588,7 @@ static int r128_cce_indirect(DRM_IOCTL_A
 	DRM_COPY_FROM_USER_IOCTL(indirect, (drm_r128_indirect_t __user *) data,
 				 sizeof(indirect));

-	DRM_DEBUG("indirect: idx=%d s=%d e=%d d=%d\n",
+	DRM_DEBUG("idx=%d s=%d e=%d d=%d\n",
 		  indirect.idx, indirect.start, indirect.end, indirect.discard);

 	if (indirect.idx < 0 || indirect.idx >= dma->buf_count) {
diff -uprN linux-2.6.23.orig/drivers/char/drm/r300_cmdbuf.c linux-2.6.23/drivers/char/drm/r300_cmdbuf.c
--- linux-2.6.23.orig/drivers/char/drm/r300_cmdbuf.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/r300_cmdbuf.c	2007-10-13 17:52:37.000000000 +0200
@@ -64,7 +64,7 @@ static int r300_emit_cliprects(drm_radeo
 	if (nr > R300_SIMULTANEOUS_CLIPRECTS)
 		nr = R300_SIMULTANEOUS_CLIPRECTS;

-	DRM_DEBUG("%i cliprects\n", nr);
+	DRM_DEBUG("%i\n", nr);

 	if (nr) {
 		BEGIN_RING(6 + nr * 2);
diff -uprN linux-2.6.23.orig/drivers/char/drm/radeon_state.c linux-2.6.23/drivers/char/drm/radeon_state.c
--- linux-2.6.23.orig/drivers/char/drm/radeon_state.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/radeon_state.c	2007-10-13 18:00:33.000000000 +0200
@@ -895,7 +895,7 @@ static void radeon_cp_dispatch_clear(str
 			int w = pbox[i].x2 - x;
 			int h = pbox[i].y2 - y;

-			DRM_DEBUG("dispatch clear %d,%d-%d,%d flags 0x%x\n",
+			DRM_DEBUG("%d,%d-%d,%d flags 0x%x\n",
 				  x, y, w, h, flags);

 			if (flags & RADEON_FRONT) {
@@ -1365,7 +1365,7 @@ static void radeon_cp_dispatch_swap(stru
 		int w = pbox[i].x2 - x;
 		int h = pbox[i].y2 - y;

-		DRM_DEBUG("dispatch swap %d,%d-%d,%d\n", x, y, w, h);
+		DRM_DEBUG("%d,%d-%d,%d\n", x, y, w, h);

 		BEGIN_RING(9);

@@ -1419,8 +1419,7 @@ static void radeon_cp_dispatch_flip(stru
 	int offset = (dev_priv->sarea_priv->pfCurrentPage == 1)
 	    ? dev_priv->front_offset : dev_priv->back_offset;
 	RING_LOCALS;
-	DRM_DEBUG("%s: pfCurrentPage=%d\n",
-		  __FUNCTION__,
+	DRM_DEBUG("pfCurrentPage=%d\n",
 		  dev_priv->sarea_priv->pfCurrentPage);

 	/* Do some trivial performance monitoring...
@@ -1559,7 +1558,7 @@ static void radeon_cp_dispatch_indirect(
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
-	DRM_DEBUG("indirect: buf=%d s=0x%x e=0x%x\n", buf->idx, start, end);
+	DRM_DEBUG("buf=%d s=0x%x e=0x%x\n", buf->idx, start, end);

 	if (start != end) {
 		int offset = (dev_priv->gart_buffers_offset
@@ -1758,7 +1757,7 @@ static int radeon_cp_dispatch_texture(DR
 			buf = radeon_freelist_get(dev);
 		}
 		if (!buf) {
-			DRM_DEBUG("radeon_cp_dispatch_texture: EAGAIN\n");
+			DRM_DEBUG("EAGAIN\n");
 			if (DRM_COPY_TO_USER(tex->image, image, sizeof(*image)))
 				return DRM_ERR(EFAULT);
 			return DRM_ERR(EAGAIN);
@@ -2449,7 +2448,7 @@ static int radeon_cp_indirect(DRM_IOCTL_
 				 (drm_radeon_indirect_t __user *) data,
 				 sizeof(indirect));

-	DRM_DEBUG("indirect: idx=%d s=%d e=%d d=%d\n",
+	DRM_DEBUG("idx=%d s=%d e=%d d=%d\n",
 		  indirect.idx, indirect.start, indirect.end, indirect.discard);

 	if (indirect.idx < 0 || indirect.idx >= dma->buf_count) {
@@ -2821,7 +2820,7 @@ static int radeon_emit_wait(struct drm_d
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;

-	DRM_DEBUG("%s: %x\n", __FUNCTION__, flags);
+	DRM_DEBUG("%x\n", flags);
 	switch (flags) {
 	case RADEON_WAIT_2D:
 		BEGIN_RING(2);
diff -uprN linux-2.6.23.orig/drivers/char/drm/sis_mm.c linux-2.6.23/drivers/char/drm/sis_mm.c
--- linux-2.6.23.orig/drivers/char/drm/sis_mm.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/sis_mm.c	2007-10-13 16:27:59.000000000 +0200
@@ -118,7 +118,7 @@ static int sis_fb_init(DRM_IOCTL_ARGS)
 	dev_priv->vram_offset = fb.offset;

 	mutex_unlock(&dev->struct_mutex);
-	DRM_DEBUG("offset = %u, size = %u", fb.offset, fb.size);
+	DRM_DEBUG("offset = %u, size = %u\n", fb.offset, fb.size);

 	return 0;
 }
@@ -218,7 +218,7 @@ static int sis_ioctl_agp_init(DRM_IOCTL_
 	dev_priv->agp_offset = agp.offset;
 	mutex_unlock(&dev->struct_mutex);

-	DRM_DEBUG("offset = %u, size = %u", agp.offset, agp.size);
+	DRM_DEBUG("offset = %u, size = %u\n", agp.offset, agp.size);
 	return 0;
 }

diff -uprN linux-2.6.23.orig/drivers/char/drm/via_dma.c linux-2.6.23/drivers/char/drm/via_dma.c
--- linux-2.6.23.orig/drivers/char/drm/via_dma.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/via_dma.c	2007-10-13 17:47:24.000000000 +0200
@@ -346,7 +346,7 @@ static int via_cmdbuffer(DRM_IOCTL_ARGS)
 	DRM_COPY_FROM_USER_IOCTL(cmdbuf, (drm_via_cmdbuffer_t __user *) data,
 				 sizeof(cmdbuf));

-	DRM_DEBUG("via cmdbuffer, buf %p size %lu\n", cmdbuf.buf, cmdbuf.size);
+	DRM_DEBUG("buf %p size %lu\n", cmdbuf.buf, cmdbuf.size);

 	ret = via_dispatch_cmdbuffer(dev, &cmdbuf);
 	if (ret) {
@@ -391,7 +391,7 @@ static int via_pci_cmdbuffer(DRM_IOCTL_A
 	DRM_COPY_FROM_USER_IOCTL(cmdbuf, (drm_via_cmdbuffer_t __user *) data,
 				 sizeof(cmdbuf));

-	DRM_DEBUG("via_pci_cmdbuffer, buf %p size %lu\n", cmdbuf.buf,
+	DRM_DEBUG("buf %p size %lu\n", cmdbuf.buf,
 		  cmdbuf.size);

 	ret = via_dispatch_pci_cmdbuffer(dev, &cmdbuf);
@@ -661,7 +661,7 @@ static int via_cmdbuf_size(DRM_IOCTL_ARG
 	uint32_t tmp_size, count;
 	drm_via_private_t *dev_priv;

-	DRM_DEBUG("via cmdbuf_size\n");
+	DRM_DEBUG("\n");
 	LOCK_TEST_WITH_RETURN(dev, filp);

 	dev_priv = (drm_via_private_t *) dev->dev_private;
diff -uprN linux-2.6.23.orig/drivers/char/drm/via_irq.c linux-2.6.23/drivers/char/drm/via_irq.c
--- linux-2.6.23.orig/drivers/char/drm/via_irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/via_irq.c	2007-10-14 12:19:26.000000000 +0200
@@ -169,7 +169,7 @@ int via_driver_vblank_wait(struct drm_de
 	unsigned int cur_vblank;
 	int ret = 0;

-	DRM_DEBUG("viadrv_vblank_wait\n");
+	DRM_DEBUG("\n");
 	if (!dev_priv) {
 		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
 		return -EINVAL;
@@ -201,7 +201,7 @@ via_driver_irq_wait(struct drm_device *
 	maskarray_t *masks;
 	int real_irq;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	if (!dev_priv) {
 		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
@@ -251,7 +251,7 @@ void via_driver_irq_preinstall(struct dr
 	drm_via_irq_t *cur_irq;
 	int i;

-	DRM_DEBUG("driver_irq_preinstall: dev_priv: %p\n", dev_priv);
+	DRM_DEBUG("dev_priv: %p\n", dev_priv);
 	if (dev_priv) {
 		cur_irq = dev_priv->via_irqs;

@@ -298,7 +298,7 @@ void via_driver_irq_postinstall(struct d
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
 	u32 status;

-	DRM_DEBUG("via_driver_irq_postinstall\n");
+	DRM_DEBUG("\n");
 	if (dev_priv) {
 		status = VIA_READ(VIA_REG_INTERRUPT);
 		VIA_WRITE(VIA_REG_INTERRUPT, status | VIA_IRQ_GLOBAL
@@ -317,7 +317,7 @@ void via_driver_irq_uninstall(struct drm
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
 	u32 status;

-	DRM_DEBUG("driver_irq_uninstall)\n");
+	DRM_DEBUG("\n");
 	if (dev_priv) {

 		/* Some more magic, oh for some data sheets ! */
diff -uprN linux-2.6.23.orig/drivers/char/drm/via_map.c linux-2.6.23/drivers/char/drm/via_map.c
--- linux-2.6.23.orig/drivers/char/drm/via_map.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/via_map.c	2007-10-13 17:46:46.000000000 +0200
@@ -29,7 +29,7 @@ static int via_do_init_map(struct drm_de
 {
 	drm_via_private_t *dev_priv = dev->dev_private;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	dev_priv->sarea = drm_getsarea(dev);
 	if (!dev_priv->sarea) {
@@ -80,7 +80,7 @@ int via_map_init(DRM_IOCTL_ARGS)
 	DRM_DEVICE;
 	drm_via_init_t init;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	DRM_COPY_FROM_USER_IOCTL(init, (drm_via_init_t __user *) data,
 				 sizeof(init));
diff -uprN linux-2.6.23.orig/drivers/char/drm/via_mm.c linux-2.6.23/drivers/char/drm/via_mm.c
--- linux-2.6.23.orig/drivers/char/drm/via_mm.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/via_mm.c	2007-10-13 16:27:59.000000000 +0200
@@ -56,7 +56,7 @@ int via_agp_init(DRM_IOCTL_ARGS)
 	dev_priv->agp_offset = agp.offset;
 	mutex_unlock(&dev->struct_mutex);

-	DRM_DEBUG("offset = %u, size = %u", agp.offset, agp.size);
+	DRM_DEBUG("offset = %u, size = %u\n", agp.offset, agp.size);
 	return 0;
 }

@@ -83,7 +83,7 @@ int via_fb_init(DRM_IOCTL_ARGS)
 	dev_priv->vram_offset = fb.offset;

 	mutex_unlock(&dev->struct_mutex);
-	DRM_DEBUG("offset = %u, size = %u", fb.offset, fb.size);
+	DRM_DEBUG("offset = %u, size = %u\n", fb.offset, fb.size);

 	return 0;

diff -uprN linux-2.6.23.orig/drivers/char/drm/via_video.c linux-2.6.23/drivers/char/drm/via_video.c
--- linux-2.6.23.orig/drivers/char/drm/via_video.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/char/drm/via_video.c	2007-10-13 17:25:15.000000000 +0200
@@ -33,7 +33,7 @@ void via_init_futex(drm_via_private_t *
 {
 	unsigned int i;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	for (i = 0; i < VIA_NR_XVMC_LOCKS; ++i) {
 		DRM_INIT_WAITQUEUE(&(dev_priv->decoder_queue[i]));
@@ -74,7 +74,7 @@ int via_decoder_futex(DRM_IOCTL_ARGS)
 	drm_via_sarea_t *sAPriv = dev_priv->sarea_priv;
 	int ret = 0;

-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("\n");

 	DRM_COPY_FROM_USER_IOCTL(fx, (drm_via_futex_t __user *) data,
 				 sizeof(fx));
