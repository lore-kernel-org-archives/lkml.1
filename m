Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXGNIRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXGNIRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXGNIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:17:35 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54684 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbXGNIR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:17:29 -0400
Date: Sat, 14 Jul 2007 04:17:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] libata: use ->proto_mask in drivers
Message-ID: <20070714081728.GB27006@havoc.gtf.org>
References: <20070714081526.GA26878@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714081526.GA26878@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Review definitely helps here...


commit b8485b72aa93a82bcb48835f04c8cf06cd0b1f37
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 14 03:54:56 2007 -0400

    [libata] Fill in ->proto_mask setting for all drivers
    
    Using observations on pio_mask/mwdma_mask/udma_mask settings, set
    ->proto_mask to either ATA_PMASK_SFF (no DMA) or ATA_PMASK_SFF_DMA.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/ahci.c              |    6 ++++++
 drivers/ata/ata_generic.c       |   13 +++++++------
 drivers/ata/ata_piix.c          |   13 +++++++++++++
 drivers/ata/pata_ali.c          |    7 +++++++
 drivers/ata/pata_amd.c          |   10 ++++++++++
 drivers/ata/pata_artop.c        |    3 +++
 drivers/ata/pata_atiixp.c       |    1 +
 drivers/ata/pata_cmd640.c       |    1 +
 drivers/ata/pata_cmd64x.c       |    6 ++++++
 drivers/ata/pata_cs5520.c       |    1 +
 drivers/ata/pata_cs5530.c       |    2 ++
 drivers/ata/pata_cs5535.c       |    1 +
 drivers/ata/pata_cypress.c      |    1 +
 drivers/ata/pata_efar.c         |    1 +
 drivers/ata/pata_hpt366.c       |    1 +
 drivers/ata/pata_hpt37x.c       |    6 ++++++
 drivers/ata/pata_hpt3x2n.c      |    1 +
 drivers/ata/pata_hpt3x3.c       |    3 +++
 drivers/ata/pata_icside.c       |    4 ++++
 drivers/ata/pata_isapnp.c       |    1 +
 drivers/ata/pata_it8213.c       |    1 +
 drivers/ata/pata_it821x.c       |    2 ++
 drivers/ata/pata_ixp4xx_cf.c    |    1 +
 drivers/ata/pata_jmicron.c      |    1 +
 drivers/ata/pata_legacy.c       |    1 +
 drivers/ata/pata_marvell.c      |    2 ++
 drivers/ata/pata_mpc52xx.c      |    1 +
 drivers/ata/pata_mpiix.c        |    1 +
 drivers/ata/pata_netcell.c      |    1 +
 drivers/ata/pata_ns87410.c      |    1 +
 drivers/ata/pata_oldpiix.c      |    1 +
 drivers/ata/pata_opti.c         |    1 +
 drivers/ata/pata_optidma.c      |    2 ++
 drivers/ata/pata_pcmcia.c       |    1 +
 drivers/ata/pata_pdc2027x.c     |    2 ++
 drivers/ata/pata_pdc202xx_old.c |    3 +++
 drivers/ata/pata_platform.c     |    1 +
 drivers/ata/pata_qdi.c          |    2 ++
 drivers/ata/pata_radisys.c      |    1 +
 drivers/ata/pata_rz1000.c       |    1 +
 drivers/ata/pata_sc1200.c       |    1 +
 drivers/ata/pata_scc.c          |    1 +
 drivers/ata/pata_serverworks.c  |    4 ++++
 drivers/ata/pata_sil680.c       |    2 ++
 drivers/ata/pata_sis.c          |   10 +++++++++-
 drivers/ata/pata_sl82c105.c     |    2 ++
 drivers/ata/pata_triflex.c      |    1 +
 drivers/ata/pata_via.c          |    6 ++++++
 drivers/ata/pata_winbond.c      |    1 +
 drivers/ata/pdc_adma.c          |    1 +
 drivers/ata/sata_inic162x.c     |    1 +
 drivers/ata/sata_mv.c           |    7 +++++++
 drivers/ata/sata_nv.c           |    4 ++++
 drivers/ata/sata_promise.c      |    7 +++++++
 drivers/ata/sata_qstor.c        |    1 +
 drivers/ata/sata_sil.c          |    4 ++++
 drivers/ata/sata_sil24.c        |    3 +++
 drivers/ata/sata_sis.c          |    1 +
 drivers/ata/sata_svw.c          |    2 ++
 drivers/ata/sata_sx4.c          |    1 +
 drivers/ata/sata_uli.c          |    1 +
 drivers/ata/sata_via.c          |    3 +++
 drivers/ata/sata_vsc.c          |    1 +
 63 files changed, 167 insertions(+), 7 deletions(-)

