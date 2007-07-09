Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbXGISv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbXGISv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXGISvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:51:04 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52698 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbXGISvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:51:02 -0400
Date: Mon, 9 Jul 2007 14:50:58 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: Clean up driver udma_mask initializers
Message-ID: <20070709185058.GA22037@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 469248abf00dfa813356b372ffe153b85f27f4bf
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 8 01:13:16 2007 -0400

    [libata] Clean up driver udma_mask initializers
    
    * Use ATA_UDMA*
    * Remove FIXME notations that once served to remind us to verify
      that these were indeed the correct UDMA masks.  They are.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

469248abf00dfa813356b372ffe153b85f27f4bf
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b14e7ef..f66e2a5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -330,14 +330,14 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_pi */
 	{
 		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_vt8251 */
@@ -345,14 +345,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_HRST_TO_RESUME |
 				  AHCI_FLAG_NO_NCQ,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_vt8251_ops,
 	},
 	/* board_ahci_ign_iferr */
 	{
 		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_IGN_IRQ_IF_ERR,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_sb600 */
@@ -361,7 +361,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				  AHCI_FLAG_IGN_SERR_INTERNAL |
 				  AHCI_FLAG_32BIT_ONLY,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 };
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 78bdfd0..2ad5872 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -250,7 +250,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_SATA_PATA,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -259,7 +259,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -269,7 +269,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -279,7 +279,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -289,7 +289,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II | PDC_FLAG_SATA_PATA,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
 
@@ -299,7 +299,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -309,7 +309,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
 };
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 3d83ee2..5193bd8 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -279,7 +279,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_20621_ops,
 	},
 
