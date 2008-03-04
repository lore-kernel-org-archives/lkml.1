Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYCDDKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYCDDKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYCDDJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:09:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:11850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYCDDJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B+lufTY2nMnYma5SVa/4zpjLQ+2urHO/VelAjPnm6IWwM+MRg9OG8UZ4xuSXm4M0N1UwaCV68OW3jJAeaPZYDUEE1MFr+5qseHPGn39EhE1djDMnrXwz/uKurSdqaJTEZndLo7w8n5d8Q7/LlPnSWvrho5XzRVgOnID1DWNltXw=
Subject: [PATCH 02/14] drivers/char: replace remaining __FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:42 -0800
Message-Id: <1204600182.22933.82.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/agp/agp.h          |    2 +-
 drivers/char/cyclades.c         |    4 +-
 drivers/char/drm/drmP.h         |    8 +++---
 drivers/char/drm/drm_sysfs.c    |    2 +-
 drivers/char/drm/i830_dma.c     |   18 ++++++------
 drivers/char/drm/i830_drv.h     |    2 +-
 drivers/char/drm/i830_irq.c     |    8 +++---
 drivers/char/drm/i915_dma.c     |    8 +++---
 drivers/char/drm/i915_drv.h     |    2 +-
 drivers/char/drm/i915_irq.c     |    2 +-
 drivers/char/drm/radeon_cp.c    |    2 +-
 drivers/char/esp.c              |    4 +-
 drivers/char/generic_serial.c   |    4 +-
 drivers/char/hpet.c             |   10 +++---
 drivers/char/hvsi.c             |   52 +++++++++++++++++++-------------------
 drivers/char/nozomi.c           |    2 +-
 drivers/char/pcmcia/cm4000_cs.c |    2 +-
 drivers/char/pcmcia/cm4040_cs.c |    2 +-
 drivers/char/rio/rio_linux.h    |    6 ++--
 drivers/char/riscom8.c          |    4 +-
 drivers/char/snsc.c             |   18 ++++++------
 drivers/char/snsc_event.c       |    6 ++--
 drivers/char/sonypi.c           |    2 +-
 drivers/char/specialix.c        |   10 +++---
 drivers/char/sx.c               |    8 +++---
 25 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index c69f795..99e6a40 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -35,7 +35,7 @@
 
 //#define AGP_DEBUG 1
 #ifdef AGP_DEBUG
-#define DBG(x,y...) printk (KERN_DEBUG PFX "%s: " x "\n", __FUNCTION__ , ## y)
+#define DBG(x,y...) printk (KERN_DEBUG PFX "%s: " x "\n", __func__ , ## y)
 #else
 #define DBG(x,y...) do { } while (0)
 #endif
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index e4f579c..69c6043 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -3461,7 +3461,7 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 	struct BOARD_CTRL __iomem *board_ctrl;
 	struct CH_CTRL __iomem *ch_ctrl;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	card = info->card;