b8485b72aa93a82bcb48835f04c8cf06cd0b1f37
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 11e4eb9..9043642 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -334,6 +334,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_pi */
@@ -341,6 +342,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_vt8251 */
@@ -349,6 +351,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				  AHCI_FLAG_NO_NCQ,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_vt8251_ops,
 	},
 	/* board_ahci_ign_iferr */
@@ -356,6 +359,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_IGN_IRQ_IF_ERR,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_sb600 */
@@ -365,6 +369,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				  AHCI_FLAG_32BIT_ONLY,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_mv */
@@ -377,6 +382,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				  AHCI_FLAG_MV_PATA,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ahci_ops,
 	},
 };
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 430fcf4..e46426d 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -142,12 +142,13 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 {
 	u16 command;
 	static const struct ata_port_info info = {
-		.sht = &generic_sht,
-		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = ATA_UDMA5,
-		.port_ops = &generic_port_ops
+		.sht		= &generic_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS,
+		.pio_mask	= 0x1f,
+		.mwdma_mask	= 0x07,
+		.udma_mask	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.port_ops	= &generic_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d9fa329..32a15a5 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -449,6 +449,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
 		.udma_mask	= ATA_UDMA_MASK_40C,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_pata_ops,
 	},
 
@@ -459,6 +460,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask 	= 0x1f,	/* pio 0-4 */
 		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
 		.udma_mask	= ATA_UDMA2, /* UDMA33 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ich_pata_ops,
 	},
 	/* ich_pata_66: 2 	ICH controllers up to 66MHz */
@@ -468,6 +470,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask 	= 0x1f,	/* pio 0-4 */
 		.mwdma_mask	= 0x06, /* MWDMA0 is broken on chip */
 		.udma_mask	= ATA_UDMA4,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ich_pata_ops,
 	},
 
@@ -478,6 +481,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 */
 		.udma_mask	= ATA_UDMA5, /* udma0-5 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ich_pata_ops,
 	},
 
@@ -488,6 +492,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask 	= 0x1f,	/* pio 0-4 */
 		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
 		.udma_mask	= ATA_UDMA6, /* UDMA133 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &ich_pata_ops,
 	},
 
@@ -498,6 +503,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -508,6 +514,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -519,6 +526,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -530,6 +538,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -541,6 +550,7 @@ static struct ata_port_info piix_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -550,6 +560,7 @@ static struct ata_port_info piix_port_info[] = {
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &piix_pata_ops,
 	},
 };
@@ -1091,8 +1102,10 @@ static int piix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		   all the PIIX devices on the board */
 		port_info[0].mwdma_mask = 0;
 		port_info[0].udma_mask = 0;
+		port_info[0].proto_mask = ATA_PMASK_SFF;
 		port_info[1].mwdma_mask = 0;
 		port_info[1].udma_mask = 0;
+		port_info[1].proto_mask = ATA_PMASK_SFF;
 	}
 	return ata_pci_init_one(pdev, ppi);
 }
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 0104367..bc3e4b4 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -520,6 +520,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &ali_early_port_ops
 	};
 	/* Revision 0x20 added DMA */
@@ -528,6 +529,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0x20 with support logic added UDMA */
@@ -537,6 +539,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,	/* UDMA33 */
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0xC2 adds UDMA66 */
@@ -546,6 +549,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA4,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA66 for now */
@@ -555,6 +559,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA4,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA100 */
@@ -564,6 +569,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
@@ -573,6 +579,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &ali_c5_port_ops
 	};
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b09faca..40af872 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -545,6 +545,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,	/* No SWDMA */
 			.udma_mask = 0x07,	/* UDMA 33 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd33_port_ops
 		},
 		{	/* 1: Early AMD7409 - no swdma */
