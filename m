Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbXGISwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbXGISwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbXGISwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:52:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52704 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759407AbXGISv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:51:57 -0400
Date: Mon, 9 Jul 2007 14:51:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: Use ATA_UDMAx standard masks when filling driver's udma_mask info
Message-ID: <20070709185156.GA22135@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit bf6263a853c9c143bf03f0a6fdcc68ab714fb5f5
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Jul 9 12:16:50 2007 -0400

    [libata] Use ATA_UDMAx standard masks when filling driver's udma_mask info
    
    The ATA_UDMAx masks are self-documenting, and far better than manually
    writing in the hex mask.
    
    Note that pata_it8213 mask differed from the comment.  Added a FIXME there.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

bf6263a853c9c143bf03f0a6fdcc68ab714fb5f5
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 0878fb5..430fcf4 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -146,7 +146,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &generic_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 76cbdf0..6a3bfef 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -497,7 +497,7 @@ static struct ata_port_info piix_port_info[] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -507,7 +507,7 @@ static struct ata_port_info piix_port_info[] = {
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -518,7 +518,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -529,7 +529,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -540,7 +540,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 5c53d5a..30c4276 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -547,7 +547,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA66 for now */
@@ -556,7 +556,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA100 */
@@ -565,7 +565,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
@@ -574,7 +574,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &ali_c5_port_ops
 	};
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 533bcc9..b9c44c5 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -552,7 +552,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,	/* UDMA 66 */
+			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 2: AMD 7409, no swdma errata */
@@ -560,7 +560,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,	/* UDMA 66 */
+			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 3: AMD 7411 */
@@ -568,7 +568,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 4: AMD 7441 */
@@ -576,7 +576,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 5: AMD 8111*/
@@ -584,7 +584,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x7f,	/* UDMA 133, no swdma */
+			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 6: AMD 8111 UDMA 100 (Serenade) */
@@ -592,7 +592,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100, no swdma */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100, no swdma */
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 7: Nvidia Nforce */
@@ -600,7 +600,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &nv100_port_ops
 		},
 		{	/* 8: Nvidia Nforce2 and later */
@@ -608,7 +608,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x7f,	/* UDMA 133, no swdma */
+			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
 			.port_ops = &nv133_port_ops
 		},
 		{	/* 9: AMD CS5536 (Geode companion) */
@@ -616,7 +616,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 7eeed57..360b6f3 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -228,7 +228,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &cs5535_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 7a6ff3d..6f7d34a 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -396,7 +396,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &hpt366_port_ops
 	};
 	struct ata_port_info info = info_hpt366;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index d2278fd..b0af65a 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -892,7 +892,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
@@ -901,7 +901,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
@@ -928,7 +928,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA100 */
@@ -937,7 +937,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt374_port_ops
 	};
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 809d338..aa29cde 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -493,7 +493,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt3x2n_port_ops
 	};
 	struct ata_port_info port = info;
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 41fb08b..b8af55e 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -316,7 +316,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask 	= 0x1f, /* UDMA 100 */
+		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 4f26ef1..b67bbf6 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -724,7 +724,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_passthru_port_ops
 	};
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 1a6c4db..4d67f23 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -197,7 +197,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x3f,
+		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &jmicron_ops,
 	};
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 73f1e4b..87594c0 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -167,7 +167,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x3f,
+		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &marvell_ops,
 	};
@@ -178,7 +178,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x7f,
+		.udma_mask 	= ATA_UDMA6,
 
 		.port_ops	= &marvell_ops,
 	};
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index b7c8b13..40eb574 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -99,7 +99,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		   firmware deals with it */
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask 	= 0x3f, /* UDMA 133 */
+		.udma_mask 	= ATA_UDMA5, /* UDMA 133 */
 		.port_ops	= &netcell_ops,
 	};
 	const struct ata_port_info *port_info[] = { &info, NULL };
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 2c0bc3b..0231aba 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -495,14 +495,14 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &serverworks_csb_port_ops
 		}, { /* CSB5 - later revisions*/
 			.sht = &serverworks_sht,
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &serverworks_csb_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 9b645c5..b0cd52d 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -349,7 +349,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &sil680_port_ops
 	};
 	static const struct ata_port_info info_slow = {
@@ -357,7 +357,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &sil680_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 63eca29..f0cadbe 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -471,7 +471,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7,
+		.udma_mask = ATA_UDMA2,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 66 devices */
@@ -480,7 +480,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 100 devices */
@@ -489,7 +489,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &via_port_ops
 	};
 	/* UDMA133 with bad AST (All current 133) */
