Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYCXTyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYCXTyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYCXTya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:54:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51872 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYCXTy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:54:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:52:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] ieee1394: ohci1394: refactor some printk format strings
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3b27f4ba701fc1ec@s5r6.in-berlin.de>
Message-ID: <tkrat.525e96701f0759f9@s5r6.in-berlin.de>
References: <tkrat.3b27f4ba701fc1ec@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to reduce the size of ohci1394.ko.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -149,7 +149,7 @@ printk(level "%s: fw-host%d: " fmt "\n" 
 /* Module Parameters */
 static int phys_dma = 1;
 module_param(phys_dma, int, 0444);
-MODULE_PARM_DESC(phys_dma, "Enable physical dma (default = 1).");
+MODULE_PARM_DESC(phys_dma, "Enable physical DMA (default = 1).");
 
 static void dma_trm_tasklet(unsigned long data);
 static void dma_trm_reset(struct dma_trm_ctx *d);
@@ -2785,7 +2785,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 	d->buf_bus = kzalloc(d->num_desc * sizeof(*d->buf_bus), GFP_ATOMIC);
 
 	if (d->buf_cpu == NULL || d->buf_bus == NULL) {
-		PRINT(KERN_ERR, "Failed to allocate dma buffer");
+		PRINT(KERN_ERR, "Failed to allocate %s", "DMA buffer");
 		free_dma_rcv_ctx(d);
 		return -ENOMEM;
 	}
@@ -2794,7 +2794,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 	d->prg_bus = kzalloc(d->num_desc * sizeof(*d->prg_bus), GFP_ATOMIC);
 
 	if (d->prg_cpu == NULL || d->prg_bus == NULL) {
-		PRINT(KERN_ERR, "Failed to allocate dma prg");
+		PRINT(KERN_ERR, "Failed to allocate %s", "DMA prg");
 		free_dma_rcv_ctx(d);
 		return -ENOMEM;
 	}
@@ -2802,7 +2802,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 	d->spb = kmalloc(d->split_buf_size, GFP_ATOMIC);
 
 	if (d->spb == NULL) {
-		PRINT(KERN_ERR, "Failed to allocate split buffer");
+		PRINT(KERN_ERR, "Failed to allocate %s", "split buffer");
 		free_dma_rcv_ctx(d);
 		return -ENOMEM;
 	}
@@ -2828,7 +2828,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 			memset(d->buf_cpu[i], 0, d->buf_size);
 		} else {
 			PRINT(KERN_ERR,
-			      "Failed to allocate dma buffer");
+			      "Failed to allocate %s", "DMA buffer");
 			free_dma_rcv_ctx(d);
 			return -ENOMEM;
 		}
@@ -2839,7 +2839,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
                         memset(d->prg_cpu[i], 0, sizeof(struct dma_cmd));
 		} else {
 			PRINT(KERN_ERR,
-			      "Failed to allocate dma prg");
+			      "Failed to allocate %s", "DMA prg");
 			free_dma_rcv_ctx(d);
 			return -ENOMEM;
 		}
@@ -2900,7 +2900,7 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, 
 	d->prg_bus = kzalloc(d->num_desc * sizeof(*d->prg_bus), GFP_KERNEL);
 
 	if (d->prg_cpu == NULL || d->prg_bus == NULL) {
-		PRINT(KERN_ERR, "Failed to allocate at dma prg");
+		PRINT(KERN_ERR, "Failed to allocate %s", "AT DMA prg");
 		free_dma_trm_ctx(d);
 		return -ENOMEM;
 	}
@@ -2923,7 +2923,7 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, 
                         memset(d->prg_cpu[i], 0, sizeof(struct at_dma_prg));
 		} else {
 			PRINT(KERN_ERR,
-			      "Failed to allocate at dma prg");
+			      "Failed to allocate %s", "AT DMA prg");
 			free_dma_trm_ctx(d);
 			return -ENOMEM;
 		}
@@ -3031,7 +3031,7 @@ static int __devinit ohci1394_pci_probe(
 
 	host = hpsb_alloc_host(&ohci1394_driver, sizeof(struct ti_ohci), &dev->dev);
 	if (!host) {
-		PRINT_G(KERN_ERR, "Failed to allocate host structure");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "host structure");
 		goto err;
 	}
 	ohci = host->hostdata;
@@ -3104,7 +3104,7 @@ static int __devinit ohci1394_pci_probe(
 		pci_alloc_consistent(ohci->dev, OHCI_CONFIG_ROM_LEN,
 				     &ohci->csr_config_rom_bus);
 	if (ohci->csr_config_rom_cpu == NULL) {
-		PRINT_G(KERN_ERR, "Failed to allocate buffer config rom");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "buffer config rom");
 		goto err;
 	}
 	ohci->init_state = OHCI_INIT_HAVE_CONFIG_ROM_BUFFER;
@@ -3114,7 +3114,7 @@ static int __devinit ohci1394_pci_probe(
 		pci_alloc_consistent(ohci->dev, OHCI1394_SI_DMA_BUF_SIZE,
                       &ohci->selfid_buf_bus);
 	if (ohci->selfid_buf_cpu == NULL) {
-		PRINT_G(KERN_ERR, "Failed to allocate self-ID buffer");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "self-ID buffer");
 		goto err;
 	}
 	ohci->init_state = OHCI_INIT_HAVE_SELFID_BUFFER;
@@ -3133,7 +3133,7 @@ static int __devinit ohci1394_pci_probe(
 			      DMA_CTX_ASYNC_REQ, 0, AR_REQ_NUM_DESC,
 			      AR_REQ_BUF_SIZE, AR_REQ_SPLIT_BUF_SIZE,
 			      OHCI1394_AsReqRcvContextBase) < 0) {
-		PRINT_G(KERN_ERR, "Failed to allocate AR Req context");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "AR Req context");
 		goto err;
 	}
 	/* AR DMA response context allocation */
@@ -3141,21 +3141,21 @@ static int __devinit ohci1394_pci_probe(
 			      DMA_CTX_ASYNC_RESP, 0, AR_RESP_NUM_DESC,
 			      AR_RESP_BUF_SIZE, AR_RESP_SPLIT_BUF_SIZE,
 			      OHCI1394_AsRspRcvContextBase) < 0) {
-		PRINT_G(KERN_ERR, "Failed to allocate AR Resp context");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "AR Resp context");
 		goto err;
 	}
 	/* AT DMA request context */
 	if (alloc_dma_trm_ctx(ohci, &ohci->at_req_context,
 			      DMA_CTX_ASYNC_REQ, 0, AT_REQ_NUM_DESC,
 			      OHCI1394_AsReqTrContextBase) < 0) {
-		PRINT_G(KERN_ERR, "Failed to allocate AT Req context");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "AT Req context");
 		goto err;
 	}
 	/* AT DMA response context */
 	if (alloc_dma_trm_ctx(ohci, &ohci->at_resp_context,
 			      DMA_CTX_ASYNC_RESP, 1, AT_RESP_NUM_DESC,
 			      OHCI1394_AsRspTrContextBase) < 0) {
-		PRINT_G(KERN_ERR, "Failed to allocate AT Resp context");
+		PRINT_G(KERN_ERR, "Failed to allocate %s", "AT Resp context");
 		goto err;
 	}
 	/* Start off with a soft reset, to clear everything to a sane

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