@@ -553,6 +554,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 2: AMD 7409, no swdma errata */
@@ -561,6 +563,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 3: AMD 7411 */
@@ -569,6 +572,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 4: AMD 7441 */
@@ -577,6 +581,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 5: AMD 8111*/
@@ -585,6 +590,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 6: AMD 8111 UDMA 100 (Serenade) */
@@ -593,6 +599,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100, no swdma */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 7: Nvidia Nforce */
@@ -601,6 +608,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &nv100_port_ops
 		},
 		{	/* 8: Nvidia Nforce2 and later */
@@ -609,6 +617,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &nv133_port_ops
 		},
 		{	/* 9: AMD CS5536 (Geode companion) */
@@ -617,6 +626,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &amd100_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index ce589d9..34be149 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -420,6 +420,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA2,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &artop6210_ops,
 	};
 	static const struct ata_port_info info_626x = {
@@ -428,6 +429,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA4,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &artop6260_ops,
 	};
 	static const struct ata_port_info info_626x_fast = {
@@ -436,6 +438,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &artop6260_ops,
 	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 80509be..9899b02 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -274,6 +274,7 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x06,	/* No MWDMA0 support */
 		.udma_mask = 0x3F,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 0feb5ae..419298c 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -253,6 +253,7 @@ static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.sht = &cmd640_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &cmd640_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index dc443e7..535cbfa 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -383,6 +383,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with broken UDMA */
@@ -390,6 +391,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with working UDMA */
@@ -398,6 +400,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA1,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 rev 1  */
@@ -405,6 +408,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd646r1_port_ops
 		},
 		{	/* CMD 648 */
@@ -413,6 +417,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA2,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd648_port_ops
 		},
 		{	/* CMD 649 */
@@ -421,6 +426,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA3,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &cmd648_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 6bf037d..9fa4e0b 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -194,6 +194,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 	struct ata_port_info pi = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,
+		.proto_mask	= ATA_PMASK_SFF,
 		.port_ops	= &cs5520_port_ops,
 	};
 	const struct ata_port_info *ppi[2];
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 68f150a..708c9f7 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -341,6 +341,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &cs5530_port_ops
 	};
 	/* The docking connector doesn't do UDMA, and it seems not MWDMA */
@@ -348,6 +349,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.sht = &cs5530_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &cs5530_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 360b6f3..3851215 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -229,6 +229,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA4,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &cs5535_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 6cbc877..10901ab 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -170,6 +170,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &cy82c693_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index c8ba59c..d110686 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -307,6 +307,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.udma_mask 	= 0x0f, /* UDMA 66 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &efar_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 6f7d34a..4b47da4 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -397,6 +397,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA4,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt366_port_ops
 	};
 	struct ata_port_info info = info_hpt366;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index b0af65a..93af089 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -893,6 +893,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
@@ -902,6 +903,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
@@ -911,6 +913,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x0f,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
@@ -920,6 +923,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x0f,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
@@ -929,6 +933,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA100 */
@@ -938,6 +943,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt374_port_ops
 	};
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index aa29cde..305fe7b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -494,6 +494,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &hpt3x2n_port_ops
 	};
 	struct ata_port_info port = info;
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index be0f05e..7292ce3 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -198,6 +198,9 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		/* Further debug needed */
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
+#else
+		.proto_mask = ATA_PMASK_SFF,
 #endif
 		.port_ops = &hpt3x3_port_ops
 	};
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 321d98b..d206f3c 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -530,6 +530,10 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 
 		ap->pio_mask = 0x1f;
 		ap->mwdma_mask = info->mwdma_mask;