@@ -498,7 +498,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,	/* FIXME: should check north bridge */
+		.udma_mask = ATA_UDMA6,	/* FIXME: should check north bridge */
 		.port_ops = &via_port_ops
 	};
 	struct ata_port_info type;
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 74c50c9..bec1de5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -188,7 +188,7 @@ static struct ata_port_info adma_port_info[] = {
 				  ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
 				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
-		.udma_mask	= 0x1f, /* udma0-4 */
+		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &adma_ata_ops,
 	},
 };
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8efc531..3de1834 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -594,7 +594,7 @@ static struct ata_port_info inic_port_info = {
 	.flags			= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 	.pio_mask		= 0x1f,	/* pio0-4 */
 	.mwdma_mask		= 0x07, /* mwdma0-2 */
-	.udma_mask		= 0x7f,	/* udma0-6 */
+	.udma_mask		= ATA_UDMA6,
 	.port_ops		= &inic_port_ops
 };
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 590f2f9..d65ec23 100644
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
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 6688ccb..9ab554d 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -176,7 +176,7 @@ static const struct ata_port_info qs_port_info[] = {
 				  //FIXME ATA_FLAG_SRST |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
-		.udma_mask	= 0x7f, /* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &qs_ata_ops,
 	},
 };
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index c3f0a86..2a86dc4 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -218,7 +218,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_MOD15WRITE,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3112_no_sata_irq */
@@ -227,7 +227,7 @@ static const struct ata_port_info sil_port_info[] = {
 				  SIL_FLAG_NO_SATA_IRQ,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3512 */
@@ -235,7 +235,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3114 */
@@ -243,7 +243,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 };
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 14261f3..ac43a30 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -426,7 +426,7 @@ static const struct ata_port_info sil24_port_info[] = {
 				  SIL24_FLAG_PCIX_IRQ_WOC,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3132 */
@@ -434,7 +434,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.flags		= SIL24_COMMON_FLAGS | SIL24_NPORTS2FLAG(2),
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3131/sil_3531 */
@@ -442,7 +442,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.flags		= SIL24_COMMON_FLAGS | SIL24_NPORTS2FLAG(1),
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= 0x3f,			/* udma0-5 */
+		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
 		.port_ops	= &sil24_ops,
 	},
 };
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index f111c98..fd80bcf 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -133,7 +133,7 @@ static const struct ata_port_info sis_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x7,
-	.udma_mask	= 0x7f,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_ops,
 };
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 4fd4f10..63fe99a 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -361,7 +361,7 @@ static const struct ata_port_info k2_port_info[] = {
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask	= 0x7f,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
 	/* board_svw8 */
@@ -371,7 +371,7 @@ static const struct ata_port_info k2_port_info[] = {
 				  K2_FLAG_SATA_8_PORTS,
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask	= 0x7f,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
 };
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 6815de7..aca7181 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -129,7 +129,7 @@ static const struct ata_port_info uli_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 			  ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = 0x1f,		/* pio0-4 */
-	.udma_mask      = 0x7f,		/* udma0-6 */
+	.udma_mask      = ATA_UDMA6,
 	.port_ops       = &uli_ops,
 };
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index e816965..a4c0832 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -223,7 +223,7 @@ static const struct ata_port_info vt6420_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
-	.udma_mask	= 0x7f,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6420_sata_ops,
 };
 
@@ -231,7 +231,7 @@ static struct ata_port_info vt6421_sport_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
-	.udma_mask	= 0x7f,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6421_sata_ops,
 };
 
@@ -239,7 +239,7 @@ static struct ata_port_info vt6421_pport_info = {
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0,
-	.udma_mask	= 0x7f,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6421_pata_ops,
 };
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 8133017..1b5d81f 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -371,7 +371,7 @@ static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_d
 				  ATA_FLAG_MMIO,
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask	= 0x7f,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &vsc_sata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &pi, NULL };
