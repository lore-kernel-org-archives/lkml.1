Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZCWKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZCWKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZCWKKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:10:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:44701 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757521AbZCWKKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:10:48 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+nid8sCE6nrenN2MeNGrtmrhXVCFSNHtrSQe/OwX
	tE2Nsk66Dx+TPx
Date: Mon, 23 Mar 2009 11:10:52 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/3 v2] dma: ipu_idmac driver cosmetic clean-up
In-Reply-To: <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
Message-ID: <Pine.LNX.4.64.0903231107290.4871@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
 <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
 <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superfluous semicolons, update comments.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/dma/ipu/ipu_idmac.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index ae50a9d..e929ef3 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -107,7 +107,7 @@ static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
 	}
 }
 
-/* Enable / disable direct write to memory by the Camera Sensor Interface */
+/* Enable direct write to memory by the Camera Sensor Interface */
 static void ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
 {
 	uint32_t ic_conf, mask;
@@ -126,6 +126,7 @@ static void ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
 	idmac_write_icreg(ipu, ic_conf, IC_CONF);
 }
 
+/* Called under spin_lock_irqsave(&ipu_data.lock) */
 static void ipu_ic_disable_task(struct ipu *ipu, enum ipu_channel channel)
 {
 	uint32_t ic_conf, mask;
@@ -422,7 +423,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		break;
 	default:
 		dev_err(ipu_data.dev,
-			"mxc ipu: unimplemented pixel format %d\n", pixel_fmt);
+			"mx3 ipu: unimplemented pixel format %d\n", pixel_fmt);
 		break;
 	}
 
@@ -433,20 +434,20 @@ static void ipu_ch_param_set_burst_size(union chan_param_mem *params,
 					uint16_t burst_pixels)
 {
 	params->pp.npb = burst_pixels - 1;
-};
+}
 
 static void ipu_ch_param_set_buffer(union chan_param_mem *params,
 				    dma_addr_t buf0, dma_addr_t buf1)
 {
 	params->pp.eba0 = buf0;
 	params->pp.eba1 = buf1;
-};
+}
 
 static void ipu_ch_param_set_rotation(union chan_param_mem *params,
 				      enum ipu_rotate_mode rotate)
 {
 	params->pp.bam = rotate;
-};
+}
 
 static void ipu_write_param_mem(uint32_t addr, uint32_t *data,
 				uint32_t num_words)
@@ -571,7 +572,7 @@ static uint32_t dma_param_addr(uint32_t dma_ch)
 {
 	/* Channel Parameter Memory */
 	return 0x10000 | (dma_ch << 4);
-};
+}
 
 static void ipu_channel_set_priority(struct ipu *ipu, enum ipu_channel channel,
 				     bool prio)
@@ -611,7 +612,8 @@ static uint32_t ipu_channel_conf_mask(enum ipu_channel channel)
 
 /**
  * ipu_enable_channel() - enable an IPU channel.
- * @channel:	channel ID.
+ * @idmac:	IPU DMAC context.
+ * @ichan:	IDMAC channel.
  * @return:	0 on success or negative error code on failure.
  */
 static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
@@ -649,7 +651,7 @@ static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
 
 /**
  * ipu_init_channel_buffer() - initialize a buffer for logical IPU channel.
- * @channel:	channel ID.
+ * @ichan:	IDMAC channel.
  * @pixel_fmt:	pixel format of buffer. Pixel format is a FOURCC ASCII code.
  * @width:	width of buffer in pixels.
  * @height:	height of buffer in pixels.
@@ -687,7 +689,7 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 	}
 
 	/* IC channel's stride must be a multiple of 8 pixels */
-	if ((channel <= 13) && (stride % 8)) {
+	if ((channel <= IDMAC_IC_13) && (stride % 8)) {
 		dev_err(ipu->dev, "Stride must be 8 pixel multiple\n");
 		return -EINVAL;
 	}
@@ -752,7 +754,7 @@ static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
 
 /**
  * ipu_update_channel_buffer() - update physical address of a channel buffer.
- * @channel:	channel ID.
+ * @ichan:	IDMAC channel.
  * @buffer_n:	buffer number to update.
  *		0 or 1 are the only valid values.
  * @phyaddr:	buffer physical address.
@@ -1341,13 +1343,7 @@ static void ipu_gc_tasklet(unsigned long arg)
 	}
 }
 
-/*
- * At the time .device_alloc_chan_resources() method is called, we cannot know,
- * whether the client will accept the channel. Thus we must only check, if we
- * can satisfy client's request but the only real criterion to verify, whether
- * the client has accepted our offer is the client_count. That's why we have to
- * perform the rest of our allocation tasks on the first call to this function.
- */
+/* Allocate and initialise a transfer descriptor. */
 static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
 		struct scatterlist *sgl, unsigned int sg_len,
 		enum dma_data_direction direction, unsigned long tx_flags)
@@ -1432,8 +1428,7 @@ static void __idmac_terminate_all(struct dma_chan *chan)
 			struct idmac_tx_desc *desc = ichan->desc + i;
 			if (list_empty(&desc->list))
 				/* Descriptor was prepared, but not submitted */
-				list_add(&desc->list,
-					 &ichan->free_list);
+				list_add(&desc->list, &ichan->free_list);
 
 			async_tx_clear_ack(&desc->txd);
 		}
-- 
1.5.4