+		if (ap->mwdma_mask)
+			ap->proto_mask = ATA_PMASK_SFF_DMA;
+		else
+			ap->proto_mask = ATA_PMASK_SFF;
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ops = &pata_icside_port_ops;
 
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 5525518..e4a121e 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -99,6 +99,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 
 	ap->ops = &isapnp_port_ops;
 	ap->pio_mask = 1;
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = cmd_addr;
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index b8af55e..e7ab0d7 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -317,6 +317,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 430673b..c0b017b 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -716,6 +716,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &it821x_smart_port_ops
 	};
 	static const struct ata_port_info info_passthru = {
@@ -724,6 +725,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &it821x_passthru_port_ops
 	};
 
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..121e7af 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -201,6 +201,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ap->ops	= &ixp4xx_port_ops;
 	ap->pio_mask = 0x1f; /* PIO4 */
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
 
 	ixp4xx_setup_port(&ap->ioaddr, data);
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 4d67f23..038604b 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -198,6 +198,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask 	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 
 		.port_ops	= &jmicron_ops,
 	};
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index edffc25..9a2e2df 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -807,6 +807,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 
 	ap->ops = ops;
 	ap->pio_mask = pio_modes;
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_SLAVE_POSS | iordy;
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctrl_addr;
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 87594c0..20d86ac 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -168,6 +168,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask 	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 
 		.port_ops	= &marvell_ops,
 	};
@@ -179,6 +180,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask 	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 
 		.port_ops	= &marvell_ops,
 	};
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 182e83c..e932077 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -320,6 +320,7 @@ mpc52xx_ata_init_one(struct device *dev, struct mpc52xx_ata_priv *priv)
 	ap->pio_mask		= 0x1f;	/* Up to PIO4 */
 	ap->mwdma_mask		= 0x00;	/* No MWDMA   */
 	ap->udma_mask		= 0x00;	/* No UDMA    */
+	ap->proto_mask		= ATA_PMASK_SFF_DMA;
 	ap->ops			= &mpc52xx_ata_port_ops;
 	host->private_data	= priv;
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 4ea4283..caf3295 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -242,6 +242,7 @@ static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	ap = host->ports[0];
 	ap->ops = &mpiix_port_ops;
 	ap->pio_mask = 0x1F;
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = cmd_addr;
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 40eb574..c3a5835 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -100,6 +100,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA5, /* UDMA 133 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &netcell_ops,
 	};
 	const struct ata_port_info *port_info[] = { &info, NULL };
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 2f5d714..fe9c81a 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -195,6 +195,7 @@ static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.sht = &ns87410_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x0F,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &ns87410_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 091a70a..454d25e 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -294,6 +294,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &oldpiix_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 458bf67..5cee616 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -220,6 +220,7 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.sht = &opti_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &opti_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index f89bdfd..91fb125 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -487,6 +487,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &optidma_port_ops
 	};
 	static const struct ata_port_info info_82c700_udma = {
@@ -495,6 +496,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &optiplus_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info_82c700, NULL };
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index a56257c..f31d4a8 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -298,6 +298,7 @@ next_entry:
 
 	ap->ops = &pcmcia_port_ops;
 	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctl_addr;
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 69a5aa4..f6be0ec 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -221,6 +221,7 @@ static struct ata_port_info pdc2027x_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5, /* udma0-5 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc2027x_pata100_ops,
 	},
 	/* PDC_UDMA_133 */
@@ -230,6 +231,7 @@ static struct ata_port_info pdc2027x_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6, /* udma0-6 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc2027x_pata133_ops,
 	},
 };
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 92447be..93e1a75 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -324,6 +324,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA2,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &pdc2024x_port_ops
 		},
 		{
@@ -332,6 +333,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA4,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &pdc2026x_port_ops
 		},
 		{
@@ -340,6 +342,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &pdc2026x_port_ops
 		}
 
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 79f841b..ed92822 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -186,6 +186,7 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 
 	ap->ops = &pata_platform_port_ops;
 	ap->pio_mask = pio_mask;
+	ap->proto_mask = ATA_PMASK_SFF;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	/*
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 1998c19..7b66b77 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -274,6 +274,8 @@ static __init int qdi_init_one(unsigned long port, int type, unsigned long io, i
 		ap->flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_IORDY;
 	}
 
+	ap->proto_mask = ATA_PMASK_SFF;
+
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctl_addr;
 	ap->ioaddr.ctl_addr = ctl_addr;
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 7d1aabe..7e96c92 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -261,6 +261,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.udma_mask	= 0x14, /* UDMA33/66 only */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &radisys_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 7632fcb..f99b509 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -135,6 +135,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.sht = &rz1000_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &rz1000_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index b8b2d11..3c75fbd 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -249,6 +249,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &sc1200_port_ops
 	};
 	/* Can't enable port 2 yet, see top comments */
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index c55667e..0c418a3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1052,6 +1052,7 @@ static struct ata_port_info scc_port_info[] = {
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x00,
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &scc_pata_ops,
 	},
 };
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 8969154..ade95db 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -479,6 +479,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x07,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* OSB4 no UDMA */
 			.sht = &serverworks_sht,
