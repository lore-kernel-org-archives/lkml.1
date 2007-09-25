Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbXIYFX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbXIYFX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXIYFXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:23:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:43978 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXIYFXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer;
        b=MH9RCX4nSETLwwxVCckZdKOCxDgMrcM7CA/ptGFY4GUBARfw9vg6xcEvepopfnH2EtovUIcOK+Zr6N5RxrjEZLbjB437w4UOc/M2Ji2QUE9bf0p2K88iUv8HNdcJchMrsN45vehodEOk1HM2OBOCVXA35H2GsUyr5M315ZunVM8=
Date: Tue, 25 Sep 2007 13:23:08 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Message-ID: <200709251323031982245@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ahci controller legacy mode support to sata_nv.
Move the DIDs of legacy mode from ahci.c to sata_nv.c

The patch base on kernel 2.6.23-rc8

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
diff -uprN -X linux-2.6.23-rc8-vanilla/Documentation/dontdiff linux-2.6.23-rc8-vanilla/drivers/ata/ahci.c linux-2.6.23-rc8/drivers/ata/ahci.c
--- linux-2.6.23-rc8-vanilla/drivers/ata/ahci.c	2007-09-25 11:53:40.000000000 -0400
+++ linux-2.6.23-rc8/drivers/ata/ahci.c	2007-09-25 11:53:25.000000000 -0400
@@ -434,14 +434,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x044d), board_ahci },		/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x044e), board_ahci },		/* MCP65 */
 	{ PCI_VDEVICE(NVIDIA, 0x044f), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045c), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci },		/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci },		/* MCP67 */
@@ -450,10 +442,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci },		/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci },		/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci },		/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci },		/* MCP73 */
@@ -462,10 +450,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci },		/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci },		/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci },		/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
diff -uprN -X linux-2.6.23-rc8-vanilla/Documentation/dontdiff linux-2.6.23-rc8-vanilla/drivers/ata/sata_nv.c linux-2.6.23-rc8/drivers/ata/sata_nv.c
--- linux-2.6.23-rc8-vanilla/drivers/ata/sata_nv.c	2007-09-25 11:31:03.000000000 -0400
+++ linux-2.6.23-rc8/drivers/ata/sata_nv.c	2007-09-25 11:19:48.000000000 -0400
@@ -266,6 +266,7 @@ static void nv_adma_tf_read(struct ata_p
 enum nv_host_type
 {
 	GENERIC,
+	AHCI_LEG,
 	NFORCE2,
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
@@ -287,6 +288,29 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, 0x45c), AHCI_LEG },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x45d), AHCI_LEG },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x45e), AHCI_LEG },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x45f), AHCI_LEG },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x550), AHCI_LEG },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x551), AHCI_LEG },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x552), AHCI_LEG },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x553), AHCI_LEG },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x7f0), AHCI_LEG },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x7f1), AHCI_LEG },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x7f2), AHCI_LEG },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x7f3), AHCI_LEG },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0xad0), AHCI_LEG },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0xad1), AHCI_LEG },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0xad2), AHCI_LEG },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0xad3), AHCI_LEG },	/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0xab4), AHCI_LEG },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0xab5), AHCI_LEG },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0xab6), AHCI_LEG },	/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0xab7), AHCI_LEG },	/* MCP79 */	
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+		PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_IDE<<8, 0xffff00, AHCI_LEG },
 
 	{ } /* terminate list */
 };
@@ -365,6 +389,30 @@ static const struct ata_port_operations 
 	.port_start		= ata_port_start,
 };
 
+static const struct ata_port_operations nv_ahci_leg_ops = {
+	.port_disable		= ata_port_disable,
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
+	.dev_select		= ata_std_dev_select,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= nv_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.data_xfer		= ata_data_xfer,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+	.port_start		= ata_port_start,
+};
+
 static const struct ata_port_operations nv_nf2_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
@@ -463,6 +511,17 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_generic_ops,
 		.irq_handler	= nv_generic_interrupt,
 	},
+	/* ahci legacy */
+	{
+		.sht		= &nv_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
+				  ATA_FLAG_HRST_TO_RESUME,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_ahci_leg_ops,
+		.irq_handler	= nv_generic_interrupt,
+	},
 	/* nforce2/3 */
 	{
 		.sht		= &nv_sht,
-
 				
--------------
Peer Chen
2007-09-25