@@ -3528,7 +3528,7 @@ cy_tiocmset(struct tty_struct *tty, struct file *file,
 	struct CH_CTRL __iomem *ch_ctrl;
 	int retval;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	card = info->card;
diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index a6789f2..290cc5c 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -161,7 +161,7 @@ struct drm_device;
  * \param arg arguments
  */
 #define DRM_ERROR(fmt, arg...) \
-	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __FUNCTION__ , ##arg)
+	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
 
 /**
  * Memory error output.
@@ -171,7 +171,7 @@ struct drm_device;
  * \param arg arguments
  */
 #define DRM_MEM_ERROR(area, fmt, arg...) \
-	printk(KERN_ERR "[" DRM_NAME ":%s:%s] *ERROR* " fmt , __FUNCTION__, \
+	printk(KERN_ERR "[" DRM_NAME ":%s:%s] *ERROR* " fmt , __func__, \
 	       drm_mem_stats[area].name , ##arg)
 
 #define DRM_INFO(fmt, arg...)  printk(KERN_INFO "[" DRM_NAME "] " fmt , ##arg)
@@ -188,7 +188,7 @@ struct drm_device;
 		if ( drm_debug )			\
 			printk(KERN_DEBUG				\
 			       "[" DRM_NAME ":%s] " fmt ,	\
-			       __FUNCTION__ , ##arg);			\
+			       __func__ , ##arg);			\
 	} while (0)
 #else
 #define DRM_DEBUG(fmt, arg...)		 do { } while (0)
@@ -239,7 +239,7 @@ do {									\
 	if ( !_DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ) ||		\
 	     dev->lock.file_priv != file_priv )	{			\
 		DRM_ERROR( "%s called without lock held, held  %d owner %p %p\n",\
-			   __FUNCTION__, _DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ),\
+			   __func__, _DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ),\
 			   dev->lock.file_priv, file_priv );		\
 		return -EINVAL;						\
 	}								\
diff --git a/drivers/char/drm/drm_sysfs.c b/drivers/char/drm/drm_sysfs.c
index 05ed504..03e63fb 100644
--- a/drivers/char/drm/drm_sysfs.c
+++ b/drivers/char/drm/drm_sysfs.c
@@ -33,7 +33,7 @@ static int drm_sysfs_suspend(struct device *dev, pm_message_t state)
 {
 	struct drm_device *drm_dev = to_drm_device(dev);
 
-	printk(KERN_ERR "%s\n", __FUNCTION__);
+	printk(KERN_ERR "%s\n", __func__);
 
 	if (drm_dev->driver->suspend)
 		return drm_dev->driver->suspend(drm_dev, state);
diff --git a/drivers/char/drm/i830_dma.c b/drivers/char/drm/i830_dma.c
index 9df0810..78dc078 100644
--- a/drivers/char/drm/i830_dma.c
+++ b/drivers/char/drm/i830_dma.c
@@ -692,7 +692,7 @@ static void i830EmitState(struct drm_device * dev)
 	drm_i830_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
 
-	DRM_DEBUG("%s %x\n", __FUNCTION__, dirty);
+	DRM_DEBUG("%s %x\n", __func__, dirty);
 
 	if (dirty & I830_UPLOAD_BUFFERS) {
 		i830EmitDestVerified(dev, sarea_priv->BufferState);
@@ -1043,7 +1043,7 @@ static void i830_dma_dispatch_flip(struct drm_device * dev)
 	RING_LOCALS;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+		  __func__,
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);
 
@@ -1206,7 +1206,7 @@ static void i830_dma_quiescent(struct drm_device * dev)
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	i830_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	i830_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 }
 
 static int i830_flush_queue(struct drm_device * dev)
@@ -1223,7 +1223,7 @@ static int i830_flush_queue(struct drm_device * dev)
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	i830_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	i830_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 
 	for (i = 0; i < dma->buf_count; i++) {
 		struct drm_buf *buf = dma->buflist[i];
@@ -1344,7 +1344,7 @@ static void i830_do_init_pageflip(struct drm_device * dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 	dev_priv->page_flipping = 1;
 	dev_priv->current_page = 0;
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
@@ -1354,7 +1354,7 @@ static int i830_do_cleanup_pageflip(struct drm_device * dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 	if (dev_priv->current_page != 0)
 		i830_dma_dispatch_flip(dev);
 
@@ -1367,7 +1367,7 @@ static int i830_flip_bufs(struct drm_device *dev, void *data,
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
@@ -1437,7 +1437,7 @@ static int i830_getparam(struct drm_device *dev, void *data,
 	int value;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1464,7 +1464,7 @@ static int i830_setparam(struct drm_device *dev, void *data,
 	drm_i830_setparam_t *param = data;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/drivers/char/drm/i830_drv.h b/drivers/char/drm/i830_drv.h
index 4caba8c..b5bf8cc 100644
--- a/drivers/char/drm/i830_drv.h
+++ b/drivers/char/drm/i830_drv.h
@@ -158,7 +158,7 @@ extern int i830_driver_device_is_agp(struct drm_device * dev);
 	if (I830_VERBOSE)				\
 		printk("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < n*4)			\
-		i830_wait_ring(dev, n*4, __FUNCTION__);		\
+		i830_wait_ring(dev, n*4, __func__);		\
 	outcount = 0;					\
 	outring = dev_priv->ring.tail;			\
 	ringmask = dev_priv->ring.tail_mask;		\
diff --git a/drivers/char/drm/i830_irq.c b/drivers/char/drm/i830_irq.c
index a33db5f..91ec2bb 100644
--- a/drivers/char/drm/i830_irq.c
+++ b/drivers/char/drm/i830_irq.c
@@ -58,7 +58,7 @@ static int i830_emit_irq(struct drm_device * dev)
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	atomic_inc(&dev_priv->irq_emitted);
 
@@ -77,7 +77,7 @@ static int i830_wait_irq(struct drm_device * dev, int irq_nr)
 	unsigned long end = jiffies + HZ * 3;
 	int ret = 0;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	if (atomic_read(&dev_priv->irq_received) >= irq_nr)
 		return 0;
@@ -124,7 +124,7 @@ int i830_irq_emit(struct drm_device *dev, void *data,
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
@@ -147,7 +147,7 @@ int i830_irq_wait(struct drm_device *dev, void *data,
 	drm_i830_irq_wait_t *irqwait = data;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index e9d6663..40dc83c 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -194,7 +194,7 @@ static int i915_dma_resume(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	if (!dev_priv->sarea) {
 		DRM_ERROR("can not find sarea!\n");
@@ -517,7 +517,7 @@ static int i915_dispatch_flip(struct drm_device * dev)
 	RING_LOCALS;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+		  __func__,
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);
 
@@ -564,7 +564,7 @@ static int i915_quiescent(struct drm_device * dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
 	i915_kernel_lost_context(dev);
-	return i915_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	return i915_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 }
 
 static int i915_flush_ioctl(struct drm_device *dev, void *data,
@@ -642,7 +642,7 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 static int i915_flip_bufs(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
index c10d128..9c0214f 100644
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -263,7 +263,7 @@ extern void i915_mem_release(struct drm_device * dev,
 	if (I915_VERBOSE)				\
 		DRM_DEBUG("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < (n)*4)		\
-		i915_wait_ring(dev, (n)*4, __FUNCTION__);		\
+		i915_wait_ring(dev, (n)*4, __func__);		\
 	outcount = 0;					\
 	outring = dev_priv->ring.tail;			\
 	ringmask = dev_priv->ring.tail_mask;		\
diff --git a/drivers/char/drm/i915_irq.c b/drivers/char/drm/i915_irq.c
index 92653b3..ea4f381 100644
--- a/drivers/char/drm/i915_irq.c
+++ b/drivers/char/drm/i915_irq.c
@@ -223,7 +223,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 
 	temp &= (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);
 
-	DRM_DEBUG("%s flag=%08x\n", __FUNCTION__, temp);
+	DRM_DEBUG("%s flag=%08x\n", __func__, temp);
 
 	if (temp == 0)
 		return IRQ_NONE;
diff --git a/drivers/char/drm/radeon_cp.c b/drivers/char/drm/radeon_cp.c
index 833abc7..813b4ba 100644
--- a/drivers/char/drm/radeon_cp.c
+++ b/drivers/char/drm/radeon_cp.c
@@ -894,7 +894,7 @@ static u32 RADEON_READ_IGPGART(drm_radeon_private_t *dev_priv, int addr)
 #if RADEON_FIFO_DEBUG
 static void radeon_status(drm_radeon_private_t * dev_priv)
 {
-	printk("%s:\n", __FUNCTION__);
+	printk("%s:\n", __func__);
 	printk("RBBM_STATUS = 0x%08x\n",
 	       (unsigned int)RADEON_READ(RADEON_RBBM_STATUS));
 	printk("CP_RB_RTPR = 0x%08x\n",
diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index c01e26d..0043577 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -1680,7 +1680,7 @@ static int esp_tiocmget(struct tty_struct *tty, struct file *file)
 	unsigned char control, status;
 	unsigned long flags;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1706,7 +1706,7 @@ static int esp_tiocmset(struct tty_struct *tty, struct file *file,
 	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index 8facf3e..8befb35 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -41,8 +41,8 @@ static int gs_debug;
 #define gs_dprintk(f, str...) /* nothing */
 #endif
 
-#define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __FUNCTION__)
-#define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __FUNCTION__)
+#define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __func__)
+#define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __func__)
 
 #define RS_EVENT_WRITE_WAKEUP	1
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 465ad35..a5c4efb 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -308,7 +308,7 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 					PAGE_SIZE, vma->vm_page_prot)) {
 		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
-			__FUNCTION__);
+			__func__);
 		return -EAGAIN;
 	}
 
@@ -748,7 +748,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	 */
 	if (hpet_is_known(hdp)) {
 		printk(KERN_DEBUG "%s: duplicate HPET ignored\n",
-			__FUNCTION__);
+			__func__);
 		return 0;
 	}
 
@@ -906,7 +906,7 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__FUNCTION__, hdp->hd_phys_address);
+				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -923,7 +923,7 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__FUNCTION__, hdp->hd_phys_address);
+				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -962,7 +962,7 @@ static int hpet_acpi_add(struct acpi_device *device)
 		return -ENODEV;
 
 	if (!data.hd_address || !data.hd_nirqs) {
-		printk("%s: no address or irqs in _CRS\n", __FUNCTION__);
+		printk("%s: no address or irqs in _CRS\n", __func__);
 		return -ENODEV;
 	}
 
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index d5a752d..59c6f9a 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -246,7 +246,7 @@ static void compact_inbuf(struct hvsi_struct *hp, uint8_t *read_to)
 {
 	int remaining = (int)(hp->inbuf_end - read_to);
 
-	pr_debug("%s: %i chars remain\n", __FUNCTION__, remaining);
+	pr_debug("%s: %i chars remain\n", __func__, remaining);
 
 	if (read_to != hp->inbuf)
 		memmove(hp->inbuf, read_to, remaining);
@@ -365,7 +365,7 @@ static int hvsi_version_respond(struct hvsi_struct *hp, uint16_t query_seqno)
 	packet.u.version = HVSI_VERSION;
 	packet.query_seqno = query_seqno+1;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -437,7 +437,7 @@ static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
 		return NULL;
 
 	if (overflow > 0) {
-		pr_debug("%s: got >TTY_THRESHOLD_THROTTLE bytes\n", __FUNCTION__);
+		pr_debug("%s: got >TTY_THRESHOLD_THROTTLE bytes\n", __func__);
 		datalen = TTY_THRESHOLD_THROTTLE;
 	}
 
@@ -448,7 +448,7 @@ static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
 		 * we still have more data to deliver, so we need to save off the
 		 * overflow and send it later
 		 */
-		pr_debug("%s: deferring overflow\n", __FUNCTION__);
+		pr_debug("%s: deferring overflow\n", __func__);
 		memcpy(hp->throttle_buf, data + TTY_THRESHOLD_THROTTLE, overflow);
 		hp->n_throttle = overflow;
 	}
@@ -474,11 +474,11 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 
 	chunklen = hvsi_read(hp, hp->inbuf_end, HVSI_MAX_READ);
 	if (chunklen == 0) {
-		pr_debug("%s: 0-length read\n", __FUNCTION__);
+		pr_debug("%s: 0-length read\n", __func__);
 		return 0;
 	}
 
-	pr_debug("%s: got %i bytes\n", __FUNCTION__, chunklen);
+	pr_debug("%s: got %i bytes\n", __func__, chunklen);
 	dbg_dump_hex(hp->inbuf_end, chunklen);
 
 	hp->inbuf_end += chunklen;
@@ -495,7 +495,7 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 			continue;
 		}
 
-		pr_debug("%s: handling %i-byte packet\n", __FUNCTION__,
+		pr_debug("%s: handling %i-byte packet\n", __func__,
 				len_packet(packet));
 		dbg_dump_packet(packet);
 
@@ -526,7 +526,7 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 		packet += len_packet(packet);
 
 		if (*hangup || *handshake) {
-			pr_debug("%s: hangup or handshake\n", __FUNCTION__);
+			pr_debug("%s: hangup or handshake\n", __func__);
 			/*
 			 * we need to send the hangup now before receiving any more data.
 			 * If we get "data, hangup, data", we can't deliver the second
@@ -543,7 +543,7 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 
 static void hvsi_send_overflow(struct hvsi_struct *hp)
 {
-	pr_debug("%s: delivering %i bytes overflow\n", __FUNCTION__,
+	pr_debug("%s: delivering %i bytes overflow\n", __func__,
 			hp->n_throttle);
 
 	hvsi_insert_chars(hp, hp->throttle_buf, hp->n_throttle);
@@ -563,7 +563,7 @@ static irqreturn_t hvsi_interrupt(int irq, void *arg)
 	unsigned long flags;
 	int again = 1;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	while (again) {
 		spin_lock_irqsave(&hp->lock, flags);
@@ -647,7 +647,7 @@ static int hvsi_query(struct hvsi_struct *hp, uint16_t verb)
 	packet.seqno = atomic_inc_return(&hp->seqno);
 	packet.verb = verb;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -674,7 +674,7 @@ static int hvsi_get_mctrl(struct hvsi_struct *hp)
 		return ret;
 	}
 
-	pr_debug("%s: mctrl 0x%x\n", __FUNCTION__, hp->mctrl);
+	pr_debug("%s: mctrl 0x%x\n", __func__, hp->mctrl);
 
 	return 0;
 }
@@ -694,7 +694,7 @@ static int hvsi_set_mctrl(struct hvsi_struct *hp, uint16_t mctrl)
 	if (mctrl & TIOCM_DTR)
 		packet.word = HVSI_TSDTR;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -790,7 +790,7 @@ static void hvsi_close_protocol(struct hvsi_struct *hp)
 	packet.len = 6;
 	packet.verb = VSV_CLOSE_PROTOCOL;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -803,7 +803,7 @@ static int hvsi_open(struct tty_struct *tty, struct file *filp)
 	int line = tty->index;
 	int ret;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (line < 0 || line >= hvsi_count)
 		return -ENODEV;
@@ -868,7 +868,7 @@ static void hvsi_close(struct tty_struct *tty, struct file *filp)
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (tty_hung_up_p(filp))
 		return;
@@ -920,7 +920,7 @@ static void hvsi_hangup(struct tty_struct *tty)
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	spin_lock_irqsave(&hp->lock, flags);
 
@@ -942,7 +942,7 @@ static void hvsi_push(struct hvsi_struct *hp)
 	n = hvsi_put_chars(hp, hp->outbuf, hp->n_outbuf);
 	if (n > 0) {
 		/* success */
-		pr_debug("%s: wrote %i chars\n", __FUNCTION__, n);
+		pr_debug("%s: wrote %i chars\n", __func__, n);
 		hp->n_outbuf = 0;
 	} else if (n == -EIO) {
 		__set_state(hp, HVSI_FSP_DIED);
@@ -965,7 +965,7 @@ static void hvsi_write_worker(struct work_struct *work)
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	pr_debug("%s: %i chars in buffer\n", __FUNCTION__, hp->n_outbuf);
+	pr_debug("%s: %i chars in buffer\n", __func__, hp->n_outbuf);
 
 	if (!is_open(hp)) {
 		/*
@@ -983,7 +983,7 @@ static void hvsi_write_worker(struct work_struct *work)
 		schedule_delayed_work(&hp->writer, 10);
 	else {
 #ifdef DEBUG
-		pr_debug("%s: outbuf emptied after %li jiffies\n", __FUNCTION__,
+		pr_debug("%s: outbuf emptied after %li jiffies\n", __func__,
 				jiffies - start_j);
 		start_j = 0;
 #endif /* DEBUG */
@@ -1020,11 +1020,11 @@ static int hvsi_write(struct tty_struct *tty,
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	pr_debug("%s: %i chars in buffer\n", __FUNCTION__, hp->n_outbuf);
+	pr_debug("%s: %i chars in buffer\n", __func__, hp->n_outbuf);
 
 	if (!is_open(hp)) {
 		/* we're either closing or not yet open; don't accept data */
-		pr_debug("%s: not open\n", __FUNCTION__);
+		pr_debug("%s: not open\n", __func__);
 		goto out;
 	}
 
@@ -1058,7 +1058,7 @@ out:
 	spin_unlock_irqrestore(&hp->lock, flags);
 
 	if (total != origcount)
-		pr_debug("%s: wanted %i, only wrote %i\n", __FUNCTION__, origcount,
+		pr_debug("%s: wanted %i, only wrote %i\n", __func__, origcount,
 			total);
 
 	return total;
@@ -1072,7 +1072,7 @@ static void hvsi_throttle(struct tty_struct *tty)
 {
 	struct hvsi_struct *hp = (struct hvsi_struct *)tty->driver_data;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	h_vio_signal(hp->vtermno, VIO_IRQ_DISABLE);
 }
@@ -1083,7 +1083,7 @@ static void hvsi_unthrottle(struct tty_struct *tty)
 	unsigned long flags;
 	int shouldflip = 0;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->n_throttle) {
@@ -1302,7 +1302,7 @@ static int __init hvsi_console_init(void)
 		hp->virq = irq_create_mapping(NULL, irq[0]);
 		if (hp->virq == NO_IRQ) {
 			printk(KERN_ERR "%s: couldn't create irq mapping for 0x%x\n",
-				__FUNCTION__, irq[0]);
+				__func__, irq[0]);
 			continue;
 		}
 
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index dfaab23..1858ecb 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -73,7 +73,7 @@ do {								\
 	char tmp[P_BUF_SIZE];					\
 	snprintf(tmp, sizeof(tmp), ##args);			\
 	printk(_err_flag_ "[%d] %s(): %s\n", __LINE__,		\
-		__FUNCTION__, tmp);				\
+		__func__, tmp);				\
 } while (0)
 
 #define DBG1(args...) D_(0x01, ##args)
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 454d732..4a933d4 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -53,7 +53,7 @@ module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
 	if (pc_debug >= (n))						\
 		dev_printk(KERN_DEBUG, reader_to_dev(rdr), "%s:" x, 	\
-			   __FUNCTION__ , ## args);			\
+			   __func__ , ## args);			\
 	} while (0)
 #else
 #define DEBUGP(n, rdr, x, args...)
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 5f291bf..035084c 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -47,7 +47,7 @@ module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
 	if (pc_debug >= (n)) 						\
 		dev_printk(KERN_DEBUG, reader_to_dev(rdr), "%s:" x, 	\
-			   __FUNCTION__ , ##args); 			\
+			   __func__ , ##args); 			\
 	} while (0)
 #else
 #define DEBUGP(n, rdr, x, args...)
diff --git a/drivers/char/rio/rio_linux.h b/drivers/char/rio/rio_linux.h
index dc3f005..7f26cd7 100644
--- a/drivers/char/rio/rio_linux.h
+++ b/drivers/char/rio/rio_linux.h
@@ -186,9 +186,9 @@ static inline void *rio_memcpy_fromio(void *dest, void __iomem *source, int n)
 
 #ifdef DEBUG
 #define rio_dprintk(f, str...) do { if (rio_debug & f) printk (str);} while (0)
-#define func_enter() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s\n", __FUNCTION__)
-#define func_exit()  rio_dprintk (RIO_DEBUG_FLOW, "rio: exit  %s\n", __FUNCTION__)
-#define func_enter2() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s (port %d)\n",__FUNCTION__, port->line)
+#define func_enter() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s\n", __func__)
+#define func_exit()  rio_dprintk (RIO_DEBUG_FLOW, "rio: exit  %s\n", __func__)
+#define func_enter2() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s (port %d)\n",__func__, port->line)
 #else
 #define rio_dprintk(f, str...)	/* nothing */
 #define func_enter()
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 8fc4fe4..e4f6c4c 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1238,7 +1238,7 @@ static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 	unsigned int result;
 	unsigned long flags;
 
-	if (rc_paranoia_check(port, tty->name, __FUNCTION__))
+	if (rc_paranoia_check(port, tty->name, __func__))
 		return -ENODEV;
 
 	bp = port_Board(port);
@@ -1266,7 +1266,7 @@ static int rc_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned long flags;
 	struct riscom_board *bp;
 
-	if (rc_paranoia_check(port, tty->name, __FUNCTION__))
+	if (rc_paranoia_check(port, tty->name, __func__))
 		return -ENODEV;
 
 	bp = port_Board(port);
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index b9c1dba..8fe099a 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -80,7 +80,7 @@ scdrv_open(struct inode *inode, struct file *file)
 	sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
 	if (sd == NULL) {
 		printk("%s: couldn't allocate subchannel data\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENOMEM;
 	}
 
@@ -90,7 +90,7 @@ scdrv_open(struct inode *inode, struct file *file)
 
 	if (sd->sd_subch < 0) {
 		kfree(sd);
-		printk("%s: couldn't allocate subchannel\n", __FUNCTION__);
+		printk("%s: couldn't allocate subchannel\n", __func__);
 		return -EBUSY;
 	}
 
@@ -110,7 +110,7 @@ scdrv_open(struct inode *inode, struct file *file)
 	if (rv) {
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
 		kfree(sd);
-		printk("%s: irq request failed (%d)\n", __FUNCTION__, rv);
+		printk("%s: irq request failed (%d)\n", __func__, rv);
 		return -EBUSY;
 	}
 
@@ -215,7 +215,7 @@ scdrv_read(struct file *file, char __user *buf, size_t count, loff_t *f_pos)
 		 */
 		if (count < len) {
 			pr_debug("%s: only accepting %d of %d bytes\n",
-				 __FUNCTION__, (int) count, len);
+				 __func__, (int) count, len);
 		}
 		len = min((int) count, len);
 		if (copy_to_user(buf, sd->sd_rb, len))
@@ -384,7 +384,7 @@ scdrv_init(void)
 	if (alloc_chrdev_region(&first_dev, 0, num_cnodes,
 				SYSCTL_BASENAME) < 0) {
 		printk("%s: failed to register SN system controller device\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENODEV;
 	}
 	snsc_class = class_create(THIS_MODULE, SYSCTL_BASENAME);
@@ -403,7 +403,7 @@ scdrv_init(void)
 				      GFP_KERNEL);
 			if (!scd) {
 				printk("%s: failed to allocate device info"
-				       "for %s/%s\n", __FUNCTION__,
+				       "for %s/%s\n", __func__,
 				       SYSCTL_BASENAME, devname);
 				continue;
 			}
@@ -412,7 +412,7 @@ scdrv_init(void)
 			scd->scd_nasid = cnodeid_to_nasid(cnode);
 			if (!(salbuf = kmalloc(SCDRV_BUFSZ, GFP_KERNEL))) {
 				printk("%s: failed to allocate driver buffer"
-				       "(%s%s)\n", __FUNCTION__,
+				       "(%s%s)\n", __func__,
 				       SYSCTL_BASENAME, devname);
 				kfree(scd);
 				continue;
@@ -424,7 +424,7 @@ scdrv_init(void)
 				    ("%s: failed to initialize SAL for"
 				     " system controller communication"
 				     " (%s/%s): outdated PROM?\n",
-				     __FUNCTION__, SYSCTL_BASENAME, devname);
+				     __func__, SYSCTL_BASENAME, devname);
 				kfree(scd);
 				kfree(salbuf);
 				continue;
@@ -435,7 +435,7 @@ scdrv_init(void)
 			if (cdev_add(&scd->scd_cdev, dev, 1)) {
 				printk("%s: failed to register system"
 				       " controller device (%s%s)\n",
-				       __FUNCTION__, SYSCTL_BASENAME, devname);
+				       __func__, SYSCTL_BASENAME, devname);
 				kfree(scd);
 				kfree(salbuf);
 				continue;
diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
index 1b75b0b..47bbbd8 100644
--- a/drivers/char/snsc_event.c
+++ b/drivers/char/snsc_event.c
@@ -275,7 +275,7 @@ scdrv_event_init(struct sysctl_data_s *scd)
 	event_sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
 	if (event_sd == NULL) {
 		printk(KERN_WARNING "%s: couldn't allocate subchannel info"
-		       " for event monitoring\n", __FUNCTION__);
+		       " for event monitoring\n", __func__);
 		return;
 	}
 
@@ -289,7 +289,7 @@ scdrv_event_init(struct sysctl_data_s *scd)
 	if (event_sd->sd_subch < 0) {
 		kfree(event_sd);
 		printk(KERN_WARNING "%s: couldn't open event subchannel\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
@@ -299,7 +299,7 @@ scdrv_event_init(struct sysctl_data_s *scd)
 			 "system controller events", event_sd);
 	if (rv) {
 		printk(KERN_WARNING "%s: irq request failed (%d)\n",
-		       __FUNCTION__, rv);
+		       __func__, rv);
 		ia64_sn_irtr_close(event_sd->sd_nasid, event_sd->sd_subch);
 		kfree(event_sd);
 		return;
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 921c6d2..2e06fa3 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -506,7 +506,7 @@ static struct sonypi_device {
 	while (--n && (command)) \
 		udelay(1); \
 	if (!n && (verbose || !quiet)) \
-		printk(KERN_WARNING "sonypi command failed at %s : %s (line %d)\n", __FILE__, __FUNCTION__, __LINE__); \
+		printk(KERN_WARNING "sonypi command failed at %s : %s (line %d)\n", __FILE__, __func__, __LINE__); \
 }
 
 #ifdef CONFIG_ACPI
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index c0e08c7..b1ec1a2 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -131,8 +131,8 @@ static int sx_rxfifo = SPECIALIX_RXFIFO;
 #define SX_DEBUG_FIFO    0x0800
 

-#define func_enter() dprintk (SX_DEBUG_FLOW, "io8: enter %s\n",__FUNCTION__)
-#define func_exit()  dprintk (SX_DEBUG_FLOW, "io8: exit  %s\n", __FUNCTION__)
+#define func_enter() dprintk (SX_DEBUG_FLOW, "io8: enter %s\n",__func__)
+#define func_exit()  dprintk (SX_DEBUG_FLOW, "io8: exit  %s\n", __func__)
 
 #define jiffies_from_ms(a) ((((a) * HZ)/1000)+1)
 
@@ -876,7 +876,7 @@ static irqreturn_t sx_interrupt(int irq, void *dev_id)
 	bp = dev_id;
 	spin_lock_irqsave(&bp->lock, flags);
 
-	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
+	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __func__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
 		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", irq);
 		spin_unlock_irqrestore(&bp->lock, flags);
@@ -1805,7 +1805,7 @@ static int sx_tiocmget(struct tty_struct *tty, struct file *file)
 
 	func_enter();
 
-	if (sx_paranoia_check(port, tty->name, __FUNCTION__)) {
+	if (sx_paranoia_check(port, tty->name, __func__)) {
 		func_exit();
 		return -ENODEV;
 	}
@@ -1847,7 +1847,7 @@ static int sx_tiocmset(struct tty_struct *tty, struct file *file,
 
 	func_enter();
 
-	if (sx_paranoia_check(port, tty->name, __FUNCTION__)) {
+	if (sx_paranoia_check(port, tty->name, __func__)) {
 		func_exit();
 		return -ENODEV;
 	}
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a6e1c9b..4da4c39 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -384,11 +384,11 @@ static struct real_driver sx_real_driver = {
 #define sx_dprintk(f, str...)	/* nothing */
 #endif
 
-#define func_enter()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s\n",__FUNCTION__)
-#define func_exit()	sx_dprintk(SX_DEBUG_FLOW, "sx: exit  %s\n",__FUNCTION__)
+#define func_enter()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s\n",__func__)
+#define func_exit()	sx_dprintk(SX_DEBUG_FLOW, "sx: exit  %s\n",__func__)
 
 #define func_enter2()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s (port %d)\n", \
-				__FUNCTION__, port->line)
+				__func__, port->line)
 
 /* 
  *  Firmware loader driver specific routines
@@ -1574,7 +1574,7 @@ static void sx_close(void *ptr)
 		sx_dprintk(SX_DEBUG_CLOSE, "WARNING port count:%d\n",
 				port->gs.count);
 		/*printk("%s SETTING port count to zero: %p count: %d\n",
-				__FUNCTION__, port, port->gs.count);
+				__func__, port, port->gs.count);
 		port->gs.count = 0;*/
 	}
 
-- 
1.5.4.3.500.g83a2c