@@ -486,6 +487,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x00,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* CSB5 */
 			.sht = &serverworks_sht,
@@ -493,6 +495,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA4,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &serverworks_csb_port_ops
 		}, { /* CSB5 - later revisions*/
 			.sht = &serverworks_sht,
@@ -500,6 +503,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,
+			.proto_mask = ATA_PMASK_SFF_DMA,
 			.port_ops = &serverworks_csb_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index b0cd52d..34195ed 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -350,6 +350,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &sil680_port_ops
 	};
 	static const struct ata_port_info info_slow = {
@@ -358,6 +359,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &sil680_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 9a829a7..6b42fd2 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -739,6 +739,7 @@ static const struct ata_port_info sis_info = {
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.mwdma_mask	= 0x07,
 	.udma_mask	= 0,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_old_ops,
 };
 static const struct ata_port_info sis_info33 = {
@@ -747,6 +748,7 @@ static const struct ata_port_info sis_info33 = {
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA2,	/* UDMA 33 */
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_old_ops,
 };
 static const struct ata_port_info sis_info66 = {
@@ -754,6 +756,7 @@ static const struct ata_port_info sis_info66 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA4,	/* UDMA 66 */
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info100 = {
@@ -761,13 +764,15 @@ static const struct ata_port_info sis_info100 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA5,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_100_ops,
 };
 static const struct ata_port_info sis_info100_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.udma_mask	= ATA_UDMA5,
 	.pio_mask	= 0x1f,	/* pio0-4 */
+	.udma_mask	= ATA_UDMA5,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info133 = {
@@ -775,6 +780,7 @@ static const struct ata_port_info sis_info133 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_133_ops,
 };
 const struct ata_port_info sis_info133_for_sata = {
@@ -782,6 +788,7 @@ const struct ata_port_info sis_info133_for_sata = {
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_133_for_sata_ops,
 };
 static const struct ata_port_info sis_info133_early = {
@@ -789,6 +796,7 @@ static const struct ata_port_info sis_info133_early = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_133_early_ops,
 };
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 8c2813a..592ec31 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -303,12 +303,14 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &sl82c105_port_ops
 	};
 	static const struct ata_port_info info_early = {
 		.sht = &sl82c105_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+		.proto_mask = ATA_PMASK_SFF,
 		.port_ops = &sl82c105_port_ops
 	};
 	/* for now use only the first port */
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index af21f44..f3c3bcd 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -238,6 +238,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &triflex_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index f645fe2..53e7511 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -455,6 +455,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops
 	};
 	/* Ditto with IRQ masking required */
@@ -463,6 +464,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops_noirq,
 	};
 	/* VIA UDMA 33 devices (and borked 66) */
@@ -472,6 +474,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA2,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 66 devices */
@@ -481,6 +484,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA4,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 100 devices */
@@ -490,6 +494,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops
 	};
 	/* UDMA133 with bad AST (All current 133) */
@@ -499,6 +504,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA6,	/* FIXME: should check north bridge */
+		.proto_mask = ATA_PMASK_SFF_DMA,
 		.port_ops = &via_port_ops
 	};
 	struct ata_port_info type;
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 83abfec..bb577c8 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -224,6 +224,7 @@ static __init int winbond_init_one(unsigned long port)
 		ap = host->ports[0];
 		ap->ops = &winbond_port_ops;
 		ap->pio_mask = 0x1F;
