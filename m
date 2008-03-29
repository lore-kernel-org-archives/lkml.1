Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYC2DHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYC2DHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYC2DHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:07:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49709 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbYC2DHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:07:39 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] NULL noise: drivers/media
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org
Message-Id: <E1JfRPu-0002Xh-I3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:07:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
 drivers/media/common/saa7146_core.c          |   13 +++++--------
 drivers/media/common/saa7146_fops.c          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c         |    4 ++--
 drivers/media/video/adv7170.c                |    2 +-
 drivers/media/video/adv7175.c                |    2 +-
 drivers/media/video/bt819.c                  |    2 +-
 drivers/media/video/bt856.c                  |    2 +-
 drivers/media/video/dpc7146.c                |    2 +-
 drivers/media/video/mt20xx.c                 |    2 +-
 drivers/media/video/mxb.c                    |    5 ++---
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c   |    4 ++--
 drivers/media/video/pvrusb2/pvrusb2-hdw.c    |    6 +++---
 drivers/media/video/pvrusb2/pvrusb2-io.c     |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-ioread.c |    2 +-
 drivers/media/video/pwc/pwc-if.c             |    7 +++----
 drivers/media/video/saa7110.c                |    4 ++--
 drivers/media/video/saa7111.c                |    2 +-
 drivers/media/video/saa7114.c                |    2 +-
 drivers/media/video/saa7185.c                |    2 +-
 drivers/media/video/tda9840.c                |    2 +-
 drivers/media/video/tea6415c.c               |    2 +-
 drivers/media/video/tea6420.c                |    2 +-
 drivers/media/video/tvp5150.c                |    4 ++--
 drivers/media/video/zoran_driver.c           |    2 +-
 24 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 168a8d3..7707b8c 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -306,25 +306,22 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	if( 0 != (dev->ext)) {
-		if( 0 != (dev->ext->irq_mask & isr )) {
-			if( 0 != dev->ext->irq_func ) {
+	if (dev->ext) {
+		if (dev->ext->irq_mask & isr) {
+			if (dev->ext->irq_func)
 				dev->ext->irq_func(dev, &isr);
-			}
 			isr &= ~dev->ext->irq_mask;
 		}
 	}
 	if (0 != (isr & (MASK_27))) {
 		DEB_INT(("irq: RPS0 (0x%08x).\n",isr));
-		if( 0 != dev->vv_data && 0 != dev->vv_callback) {
+		if (dev->vv_data && dev->vv_callback)
 			dev->vv_callback(dev,isr);
-		}
 		isr &= ~MASK_27;
 	}
 	if (0 != (isr & (MASK_28))) {
-		if( 0 != dev->vv_data && 0 != dev->vv_callback) {
+		if (dev->vv_data && dev->vv_callback)
 			dev->vv_callback(dev,isr);
-		}
 		isr &= ~MASK_28;
 	}
 	if (0 != (isr & (MASK_16|MASK_17))) {
diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index f0703d8..171afe7 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -272,7 +272,7 @@ static int fops_open(struct inode *inode, struct file *file)
 
 	result = 0;
 out:
-	if( fh != 0 && result != 0 ) {
+	if (fh && result != 0) {
 		kfree(fh);
 		file->private_data = NULL;
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index ed3f826..4c8b62e 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -784,8 +784,8 @@ static int dvb_net_ts_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct net_device *dev = feed->priv;
 
-	if (buffer2 != 0)
-		printk(KERN_WARNING "buffer2 not 0: %p.\n", buffer2);
+	if (buffer2)
+		printk(KERN_WARNING "buffer2 not NULL: %p.\n", buffer2);
 	if (buffer1_len > 32768)
 		printk(KERN_WARNING "length > 32k: %zu.\n", buffer1_len);
 	/* printk("TS callback: %u bytes, %u TS cells @ %p.\n",
diff --git a/drivers/media/video/adv7170.c b/drivers/media/video/adv7170.c
index cbab53f..fea2e72 100644
--- a/drivers/media/video/adv7170.c
+++ b/drivers/media/video/adv7170.c
@@ -408,7 +408,7 @@ adv7170_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index 0d0c554..10d4d89 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -426,7 +426,7 @@ adv7175_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index 12d1b92..e663cc0 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -524,7 +524,7 @@ bt819_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/bt856.c b/drivers/media/video/bt856.c
index e1028a7..7dee2e3 100644
--- a/drivers/media/video/bt856.c
+++ b/drivers/media/video/bt856.c
@@ -311,7 +311,7 @@ bt856_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/dpc7146.c b/drivers/media/video/dpc7146.c
index 566e479..9ceb6b2 100644
--- a/drivers/media/video/dpc7146.c
+++ b/drivers/media/video/dpc7146.c
@@ -131,7 +131,7 @@ static int dpc_probe(struct saa7146_dev* dev)
 	device_for_each_child(&dpc->i2c_adapter.dev, dpc, dpc_check_clients);
 
 	/* check if all devices are present */
-	if( 0 == dpc->saa7111a ) {
+	if (!dpc->saa7111a) {
 		DEB_D(("dpc_v4l2.o: dpc_attach failed for this device.\n"));
 		i2c_del_adapter(&dpc->i2c_adapter);
 		kfree(dpc);
diff --git a/drivers/media/video/mt20xx.c b/drivers/media/video/mt20xx.c
index 58bab65..74fd6a0 100644
--- a/drivers/media/video/mt20xx.c
+++ b/drivers/media/video/mt20xx.c
@@ -647,7 +647,7 @@ struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 	default:
 		tuner_info("microtune %s found, not (yet?) supported, sorry :-/\n",
 			   name);
-		return 0;
+		return NULL;
 	}
 
 	strlcpy(fe->ops.tuner_ops.info.name, name,
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index add6d0d..cb5a510 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -221,9 +221,8 @@ static int mxb_probe(struct saa7146_dev* dev)
 	device_for_each_child(&mxb->i2c_adapter.dev, mxb, mxb_check_clients);
 
 	/* check if all devices are present */
-	if(    0 == mxb->tea6420_1	|| 0 == mxb->tea6420_2	|| 0 == mxb->tea6415c
-	    || 0 == mxb->tda9840	|| 0 == mxb->saa7111a	|| 0 == mxb->tuner ) {
-
+	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
+	    !mxb->tda9840 || !mxb->saa7111a || !mxb->tuner) {
 		printk("mxb: did not find all i2c devices. aborting\n");
 		i2c_del_adapter(&mxb->i2c_adapter);
 		kfree(mxb);
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
index 46f156f..5a3e8d2 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -60,7 +60,7 @@ int pvr2_ctrl_set_mask_value(struct pvr2_ctrl *cptr,int mask,int val)
 	int ret = 0;
 	if (!cptr) return -EINVAL;
 	LOCK_TAKE(cptr->hdw->big_lock); do {
-		if (cptr->info->set_value != 0) {
+		if (cptr->info->set_value) {
 			if (cptr->info->type == pvr2_ctl_bitmask) {
 				mask &= cptr->info->def.type_bitmask.valid_bits;
 			} else if (cptr->info->type == pvr2_ctl_int) {
@@ -265,7 +265,7 @@ unsigned int pvr2_ctrl_get_v4lflags(struct pvr2_ctrl *cptr)
 int pvr2_ctrl_is_writable(struct pvr2_ctrl *cptr)
 {
 	if (!cptr) return 0;
-	return cptr->info->set_value != 0;
+	return cptr->info->set_value != NULL;
 }
 
 
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 41ae980..d6955fa 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -2291,7 +2291,7 @@ static int pvr2_hdw_commit_setup(struct pvr2_hdw *hdw)
 
 	for (idx = 0; idx < hdw->control_cnt; idx++) {
 		cptr = hdw->controls + idx;
-		if (cptr->info->is_dirty == 0) continue;
+		if (!cptr->info->is_dirty) continue;
 		if (!cptr->info->is_dirty(cptr)) continue;
 		commit_flag = !0;
 
@@ -2646,7 +2646,7 @@ void pvr2_hdw_cpufw_set_enabled(struct pvr2_hdw *hdw,
 	u16 address;
 	unsigned int pipe;
 	LOCK_TAKE(hdw->big_lock); do {
-		if ((hdw->fw_buffer == 0) == !enable_flag) break;
+		if ((hdw->fw_buffer == NULL) == !enable_flag) break;
 
 		if (!enable_flag) {
 			pvr2_trace(PVR2_TRACE_FIRMWARE,
@@ -2715,7 +2715,7 @@ void pvr2_hdw_cpufw_set_enabled(struct pvr2_hdw *hdw,
 /* Return true if we're in a mode for retrieval CPU firmware */
 int pvr2_hdw_cpufw_get_enabled(struct pvr2_hdw *hdw)
 {
-	return hdw->fw_buffer != 0;
+	return hdw->fw_buffer != NULL;
 }
 
 
diff --git a/drivers/media/video/pvrusb2/pvrusb2-io.c b/drivers/media/video/pvrusb2/pvrusb2-io.c
index ce3c898..a9889ff 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-io.c
@@ -563,7 +563,7 @@ void pvr2_stream_kill(struct pvr2_stream *sp)
 	struct pvr2_buffer *bp;
 	mutex_lock(&sp->mutex); do {
 		pvr2_stream_internal_flush(sp);
-		while ((bp = pvr2_stream_get_ready_buffer(sp)) != 0) {
+		while ((bp = pvr2_stream_get_ready_buffer(sp)) != NULL) {
 			pvr2_buffer_set_idle(bp);
 		}
 		if (sp->buffer_total_count != sp->buffer_target_count) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.c b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
index f782418..c572212 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
@@ -165,7 +165,7 @@ static int pvr2_ioread_start(struct pvr2_ioread *cp)
 	if (!(cp->stream)) return 0;
 	pvr2_trace(PVR2_TRACE_START_STOP,
 		   "/*---TRACE_READ---*/ pvr2_ioread_start id=%p",cp);
-	while ((bp = pvr2_stream_get_idle_buffer(cp->stream)) != 0) {
+	while ((bp = pvr2_stream_get_idle_buffer(cp->stream)) != NULL) {
 		stat = pvr2_buffer_queue(bp);
 		if (stat < 0) {
 			pvr2_trace(PVR2_TRACE_DATA_FLOW,
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f991d72..e0a453a 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -915,7 +915,7 @@ static void pwc_iso_stop(struct pwc_device *pdev)
 		struct urb *urb;
 
 		urb = pdev->sbuf[i].urb;
-		if (urb != 0) {
+		if (urb) {
 			PWC_DEBUG_MEMORY("Unlinking URB %p\n", urb);
 			usb_kill_urb(urb);
 		}
@@ -931,7 +931,7 @@ static void pwc_iso_free(struct pwc_device *pdev)
 		struct urb *urb;
 
 		urb = pdev->sbuf[i].urb;
-		if (urb != 0) {
+		if (urb) {
 			PWC_DEBUG_MEMORY("Freeing URB\n");
 			usb_free_urb(urb);
 			pdev->sbuf[i].urb = NULL;
@@ -1759,8 +1759,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 
 	/* Allocate video_device structure */
 	pdev->vdev = video_device_alloc();
-	if (pdev->vdev == 0)
-	{
+	if (!pdev->vdev) {
 		PWC_ERROR("Err, cannot allocate video_device struture. Failing probe.");
 		kfree(pdev);
 		return -ENOMEM;
diff --git a/drivers/media/video/saa7110.c b/drivers/media/video/saa7110.c
index 061134a..1df2602 100644
--- a/drivers/media/video/saa7110.c
+++ b/drivers/media/video/saa7110.c
@@ -488,7 +488,7 @@ saa7110_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
@@ -496,7 +496,7 @@ saa7110_detect_client (struct i2c_adapter *adapter,
 	strlcpy(I2C_NAME(client), "saa7110", sizeof(I2C_NAME(client)));
 
 	decoder = kzalloc(sizeof(struct saa7110), GFP_KERNEL);
-	if (decoder == 0) {
+	if (!decoder) {
 		kfree(client);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/video/saa7111.c b/drivers/media/video/saa7111.c
index 7ae2d64..a0772c5 100644
--- a/drivers/media/video/saa7111.c
+++ b/drivers/media/video/saa7111.c
@@ -502,7 +502,7 @@ saa7111_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/saa7114.c b/drivers/media/video/saa7114.c
index 677df51..bf91a4f 100644
--- a/drivers/media/video/saa7114.c
+++ b/drivers/media/video/saa7114.c
@@ -841,7 +841,7 @@ saa7114_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/saa7185.c b/drivers/media/video/saa7185.c
index 66cc92c..41f7044 100644
--- a/drivers/media/video/saa7185.c
+++ b/drivers/media/video/saa7185.c
@@ -403,7 +403,7 @@ saa7185_detect_client (struct i2c_adapter *adapter,
 		return 0;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 	client->addr = address;
 	client->adapter = adapter;
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index ef494fe..bdca5d2 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -172,7 +172,7 @@ static int detect(struct i2c_adapter *adapter, int address, int kind)
 
 	/* allocate memory for client structure */
 	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (0 == client) {
+	if (!client) {
 		printk("not enough kernel memory\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 523df0b..df2fad9 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -64,7 +64,7 @@ static int detect(struct i2c_adapter *adapter, int address, int kind)
 
 	/* allocate memory for client structure */
 	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (0 == client) {
+	if (!client) {
 		return -ENOMEM;
 	}
 
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index ca05cd6..4ff6c63 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -101,7 +101,7 @@ static int tea6420_detect(struct i2c_adapter *adapter, int address, int kind)
 
 	/* allocate memory for client structure */
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (0 == client) {
+	if (!client) {
 		return -ENOMEM;
 	}
 
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index d28318c..b6e24e7 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -1072,12 +1072,12 @@ static int tvp5150_detect_client(struct i2c_adapter *adapter,
 		return 0;
 
 	c = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (c == 0)
+	if (!c)
 		return -ENOMEM;
 	memcpy(c, &client_template, sizeof(struct i2c_client));
 
 	core = kzalloc(sizeof(struct tvp5150), GFP_KERNEL);
-	if (core == 0) {
+	if (!core) {
 		kfree(c);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index dd3d7d2..fea4946 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -339,7 +339,7 @@ v4l_fbuffer_alloc (struct file *file)
 			/* Use kmalloc */
 
 			mem = kmalloc(fh->v4l_buffers.buffer_size, GFP_KERNEL);
-			if (mem == 0) {
+			if (!mem) {
 				dprintk(1,
 					KERN_ERR
 					"%s: v4l_fbuffer_alloc() - kmalloc for V4L buf %d failed\n",
-- 
1.5.3.GIT


