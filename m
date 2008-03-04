Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbYCDIf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbYCDIf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYCDIbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:31:04 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:62814 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYCDIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:31:00 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 01/17] Change RIO function mpc85xx_ to fsl_ .
Date: Wed,  5 Mar 2008 00:29:46 +0800
Message-Id: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 04 Mar 2008 08:30:28.0219 (UTC) FILETIME=[005454B0:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is also fit for Freescale MPC8641 processor.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   80 ++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index af2425e..36c4be4 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1,5 +1,5 @@
 /*
- * MPC85xx RapidIO support
+ * Freescale MPC85xx/MPC86xx RapidIO support
  *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
@@ -145,7 +145,7 @@ static struct rio_msg_rx_ring {
 } msg_rx_ring;
 
 /**
- * mpc85xx_rio_doorbell_send - Send a MPC85xx doorbell message
+ * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -153,9 +153,9 @@ static struct rio_msg_rx_ring {
  * Sends a MPC85xx doorbell message. Returns %0 on success or
  * %-EINVAL on failure.
  */
-static int mpc85xx_rio_doorbell_send(int index, u16 destid, u16 data)
+static int fsl_rio_doorbell_send(int index, u16 destid, u16 data)
 {
-	pr_debug("mpc85xx_doorbell_send: index %d destid %4.4x data %4.4x\n",
+	pr_debug("fsl_doorbell_send: index %d destid %4.4x data %4.4x\n",
 		 index, destid, data);
 	out_be32((void *)&dbell_atmu_regs->rowtar, destid << 22);
 	out_be16((void *)(dbell_win), data);
@@ -164,7 +164,7 @@ static int mpc85xx_rio_doorbell_send(int index, u16 destid, u16 data)
 }
 
 /**
- * mpc85xx_local_config_read - Generate a MPC85xx local config space read
+ * fsl_local_config_read - Generate a MPC85xx local config space read
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -173,9 +173,9 @@ static int mpc85xx_rio_doorbell_send(int index, u16 destid, u16 data)
  * Generates a MPC85xx local configuration space read. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_read(int index, u32 offset, int len, u32 * data)
+static int fsl_local_config_read(int index, u32 offset, int len, u32 * data)
 {
-	pr_debug("mpc85xx_local_config_read: index %d offset %8.8x\n", index,
+	pr_debug("fsl_local_config_read: index %d offset %8.8x\n", index,
 		 offset);
 	*data = in_be32((void *)(regs_win + offset));
 
@@ -183,7 +183,7 @@ static int mpc85xx_local_config_read(int index, u32 offset, int len, u32 * data)
 }
 
 /**
- * mpc85xx_local_config_write - Generate a MPC85xx local config space write
+ * fsl_local_config_write - Generate a MPC85xx local config space write
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -192,10 +192,10 @@ static int mpc85xx_local_config_read(int index, u32 offset, int len, u32 * data)
  * Generates a MPC85xx local configuration space write. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
+static int fsl_local_config_write(int index, u32 offset, int len, u32 data)
 {
 	pr_debug
-	    ("mpc85xx_local_config_write: index %d offset %8.8x data %8.8x\n",
+	    ("fsl_local_config_write: index %d offset %8.8x data %8.8x\n",
 	     index, offset, data);
 	out_be32((void *)(regs_win + offset), data);
 
@@ -203,7 +203,7 @@ static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
 }
 
 /**
- * mpc85xx_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -215,13 +215,13 @@ static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
  * success or %-EINVAL on failure.
  */
 static int
-mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
+fsl_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
 			u32 * val)
 {
 	u8 *data;
 
 	pr_debug
-	    ("mpc85xx_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
+	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
 	     index, destid, hopcount, offset, len);
 	out_be32((void *)&maint_atmu_regs->rowtar,
 		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
@@ -243,7 +243,7 @@ mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
 }
 
 /**
- * mpc85xx_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -255,12 +255,12 @@ mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
  * success or %-EINVAL on failure.
  */
 static int
-mpc85xx_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
+fsl_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
 			 int len, u32 val)
 {
 	u8 *data;
 	pr_debug
-	    ("mpc85xx_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
+	    ("fsl_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
 	     index, destid, hopcount, offset, len, val);
 	out_be32((void *)&maint_atmu_regs->rowtar,
 		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
@@ -344,7 +344,7 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
 
 /**
- * mpc85xx_rio_tx_handler - MPC85xx outbound message interrupt handler
+ * fsl_rio_tx_handler - MPC85xx outbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
  * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
-mpc85xx_rio_tx_handler(int irq, void *dev_instance)
+fsl_rio_tx_handler(int irq, void *dev_instance)
 {
 	int osr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -452,7 +452,7 @@ int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entr
 
 	/* Hook up outbound message handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_TX, mpc85xx_rio_tx_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_TX, fsl_rio_tx_handler, 0,
 			 "msg_tx", (void *)mport)) < 0)
 		goto out_irq;
 
@@ -511,7 +511,7 @@ void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
 }
 
 /**
- * mpc85xx_rio_rx_handler - MPC85xx inbound message interrupt handler
+ * fsl_rio_rx_handler - MPC85xx inbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -519,7 +519,7 @@ void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
  * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
-mpc85xx_rio_rx_handler(int irq, void *dev_instance)
+fsl_rio_rx_handler(int irq, void *dev_instance)
 {
 	int isr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -597,7 +597,7 @@ int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entri
 
 	/* Hook up inbound message handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_RX, mpc85xx_rio_rx_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_RX, fsl_rio_rx_handler, 0,
 			 "msg_rx", (void *)mport)) < 0) {
 		dma_free_coherent(NULL, RIO_MSG_BUFFER_SIZE,
 				  msg_tx_ring.virt_buffer[i],
@@ -729,7 +729,7 @@ void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
 EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
 
 /**
- * mpc85xx_rio_dbell_handler - MPC85xx doorbell interrupt handler
+ * fsl_rio_dbell_handler - MPC85xx doorbell interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -737,7 +737,7 @@ EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
  * doorbell event handlers and executes a matching event handler.
  */
 static irqreturn_t
-mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
+fsl_rio_dbell_handler(int irq, void *dev_instance)
 {
 	int dsr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -794,14 +794,14 @@ mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
 }
 
 /**
- * mpc85xx_rio_doorbell_init - MPC85xx doorbell interface init
+ * fsl_rio_doorbell_init - MPC85xx doorbell interface init
  * @mport: Master port implementing the inbound doorbell unit
  *
  * Initializes doorbell unit hardware and inbound DMA buffer
- * ring. Called from mpc85xx_rio_setup(). Returns %0 on success
+ * ring. Called from fsl_rio_setup(). Returns %0 on success
  * or %-ENOMEM on failure.
  */
-static int mpc85xx_rio_doorbell_init(struct rio_mport *mport)
+static int fsl_rio_doorbell_init(struct rio_mport *mport)
 {
 	int rc = 0;
 
@@ -835,7 +835,7 @@ static int mpc85xx_rio_doorbell_init(struct rio_mport *mport)
 
 	/* Hook up doorbell handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_BELL, mpc85xx_rio_dbell_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_BELL, fsl_rio_dbell_handler, 0,
 			 "dbell_rx", (void *)mport) < 0)) {
 		iounmap((void *)dbell_win);
 		dma_free_coherent(NULL, 512 * DOORBELL_MESSAGE_SIZE,
@@ -854,7 +854,7 @@ static int mpc85xx_rio_doorbell_init(struct rio_mport *mport)
 
 static char *cmdline = NULL;
 
-static int mpc85xx_rio_get_hdid(int index)
+static int fsl_rio_get_hdid(int index)
 {
 	/* XXX Need to parse multiple entries in some format */
 	if (!cmdline)
@@ -863,7 +863,7 @@ static int mpc85xx_rio_get_hdid(int index)
 	return simple_strtol(cmdline, NULL, 0);
 }
 
-static int mpc85xx_rio_get_cmdline(char *s)
+static int fsl_rio_get_cmdline(char *s)
 {
 	if (!s)
 		return 0;
@@ -872,10 +872,10 @@ static int mpc85xx_rio_get_cmdline(char *s)
 	return 1;
 }
 
-__setup("riohdid=", mpc85xx_rio_get_cmdline);
+__setup("riohdid=", fsl_rio_get_cmdline);
 
 /**
- * mpc85xx_rio_setup - Setup MPC85xx RapidIO interface
+ * fsl_rio_setup - Setup MPC85xx RapidIO interface
  * @law_start: Starting physical address of RapidIO LAW
  * @law_size: Size of RapidIO LAW
  *
@@ -883,17 +883,17 @@ __setup("riohdid=", mpc85xx_rio_get_cmdline);
  * master port with system-specific info, and registers the
  * master port with the RapidIO subsystem.
  */
-void mpc85xx_rio_setup(int law_start, int law_size)
+void fsl_rio_setup(int law_start, int law_size)
 {
 	struct rio_ops *ops;
 	struct rio_mport *port;
 
 	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
-	ops->lcread = mpc85xx_local_config_read;
-	ops->lcwrite = mpc85xx_local_config_write;
-	ops->cread = mpc85xx_rio_config_read;
-	ops->cwrite = mpc85xx_rio_config_write;
-	ops->dsend = mpc85xx_rio_doorbell_send;
+	ops->lcread = fsl_local_config_read;
+	ops->lcwrite = fsl_local_config_write;
+	ops->cread = fsl_rio_config_read;
+	ops->cwrite = fsl_rio_config_write;
+	ops->dsend = fsl_rio_doorbell_send;
 
 	port = kmalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	port->id = 0;
@@ -909,7 +909,7 @@ void mpc85xx_rio_setup(int law_start, int law_size)
 	strcpy(port->name, "RIO0 mport");
 
 	port->ops = ops;
-	port->host_deviceid = mpc85xx_rio_get_hdid(port->id);
+	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	rio_register_mport(port);
 
@@ -928,5 +928,5 @@ void mpc85xx_rio_setup(int law_start, int law_size)
 	/* Configure outbound doorbell window */
 	out_be32((void *)&dbell_atmu_regs->rowbar, 0x000c0400);
 	out_be32((void *)&dbell_atmu_regs->rowar, 0x8004200b);
-	mpc85xx_rio_doorbell_init(port);
+	fsl_rio_doorbell_init(port);
 }
-- 
1.5.4

