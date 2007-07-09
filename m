Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbXGIQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbXGIQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761471AbXGIQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:42:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51209 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761531AbXGIQl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:41:59 -0400
Date: Mon, 9 Jul 2007 12:41:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, dave@thedillows.org, dean@arctic.org
Subject: [RFT][PATCH 1/2] sata_mv: post-2.6.22 cleanups
Message-ID: <20070709164154.GA12527@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some cleanups found in libata-dev.git#upstream.  Mainly a prep patch for
the upcoming patch #2.

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 590f2f9..3873b29 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -526,44 +526,44 @@ static const struct ata_port_info mv_port_info[] = {
 	{  /* chip_504x */
 		.flags		= MV_COMMON_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
 		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
 		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS |
 				   MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 };
@@ -2338,7 +2338,7 @@ static void mv_print_info(struct ata_host *host)
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct mv_host_priv *hpriv = host->private_data;
 	u8 rev_id, scc;
-	const char *scc_s;
+	const char *scc_s, *gen;
 
 	/* Use this to determine the HW stepping of the chip so we know
 	 * what errata to workaround
@@ -2351,11 +2351,20 @@ static void mv_print_info(struct ata_host *host)
 	else if (scc == 0x01)
 		scc_s = "RAID";
 	else
-		scc_s = "unknown";
+		scc_s = "?";
+
+	if (IS_GEN_I(hpriv))
+		gen = "I";
+	else if (IS_GEN_II(hpriv))
+		gen = "II";
+	else if (IS_GEN_IIE(hpriv))
+		gen = "IIE";
+	else
+		gen = "?";
 
 	dev_printk(KERN_INFO, &pdev->dev,
-	       "%u slots %u ports %s mode IRQ via %s\n",
-	       (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
+	       "Gen-%s %u slots %u ports %s mode IRQ via %s\n",
+	       gen, (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