+		ap->proto_mask = ATA_PMASK_SFF;
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ioaddr.cmd_addr = cmd_addr;
 		ap->ioaddr.altstatus_addr = ctl_addr;
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index bec1de5..38e72f4 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -189,6 +189,7 @@ static struct ata_port_info adma_port_info[] = {
 				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
 		.udma_mask	= ATA_UDMA4,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &adma_ata_ops,
 	},
 };
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 3de1834..599fd23 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -595,6 +595,7 @@ static struct ata_port_info inic_port_info = {
 	.pio_mask		= 0x1f,	/* pio0-4 */
 	.mwdma_mask		= 0x07, /* mwdma0-2 */
 	.udma_mask		= ATA_UDMA6,
+	.proto_mask		= ATA_PMASK_SFF_DMA,
 	.port_ops		= &inic_port_ops
 };
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 5d57643..f45867e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -574,24 +574,28 @@ static const struct ata_port_info mv_port_info[] = {
 		.flags		= MV_COMMON_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
 		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
 		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
@@ -599,18 +603,21 @@ static const struct ata_port_info mv_port_info[] = {
 				  MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &mv_iie_ops,
 	},
 };
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index db81e3e..af1035b 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -460,6 +460,7 @@ static const struct ata_port_info nv_port_info[] = {
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &nv_generic_ops,
 		.irq_handler	= nv_generic_interrupt,
 	},
@@ -471,6 +472,7 @@ static const struct ata_port_info nv_port_info[] = {
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &nv_nf2_ops,
 		.irq_handler	= nv_nf2_interrupt,
 	},
@@ -482,6 +484,7 @@ static const struct ata_port_info nv_port_info[] = {
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &nv_ck804_ops,
 		.irq_handler	= nv_ck804_interrupt,
 	},
@@ -494,6 +497,7 @@ static const struct ata_port_info nv_port_info[] = {
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index d2fcb9a..db4da43 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -251,6 +251,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -260,6 +261,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -270,6 +272,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -280,6 +283,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -290,6 +294,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_sata_ops,
 	},
 
@@ -300,6 +305,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -310,6 +316,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_sata_ops,
 	},
 };
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 9ab554d..d4ce505 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -177,6 +177,7 @@ static const struct ata_port_info qs_port_info[] = {
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &qs_ata_ops,
 	},
 };
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 2a86dc4..b684649 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -219,6 +219,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3112_no_sata_irq */
@@ -228,6 +229,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3512 */
@@ -236,6 +238,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3114 */
@@ -244,6 +247,7 @@ static const struct ata_port_info sil_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil_ops,
 	},
 };
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index ac43a30..614e3bf 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -427,6 +427,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3132 */
@@ -435,6 +436,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3131/sil_3531 */
@@ -443,6 +445,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &sil24_ops,
 	},
 };
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 33716b0..a12bab5 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -134,6 +134,7 @@ static const struct ata_port_info sis_port_info = {
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x7,
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &sis_ops,
 };
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 63fe99a..65920f4 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -362,6 +362,7 @@ static const struct ata_port_info k2_port_info[] = {
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &k2_sata_ops,
 	},
 	/* board_svw8 */
@@ -372,6 +373,7 @@ static const struct ata_port_info k2_port_info[] = {
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &k2_sata_ops,
 	},
 };
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 5193bd8..4aeaa36 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -280,6 +280,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &pdc_20621_ops,
 	},
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index b52f83a..5760bef 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -130,6 +130,7 @@ static const struct ata_port_info uli_port_info = {
 			  ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = 0x1f,		/* pio0-4 */
 	.udma_mask      = ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops       = &uli_ops,
 };
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c412447..17070eb 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -224,6 +224,7 @@ static const struct ata_port_info vt6420_port_info = {
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &vt6420_sata_ops,
 };
 
@@ -232,6 +233,7 @@ static struct ata_port_info vt6421_sport_info = {
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &vt6421_sata_ops,
 };
 
@@ -240,6 +242,7 @@ static struct ata_port_info vt6421_pport_info = {
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0,
 	.udma_mask	= ATA_UDMA6,
+	.proto_mask	= ATA_PMASK_SFF_DMA,
 	.port_ops	= &vt6421_pata_ops,
 };
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 1b5d81f..0d8a566 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -372,6 +372,7 @@ static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_d
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
 		.udma_mask	= ATA_UDMA6,
+		.proto_mask	= ATA_PMASK_SFF_DMA,
 		.port_ops	= &vsc_sata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &pi, NULL };
