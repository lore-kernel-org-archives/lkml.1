Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZCYDCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZCYDCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZCYDCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:02:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43351 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCYDBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:01:51 -0400
Date: Tue, 24 Mar 2009 23:01:47 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20090325030147.GA2969@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No major 2.6.29 fixes have cropped up so far, since release.

Summary, nothing highly notable:
- sata_mv: large update, include ATAPI support (previously thought impossible)
- core updates from Alan that should help with error handling on SFF hardware
- large "magic number" -> "named constant" cleanup
- other minor updates, see shortlog below

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |   31 +-
 drivers/ata/ata_generic.c       |    4 +-
 drivers/ata/ata_piix.c          |   60 ++--
 drivers/ata/libata-core.c       |   14 +-
 drivers/ata/libata-eh.c         |   19 +-
 drivers/ata/libata-sff.c        |   91 ++++-
 drivers/ata/libata.h            |    2 -
 drivers/ata/pata_acpi.c         |    6 +-
 drivers/ata/pata_ali.c          |   28 +-
 drivers/ata/pata_amd.c          |   70 ++--
 drivers/ata/pata_artop.c        |   49 ++-
 drivers/ata/pata_at32.c         |    4 +-
 drivers/ata/pata_atiixp.c       |    6 +-
 drivers/ata/pata_bf54x.c        |    2 +-
 drivers/ata/pata_cmd640.c       |    2 +-
 drivers/ata/pata_cmd64x.c       |   24 +-
 drivers/ata/pata_cs5520.c       |    2 +-
 drivers/ata/pata_cs5530.c       |    8 +-
 drivers/ata/pata_cs5535.c       |    4 +-
 drivers/ata/pata_cs5536.c       |    4 +-
 drivers/ata/pata_cypress.c      |    4 +-
 drivers/ata/pata_efar.c         |    6 +-
 drivers/ata/pata_hpt366.c       |    4 +-
 drivers/ata/pata_hpt37x.c       |   28 +-
 drivers/ata/pata_hpt3x2n.c      |    4 +-
 drivers/ata/pata_hpt3x3.c       |    6 +-
 drivers/ata/pata_icside.c       |    4 +-
 drivers/ata/pata_isapnp.c       |   14 +-
 drivers/ata/pata_it8213.c       |    4 +-
 drivers/ata/pata_it821x.c       |   16 +-
 drivers/ata/pata_ixp4xx_cf.c    |    2 +-
 drivers/ata/pata_jmicron.c      |    4 +-
 drivers/ata/pata_legacy.c       |    2 +-
 drivers/ata/pata_marvell.c      |    8 +-
 drivers/ata/pata_mpc52xx.c      |    4 +-
 drivers/ata/pata_mpiix.c        |    2 +-
 drivers/ata/pata_netcell.c      |    4 +-
 drivers/ata/pata_ninja32.c      |    2 +-
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_ns87415.c      |    8 +-
 drivers/ata/pata_octeon_cf.c    |    4 +-
 drivers/ata/pata_oldpiix.c      |    4 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |   10 +-
 drivers/ata/pata_pcmcia.c       |   36 ++-
 drivers/ata/pata_pdc2027x.c     |   12 +-
 drivers/ata/pata_pdc202xx_old.c |   12 +-
 drivers/ata/pata_qdi.c          |    4 +-
 drivers/ata/pata_radisys.c      |    6 +-
 drivers/ata/pata_rb532_cf.c     |   64 +---
 drivers/ata/pata_rz1000.c       |    2 +-
 drivers/ata/pata_sc1200.c       |   35 ++-
 drivers/ata/pata_scc.c          |    4 +-
 drivers/ata/pata_sch.c          |    6 +-
 drivers/ata/pata_serverworks.c  |   20 +-
 drivers/ata/pata_sil680.c       |    8 +-
 drivers/ata/pata_sis.c          |   32 +-
 drivers/ata/pata_sl82c105.c     |    6 +-
 drivers/ata/pata_triflex.c      |    4 +-
 drivers/ata/pata_via.c          |   24 +-
 drivers/ata/pata_winbond.c      |    2 +-
 drivers/ata/pdc_adma.c          |    4 +-
 drivers/ata/sata_fsl.c          |    4 +-
 drivers/ata/sata_inic162x.c     |    4 +-
 drivers/ata/sata_mv.c           |  868 +++++++++++++++++++++++++++++++++------
 drivers/ata/sata_nv.c           |    7 +-
 drivers/ata/sata_promise.c      |   30 +-
 drivers/ata/sata_qstor.c        |    3 +-
 drivers/ata/sata_sil.c          |   16 +-
 drivers/ata/sata_sil24.c        |   18 +-
 drivers/ata/sata_sis.c          |    4 +-
 drivers/ata/sata_svw.c          |   16 +-
 drivers/ata/sata_sx4.c          |    4 +-
 drivers/ata/sata_uli.c          |    2 +-
 drivers/ata/sata_via.c          |   16 +-
 drivers/ata/sata_vsc.c          |    7 +-
 include/linux/ata.h             |    6 +
 include/linux/libata.h          |    8 +
 78 files changed, 1330 insertions(+), 542 deletions(-)

Alan Cox (4):
      pata_artop: Serializing support
      pata_sc1200: Activate secondary channel
      [libata] Drain data on errors
      [libata] Improve timeout handling

David Milburn (1):
      [libata] ahci: correct enclosure LED state save

Erik Inge Bolsø (4):
      include/linux/ata.h: add some more transfer masks
      [libata] convert drivers to use ata.h mode mask defines
      pata_radisys: fix mwdma_mask to exclude mwdma0
      pata_efar: fix *dma_mask

Florian Fainelli (1):
      pata-rb532-cf: platform_get_irq() fix ignored failure

Maciej Rutecki (1):
      ahci: Blacklist HP Compaq 6720s that spins off disks during ACPI power off

Mark Lord (19):
      sata_mv: cleanup chipset GENeration FLAGS
      sata_mv: rearrange mv_start_dma() and friends
      sata_mv: restructure mv_qc_issue
      sata_mv: update ata_qc_from_tag
      sata_mv: mv_fill_sg fixes v2
      sata_mv: introduce support for ATAPI devices
      sata_mv: optimize use of mv_edma_cfg
      sata_mv: remove leftovers
      [libata] sata_mv: cache frequently-accessed registers
      [libata] sata_mv: Enable use of (basic) DMA for ATAPI on GEN_IIE chips
      [libata] sata_mv: Tighten up interrupt masking in mv_qc_issue()
      [libata] sata_mv: Add a new mv_sff_check_status() function to sata_mv.
      [libata] Export ata_pio_queue_task() so that it can be used from sata_mv.
      [libata] sata_mv: Implement direct FIS transmission via mv_qc_issue_fis().
      sata_mv: cosmetic preparations for IRQ coalescing
      sata_mv: implement IRQ coalescing (v2)
      sata_mv: optimize IRQ coalescing for 8-port chips
      sata_mv: fix LED blinking for SoC+NCQ
      [libata] More robust parsing for IDENTIFY DEVICE multi_count field

Phil Sutter (4):
      pata-rb532-cf: replace rb532_pata_finish_io()
      pata-rb532-cf: use ata_sff_exec_command()
      pata-rb532-cf: use ata_sff_data_xfer32()
      pata-rb532-cf: drop custom freeze and thaw

Tejun Heo (1):
      ahci: drop intx manipulation on msi enable

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 66e012c..788bba2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -404,7 +404,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
@@ -412,7 +412,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_vt8251_ops,
 	},
@@ -420,7 +420,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
@@ -430,7 +430,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_SECT255),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
@@ -440,7 +440,7 @@ static const struct ata_port_info ahci_port_info[] = {
 				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
@@ -448,7 +448,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
@@ -456,7 +456,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
@@ -464,7 +464,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= 0x1f, /* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
@@ -1348,7 +1348,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	writel(message[1], mmio + hpriv->em_loc+4);
 
 	/* save off new led state for port/slot */
-	emp->led_state = message[1];
+	emp->led_state = state;
 
 	/*
 	 * tell hardware to transmit the message
@@ -2565,6 +2565,15 @@ static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
 		},
+		{
+			.ident = "HP Compaq 6720s",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6720s"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
 
 		{ }	/* terminate list */
 	};
@@ -2647,8 +2656,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
 		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
 
-	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
-		pci_intx(pdev, 1);
+	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
+		pci_enable_msi(pdev);
 
 	/* save initial config */
 	ahci_save_initial_config(pdev, hpriv);
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index dc48a63..ecfd22b 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -118,8 +118,8 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	u16 command;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &generic_port_ops
 	};
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ef8b30d..e5cbe80 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -446,34 +446,34 @@ static struct ata_port_info piix_port_info[] = {
 	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
 	{
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
 		.port_ops	= &piix_pata_ops,
 	},
 
 	[piix_pata_33] =	/* PIIX4 at 33MHz */
 	{
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA_MASK_40C,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &piix_pata_ops,
 	},
 
 	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
 	{
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= 0x1f,	/* pio 0-4 */
-		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
-		.udma_mask	= ATA_UDMA2, /* UDMA33 */
+		.pio_mask 	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* Check: maybe MWDMA0 is ok  */
+		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &ich_pata_ops,
 	},
 
 	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
 	{
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask 	= 0x1f,	/* pio 0-4 */
-		.mwdma_mask	= 0x06, /* MWDMA0 is broken on chip */
+		.pio_mask 	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* MWDMA0 is broken on chip */
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &ich_pata_ops,
 	},
@@ -481,17 +481,17 @@ static struct ata_port_info piix_port_info[] = {
 	[ich_pata_100] =
 	{
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x06, /* mwdma1-2 */
-		.udma_mask	= ATA_UDMA5, /* udma0-5 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &ich_pata_ops,
 	},
 
 	[ich5_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -499,8 +499,8 @@ static struct ata_port_info piix_port_info[] = {
 	[ich6_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -508,8 +508,8 @@ static struct ata_port_info piix_port_info[] = {
 	[ich6m_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -517,8 +517,8 @@ static struct ata_port_info piix_port_info[] = {
 	[ich8_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -526,8 +526,8 @@ static struct ata_port_info piix_port_info[] = {
 	[ich8_2port_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -535,8 +535,8 @@ static struct ata_port_info piix_port_info[] = {
 	[tolapai_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -544,8 +544,8 @@ static struct ata_port_info piix_port_info[] = {
 	[ich8m_apple_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
@@ -553,9 +553,9 @@ static struct ata_port_info piix_port_info[] = {
 	[piix_pata_vmw] =
 	{
 		.flags		= PIIX_PATA_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.udma_mask	= ATA_UDMA_MASK_40C,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA2,
 		.port_ops	= &piix_vmw_ops,
 	},
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 060bcd6..e7ea77c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -57,6 +57,7 @@
 #include <linux/scatterlist.h>
 #include <linux/io.h>
 #include <linux/async.h>
+#include <linux/log2.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -2389,6 +2390,7 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->cylinders = 0;
 	dev->heads = 0;
 	dev->sectors = 0;
+	dev->multi_count = 0;
 
 	/*
 	 * common ATA, ATAPI feature tests
@@ -2426,8 +2428,15 @@ int ata_dev_configure(struct ata_device *dev)
 
 		dev->n_sectors = ata_id_n_sectors(id);
 
-		if (dev->id[59] & 0x100)
-			dev->multi_count = dev->id[59] & 0xff;
+		/* get current R/W Multiple count setting */
+		if ((dev->id[47] >> 8) == 0x80 && (dev->id[59] & 0x100)) {
+			unsigned int max = dev->id[47] & 0xff;
+			unsigned int cnt = dev->id[59] & 0xff;
+			/* only recognize/allow powers of two here */
+			if (is_power_of_2(max) && is_power_of_2(cnt))
+				if (cnt <= max)
+					dev->multi_count = cnt;
+		}
 
 		if (ata_id_has_lba(id)) {
 			const char *lba_desc;
@@ -6709,6 +6718,7 @@ EXPORT_SYMBOL_GPL(ata_id_c_string);
 EXPORT_SYMBOL_GPL(ata_do_dev_read_id);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
+EXPORT_SYMBOL_GPL(ata_pio_queue_task);
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
 EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 EXPORT_SYMBOL_GPL(ata_timing_compute);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ea89091..0183131 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -547,7 +547,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 
 	/* For new EH, all qcs are finished in one of three ways -
 	 * normal completion, error completion, and SCSI timeout.
-	 * Both cmpletions can race against SCSI timeout.  When normal
+	 * Both completions can race against SCSI timeout.  When normal
 	 * completion wins, the qc never reaches EH.  When error
 	 * completion wins, the qc has ATA_QCFLAG_FAILED set.
 	 *
@@ -562,7 +562,19 @@ void ata_scsi_error(struct Scsi_Host *host)
 		int nr_timedout = 0;
 
 		spin_lock_irqsave(ap->lock, flags);
-
+		
+		/* This must occur under the ap->lock as we don't want
+		   a polled recovery to race the real interrupt handler
+		   
+		   The lost_interrupt handler checks for any completed but
+		   non-notified command and completes much like an IRQ handler.
+		   
+		   We then fall into the error recovery code which will treat
+		   this as if normal completion won the race */
+
+		if (ap->ops->lost_interrupt)
+			ap->ops->lost_interrupt(ap);
+			
 		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
@@ -606,6 +618,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 		ap->eh_tries = ATA_EH_MAX_TRIES;
 	} else
 		spin_unlock_wait(ap->lock);
+		
+	/* If we timed raced normal completion and there is nothing to
+	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
 
  repeat:
 	/* invoke error handler */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index f93dc02..8332e97 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -52,6 +52,7 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.softreset		= ata_sff_softreset,
 	.hardreset		= sata_sff_hardreset,
 	.postreset		= ata_sff_postreset,
+	.drain_fifo		= ata_sff_drain_fifo,
 	.error_handler		= ata_sff_error_handler,
 	.post_internal_cmd	= ata_sff_post_internal_cmd,
 
@@ -64,6 +65,8 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_irq_on		= ata_sff_irq_on,
 	.sff_irq_clear		= ata_sff_irq_clear,
 
+	.lost_interrupt		= ata_sff_lost_interrupt,
+
 	.port_start		= ata_sff_port_start,
 };
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
@@ -1646,7 +1649,7 @@ EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
  *	RETURNS:
  *	One if interrupt was handled, zero if not (shared irq).
  */
-inline unsigned int ata_sff_host_intr(struct ata_port *ap,
+unsigned int ata_sff_host_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc)
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -1775,6 +1778,48 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 EXPORT_SYMBOL_GPL(ata_sff_interrupt);
 
 /**
+ *	ata_sff_lost_interrupt	-	Check for an apparent lost interrupt
+ *	@ap: port that appears to have timed out
+ *
+ *	Called from the libata error handlers when the core code suspects
+ *	an interrupt has been lost. If it has complete anything we can and
+ *	then return. Interface must support altstatus for this faster
+ *	recovery to occur.
+ *
+ *	Locking:
+ *	Caller holds host lock
+ */
+
+void ata_sff_lost_interrupt(struct ata_port *ap)
+{
+	u8 status;
+	struct ata_queued_cmd *qc;
+
+	/* Only one outstanding command per SFF channel */
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	/* Check we have a live one.. */
+	if (qc == NULL ||  !(qc->flags & ATA_QCFLAG_ACTIVE))
+		return;
+	/* We cannot lose an interrupt on a polled command */
+	if (qc->tf.flags & ATA_TFLAG_POLLING)
+		return;
+	/* See if the controller thinks it is still busy - if so the command
+	   isn't a lost IRQ but is still in progress */
+	status = ata_sff_altstatus(ap);
+	if (status & ATA_BUSY)
+		return;
+
+	/* There was a command running, we are no longer busy and we have
+	   no interrupt. */
+	ata_port_printk(ap, KERN_WARNING, "lost interrupt (Status 0x%x)\n",
+								status);
+	/* Run the host interrupt logic as if the interrupt had not been
+	   lost */
+	ata_sff_host_intr(ap, qc);
+}
+EXPORT_SYMBOL_GPL(ata_sff_lost_interrupt);
+
+/**
  *	ata_sff_freeze - Freeze SFF controller port
  *	@ap: port to freeze
  *
@@ -2199,6 +2244,39 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
 
 /**
+ *	ata_sff_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@qc: command
+ *
+ *	Drain the FIFO and device of any stuck data following a command
+ *	failing to complete. In some cases this is neccessary before a
+ *	reset will recover the device.
+ *
+ */
+
+void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
+{
+	int count;
+	struct ata_port *ap;
+
+	/* We only need to flush incoming data when a command was running */
+	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
+		return;
+
+	ap = qc->ap;
+	/* Drain up to 64K of data before we give up this recovery method */
+	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
+						&& count < 32768; count++)
+		ioread16(ap->ioaddr.data_addr);
+
+	/* Can become DEBUG later */
+	if (count)
+		ata_port_printk(ap, KERN_DEBUG,
+			"drained %d bytes to clear DRQ.\n", count);
+
+}
+EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
+
+/**
  *	ata_sff_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2239,7 +2317,8 @@ void ata_sff_error_handler(struct ata_port *ap)
 		 * really a timeout event, adjust error mask and
 		 * cancel frozen state.
 		 */
-		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
+		if (qc->err_mask == AC_ERR_TIMEOUT
+						&& (host_stat & ATA_DMA_ERR)) {
 			qc->err_mask = AC_ERR_HOST_BUS;
 			thaw = 1;
 		}
@@ -2250,6 +2329,13 @@ void ata_sff_error_handler(struct ata_port *ap)
 	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
+	/* We *MUST* do FIFO draining before we issue a reset as several
+	 * devices helpfully clear their internal state and will lock solid
+	 * if we touch the data port post reset. Pass qc in case anyone wants
+	 *  to do different PIO/DMA recovery or has per command fixups
+	 */
+	if (ap->ops->drain_fifo)
+		ap->ops->drain_fifo(qc);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -2959,4 +3045,3 @@ out:
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
-
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index cea8014..89a1e00 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -79,8 +79,6 @@ extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
 extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
-extern void ata_pio_queue_task(struct ata_port *ap, void *data,
-			       unsigned long delay);
 extern void ata_port_flush_task(struct ata_port *ap);
 extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 8b77a98..d8f35fe 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -246,9 +246,9 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x7f,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask 	= ATA_UDMA6,
 
 		.port_ops	= &pacpi_ops,
 	};
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index eb99dbe..751b7ea 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -492,53 +492,53 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_early = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &ali_early_port_ops
 	};
 	/* Revision 0x20 added DMA */
 	static const struct ata_port_info info_20 = {
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0x20 with support logic added UDMA */
 	static const struct ata_port_info info_20_udma = {
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x07,	/* UDMA33 */
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0xC2 adds UDMA66 */
 	static const struct ata_port_info info_c2 = {
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA66 for now */
 	static const struct ata_port_info info_c3 = {
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA100 */
 	static const struct ata_port_info info_c4 = {
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &ali_c4_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
 	static const struct ata_port_info info_c5 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &ali_c5_port_ops
 	};
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 115b1cd..33a74f1 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -455,74 +455,74 @@ static void amd_clear_fifo(struct pci_dev *pdev)
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[10] = {
-		{	/* 0: AMD 7401 */
+		{	/* 0: AMD 7401 - no swdma */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,	/* No SWDMA */
-			.udma_mask = 0x07,	/* UDMA 33 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA2,
 			.port_ops = &amd33_port_ops
 		},
 		{	/* 1: Early AMD7409 - no swdma */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &amd66_port_ops
 		},
-		{	/* 2: AMD 7409, no swdma errata */
+		{	/* 2: AMD 7409 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 3: AMD 7411 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 4: AMD 7441 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &amd100_port_ops
 		},
-		{	/* 5: AMD 8111*/
+		{	/* 5: AMD 8111 - no swdma */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA6,
 			.port_ops = &amd133_port_ops
 		},
-		{	/* 6: AMD 8111 UDMA 100 (Serenade) */
+		{	/* 6: AMD 8111 UDMA 100 (Serenade) - no swdma */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA5,	/* UDMA 100, no swdma */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 7: Nvidia Nforce */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &nv100_port_ops
 		},
-		{	/* 8: Nvidia Nforce2 and later */
+		{	/* 8: Nvidia Nforce2 and later - no swdma */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA6,
 			.port_ops = &nv133_port_ops
 		},
 		{	/* 9: AMD CS5536 (Geode companion) */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &amd100_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 6b3092c..d332cfd 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -12,7 +12,6 @@
  *		performance Alessandro Zummo <alessandro.zummo@towertech.it>
  *
  *	TODO
- *	850 serialization once the core supports it
  *	Investigate no_dsc on 850R
  *	Clock detect
  */
@@ -29,7 +28,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.4"
+#define DRV_VERSION	"0.4.5"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -283,6 +282,31 @@ static void artop6260_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
 }
 
+/**
+ *	artop_6210_qc_defer	-	implement serialization
+ *	@qc: command
+ *
+ *	Issue commands per host on this chip.
+ */
+
+static int artop6210_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+
+	/* First apply the usual rules */
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	/* Now apply serialization rules. Only allow a command if the
+	   other channel state machine is idle */
+	if (alt && alt->qc_active)
+		return	ATA_DEFER_PORT;
+	return 0;
+}
+
 static struct scsi_host_template artop_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -293,6 +317,7 @@ static struct ata_port_operations artop6210_ops = {
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
 	.prereset		= artop6210_pre_reset,
+	.qc_defer		= artop6210_qc_defer,
 };
 
 static struct ata_port_operations artop6260_ops = {
@@ -323,29 +348,29 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	static int printed_version;
 	static const struct ata_port_info info_6210 = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA2,
 		.port_ops	= &artop6210_ops,
 	};
 	static const struct ata_port_info info_626x = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &artop6260_ops,
 	};
 	static const struct ata_port_info info_628x = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA5,
 		.port_ops	= &artop6260_ops,
 	};
 	static const struct ata_port_info info_628x_fast = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA6,
 		.port_ops	= &artop6260_ops,
 	};
@@ -362,12 +387,8 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (id->driver_data == 0) {	/* 6210 variant */
 		ppi[0] = &info_6210;
-		ppi[1] = &ata_dummy_port_info;
 		/* BIOS may have left us in UDMA, clear it before libata probe */
 		pci_write_config_byte(pdev, 0x54, 0);
-		/* For the moment (also lacks dsc) */
-		printk(KERN_WARNING "ARTOP 6210 requires serialize functionality not yet supported by libata.\n");
-		printk(KERN_WARNING "Secondary ATA ports will not be activated.\n");
 	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index ab61095..5c129f9 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -67,7 +67,9 @@
  *
  * Alter PIO_MASK below according to table to set maximal PIO mode.
  */
-#define PIO_MASK (0x1f)
+enum {
+  PIO_MASK = ATA_PIO4,
+};
 
 /*
  * Struct containing private information about device.
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 506adde..bec0b8a 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -220,9 +220,9 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x06,	/* No MWDMA0 support */
-		.udma_mask = 0x3F,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA12_ONLY,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &atiixp_port_ops
 	};
 	static const struct pci_bits atiixp_enable_bits[] = {
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 1050fed..c4b47a3 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1502,7 +1502,7 @@ static struct ata_port_info bfin_port_info[] = {
 		.flags		= ATA_FLAG_SLAVE_POSS
 				| ATA_FLAG_MMIO
 				| ATA_FLAG_NO_LEGACY,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= 0,
 		.udma_mask	= 0,
 		.port_ops	= &bfin_pata_ops,
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 34a3942..5acf9fa 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -211,7 +211,7 @@ static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &cmd640_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 3167d8f..f98dffe 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -299,40 +299,40 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info cmd_info[6] = {
 		{	/* CMD 643 - no UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with broken UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with working UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 rev 1  */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.port_ops = &cmd646r1_port_ops
 		},
 		{	/* CMD 648 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA4,
 			.port_ops = &cmd648_port_ops
 		},
 		{	/* CMD 649 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA5,
 			.port_ops = &cmd648_port_ops
 		}
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 1186bcd..db6a969 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -158,7 +158,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 	static const unsigned int ctl_port[] = { 0x3F6, 0x376 };
 	struct ata_port_info pi = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,
+		.pio_mask	= ATA_PIO4,
 		.port_ops	= &cs5520_port_ops,
 	};
 	const struct ata_port_info *ppi[2];
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index bba4533..c974b05 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -298,15 +298,15 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
 		.port_ops = &cs5530_port_ops
 	};
 	/* The docking connector doesn't do UDMA, and it seems not MWDMA */
 	static const struct ata_port_info info_palmax_secondary = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &cs5530_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 8b236af..d33aa28 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -181,8 +181,8 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA4,
 		.port_ops = &cs5535_port_ops
 	};
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index afed929..6da4cb4 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -241,8 +241,8 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &cs5536_port_ops,
 	};
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index d546425..8fb040b 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -124,8 +124,8 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &cy82c693_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index ac6392e..2085e0a 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -251,9 +251,9 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma1-2 */
-		.udma_mask 	= 0x0f, /* UDMA 66 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 65c28e5..d7f2da1 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -336,8 +336,8 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_hpt366 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA4,
 		.port_ops = &hpt366_port_ops
 	};
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4216399..81ab570 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -753,55 +753,55 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT370 - UDMA100 */
 	static const struct ata_port_info info_hpt370 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
 	static const struct ata_port_info info_hpt370a = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
 	static const struct ata_port_info info_hpt370_33 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
 	static const struct ata_port_info info_hpt370a_33 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
 	static const struct ata_port_info info_hpt372 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA100, function 1 uses different prereset method */
 	static const struct ata_port_info info_hpt374_fn0 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt372_port_ops
 	};
 	static const struct ata_port_info info_hpt374_fn1 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt374_fn1_port_ops
 	};
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index d5c9fd7..3d59fe0 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -441,8 +441,8 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT372N and friends - UDMA133 */
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt3x2n_port_ops
 	};
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index f19cc64..7e31025 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -188,11 +188,11 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 #if defined(CONFIG_PATA_HPT3X3_DMA)
 		/* Further debug needed */
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x07,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
 #endif
 		.port_ops = &hpt3x3_port_ops
 	};
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index cf9e984..e7347db 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -297,7 +297,7 @@ static int icside_dma_init(struct pata_icside_info *info)
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		state->dma = ec->dma;
-		info->mwdma_mask = 0x07;	/* MW0..2 */
+		info->mwdma_mask = ATA_MWDMA2;
 	}
 
 	return 0;
@@ -473,7 +473,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 	for (i = 0; i < info->nr_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		ap->pio_mask = 0x1f;
+		ap->pio_mask = ATA_PIO4;
 		ap->mwdma_mask = info->mwdma_mask;
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ops = &pata_icside_port_ops;
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 15cdb91..4bceb88 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -17,7 +17,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_isapnp"
-#define DRV_VERSION "0.2.2"
+#define DRV_VERSION "0.2.5"
 
 static struct scsi_host_template isapnp_sht = {
 	ATA_PIO_SHT(DRV_NAME),
@@ -28,6 +28,13 @@ static struct ata_port_operations isapnp_port_ops = {
 	.cable_detect	= ata_cable_40wire,
 };
 
+static struct ata_port_operations isapnp_noalt_port_ops = {
+	.inherits	= &ata_sff_port_ops,
+	.cable_detect	= ata_cable_40wire,
+	/* No altstatus so we don't want to use the lost interrupt poll */
+	.lost_interrupt = ATA_OP_NULL,
+};
+
 /**
  *	isapnp_init_one		-	attach an isapnp interface
  *	@idev: PnP device
@@ -65,8 +72,8 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 
 	ap = host->ports[0];
 
-	ap->ops = &isapnp_port_ops;
-	ap->pio_mask = 1;
+	ap->ops = &isapnp_noalt_port_ops;
+	ap->pio_mask = ATA_PIO0;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = cmd_addr;
@@ -76,6 +83,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 					   pnp_port_start(idev, 1), 1);
 		ap->ioaddr.altstatus_addr = ctl_addr;
 		ap->ioaddr.ctl_addr = ctl_addr;
+		ap->ops = &isapnp_port_ops;
 	}
 
 	ata_sff_std_ports(&ap->ioaddr);
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index c113d7c..f156da8 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -262,8 +262,8 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
 		.port_ops	= &it8213_ops,
 	};
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index b05b86a..188bc2f 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -875,29 +875,29 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	static const struct ata_port_info info_smart = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_smart_port_ops
 	};
 	static const struct ata_port_info info_passthru = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_passthru_port_ops
 	};
 	static const struct ata_port_info info_rdc = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_rdc_port_ops
 	};
 	static const struct ata_port_info info_rdc_11 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		/* No UDMA */
 		.port_ops = &it821x_rdc_port_ops
 	};
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index b173c15..19fdecf 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -176,7 +176,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	ap = host->ports[0];
 
 	ap->ops	= &ixp4xx_port_ops;
-	ap->pio_mask = 0x1f; /* PIO4 */
+	ap->pio_mask = ATA_PIO4;
 	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 38cf1ab..3a1474a 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -136,8 +136,8 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	static const struct ata_port_info info = {
 		.flags	= ATA_FLAG_SLAVE_POSS,
 
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &jmicron_ops,
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index e3bc1b4..3f830f0 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -129,7 +129,7 @@ static int qdi;			/* Set to probe QDI controllers */
 static int winbond;		/* Set to probe Winbond controllers,
 					give I/O port if non standard */
 static int autospeed;		/* Chip present which snoops speed changes */
-static int pio_mask = 0x1F;	/* PIO range for autospeed devices */
+static int pio_mask = ATA_PIO4;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
 /**
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 76e399b..2096fb7 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -126,8 +126,8 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &marvell_ops,
@@ -136,8 +136,8 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		/* Slave possible as its magically mapped not real */
 		.flags		= ATA_FLAG_SLAVE_POSS,
 
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA6,
 
 		.port_ops	= &marvell_ops,
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 50ae6d1..68d27bc 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -737,10 +737,10 @@ mpc52xx_ata_probe(struct of_device *op, const struct of_device_id *match)
 	 */
 	prop = of_get_property(op->node, "mwdma-mode", &proplen);
 	if ((prop) && (proplen >= 4))
-		mwdma_mask = 0x7 & ((1 << (*prop + 1)) - 1);
+		mwdma_mask = ATA_MWDMA2 & ((1 << (*prop + 1)) - 1);
 	prop = of_get_property(op->node, "udma-mode", &proplen);
 	if ((prop) && (proplen >= 4))
-		udma_mask = 0x7 & ((1 << (*prop + 1)) - 1);
+		udma_mask = ATA_UDMA2 & ((1 << (*prop + 1)) - 1);
 
 	ata_irq = irq_of_parse_and_map(op->node, 0);
 	if (ata_irq == NO_IRQ) {
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index aa576ca..b21f002 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -200,7 +200,7 @@ static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	   the MPIIX your box goes castors up */
 
 	ap->ops = &mpiix_port_ops;
-	ap->pio_mask = 0x1F;
+	ap->pio_mask = ATA_PIO4;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = cmd_addr;
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 9dc05e1..bdb2369 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -51,8 +51,8 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		/* Actually we don't really care about these as the
 		   firmware deals with it */
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA5, /* UDMA 133 */
 		.port_ops	= &netcell_ops,
 	};
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 4dd9a3b..0fb6b1b 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -136,7 +136,7 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!base)
 		return -ENOMEM;
 	ap->ops = &ninja32_port_ops;
-	ap->pio_mask = 0x1F;
+	ap->pio_mask = ATA_PIO4;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = base + 0x10;
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 40d411c..ca53fac 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -144,7 +144,7 @@ static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x0F,
+		.pio_mask = ATA_PIO3,
 		.port_ops = &ns87410_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 89bf5f8..773b159 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -346,8 +346,8 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.port_ops	= &ns87415_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
@@ -355,8 +355,8 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 #if defined(CONFIG_SUPERIO)
 	static const struct ata_port_info info87560 = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.port_ops	= &ns87560_pata_ops,
 	};
 
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 0fe4ef3..efe2c19 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -871,7 +871,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 	ap->private_data = cf_port;
 	cf_port->ap = ap;
 	ap->ops = &octeon_cf_ops;
-	ap->pio_mask = 0x7f; /* Support PIO 0-6 */
+	ap->pio_mask = ATA_PIO6;
 	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY
 		  | ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
 
@@ -900,7 +900,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 		ap->ioaddr.ctl_addr	= cs1 + (6 << 1) + 1;
 		octeon_cf_ops.sff_data_xfer = octeon_cf_data_xfer16;
 
-		ap->mwdma_mask	= 0x1f; /* Support MWDMA 0-4 */
+		ap->mwdma_mask	= ATA_MWDMA4;
 		irq = platform_get_irq(pdev, 0);
 		irq_handler = octeon_cf_interrupt;
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 2c1a91c..84ac503 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -238,8 +238,8 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma1-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.port_ops	= &oldpiix_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index e4fa4d5..99eddda 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -163,7 +163,7 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &opti_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 93bb6e9..86885a4 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -399,15 +399,15 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_82c700 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &optidma_port_ops
 	};
 	static const struct ata_port_info info_82c700_udma = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
 		.port_ops = &optiplus_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info_82c700, NULL };
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 64b2e22..f4d009e 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.3"
+#define DRV_VERSION "0.3.5"
 
 /*
  *	Private data structure to glue stuff together
@@ -126,6 +126,37 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
 	return buflen;
 }
 
+/**
+ *	pcmcia_8bit_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@qc: command
+ *
+ *	Drain the FIFO and device of any stuck data following a command
+ *	failing to complete. In some cases this is neccessary before a
+ *	reset will recover the device.
+ *
+ */
+ 
+void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
+{
+	int count;
+	struct ata_port *ap;
+
+	/* We only need to flush incoming data when a command was running */
+	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
+		return;
+
+	ap = qc->ap;
+
+	/* Drain up to 64K of data before we give up this recovery method */
+	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
+							&& count++ < 65536;)
+		ioread8(ap->ioaddr.data_addr);
+
+	if (count)
+		ata_port_printk(ap, KERN_WARNING, "drained %d bytes to clear DRQ.\n",
+								count);
+
+}
 
 static struct scsi_host_template pcmcia_sht = {
 	ATA_PIO_SHT(DRV_NAME),
@@ -143,6 +174,7 @@ static struct ata_port_operations pcmcia_8bit_port_ops = {
 	.sff_data_xfer	= ata_data_xfer_8bit,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= pcmcia_set_mode_8bit,
+	.drain_fifo	= pcmcia_8bit_drain_fifo,
 };
 
 #define CS_CHECK(fn, ret) \
@@ -299,7 +331,7 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 		ap = host->ports[p];
 
 		ap->ops = ops;
-		ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
+		ap->pio_mask = ATA_PIO0;	/* ISA so PIO 0 cycles */
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ioaddr.cmd_addr = io_addr + 0x10 * p;
 		ap->ioaddr.altstatus_addr = ctl_addr + 0x10 * p;
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index e94efcc..ca5cad0 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -152,18 +152,18 @@ static struct ata_port_info pdc2027x_port_info[] = {
 	{
 		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
 		                  ATA_FLAG_MMIO,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= ATA_UDMA5, /* udma0-5 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &pdc2027x_pata100_ops,
 	},
 	/* PDC_UDMA_133 */
 	{
 		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
                         	  ATA_FLAG_MMIO,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= ATA_UDMA6, /* udma0-6 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc2027x_pata133_ops,
 	},
 };
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 799a6a0..5fedb3d 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -291,22 +291,22 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	static const struct ata_port_info info[3] = {
 		{
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA2,
 			.port_ops = &pdc2024x_port_ops
 		},
 		{
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA4,
 			.port_ops = &pdc2026x_port_ops
 		},
 		{
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA5,
 			.port_ops = &pdc2026x_port_ops
 		}
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index f1b26f7..45879dc 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -212,11 +212,11 @@ static __init int qdi_init_one(unsigned long port, int type, unsigned long io, i
 
 	if (type == 6580) {
 		ap->ops = &qdi6580_port_ops;
-		ap->pio_mask = 0x1F;
+		ap->pio_mask = ATA_PIO4;
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 	} else {
 		ap->ops = &qdi6500_port_ops;
-		ap->pio_mask = 0x07;	/* Actually PIO3 !IORDY is possible */
+		ap->pio_mask = ATA_PIO2; /* Actually PIO3 !IORDY is possible */
 		ap->flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_IORDY;
 	}
 
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 695d44a..4401b33 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -216,9 +216,9 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma1-2 */
-		.udma_mask	= 0x14, /* UDMA33/66 only */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA24_ONLY,
 		.port_ops	= &radisys_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index ebfcda2..8e3cdef 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -48,63 +48,11 @@
 struct rb532_cf_info {
 	void __iomem	*iobase;
 	unsigned int	gpio_line;
-	int		frozen;
 	unsigned int	irq;
 };
 
 /* ------------------------------------------------------------------------ */
 
-static inline void rb532_pata_finish_io(struct ata_port *ap)
-{
-	struct ata_host *ah = ap->host;
-	struct rb532_cf_info *info = ah->private_data;
-
-	/* FIXME: Keep previous delay. If this is merely a fence then
-	   ata_sff_sync might be sufficient. */
-	ata_sff_dma_pause(ap);
-	ndelay(RB500_CF_IO_DELAY);
-}
-
-static void rb532_pata_exec_command(struct ata_port *ap,
-				const struct ata_taskfile *tf)
-{
-	writeb(tf->command, ap->ioaddr.command_addr);
-	rb532_pata_finish_io(ap);
-}
-
-static unsigned int rb532_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
-				unsigned int buflen, int write_data)
-{
-	struct ata_port *ap = adev->link->ap;
-	void __iomem *ioaddr = ap->ioaddr.data_addr;
-	int retlen = buflen;
-
-	if (write_data) {
-		for (; buflen > 0; buflen--, buf++)
-			writeb(*buf, ioaddr);
-	} else {
-		for (; buflen > 0; buflen--, buf++)
-			*buf = readb(ioaddr);
-	}
-
-	rb532_pata_finish_io(adev->link->ap);
-	return retlen;
-}
-
-static void rb532_pata_freeze(struct ata_port *ap)
-{
-	struct rb532_cf_info *info = ap->host->private_data;
-
-	info->frozen = 1;
-}
-
-static void rb532_pata_thaw(struct ata_port *ap)
-{
-	struct rb532_cf_info *info = ap->host->private_data;
-
-	info->frozen = 0;
-}
-
 static irqreturn_t rb532_pata_irq_handler(int irq, void *dev_instance)
 {
 	struct ata_host *ah = dev_instance;
@@ -112,8 +60,7 @@ static irqreturn_t rb532_pata_irq_handler(int irq, void *dev_instance)
 
 	if (gpio_get_value(info->gpio_line)) {
 		set_irq_type(info->irq, IRQ_TYPE_LEVEL_LOW);
-		if (!info->frozen)
-			ata_sff_interrupt(info->irq, dev_instance);
+		ata_sff_interrupt(info->irq, dev_instance);
 	} else {
 		set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
 	}
@@ -123,10 +70,7 @@ static irqreturn_t rb532_pata_irq_handler(int irq, void *dev_instance)
 
 static struct ata_port_operations rb532_pata_port_ops = {
 	.inherits		= &ata_sff_port_ops,
-	.sff_exec_command	= rb532_pata_exec_command,
-	.sff_data_xfer		= rb532_pata_data_xfer,
-	.freeze			= rb532_pata_freeze,
-	.thaw			= rb532_pata_thaw,
+	.sff_data_xfer		= ata_sff_data_xfer32,
 };
 
 /* ------------------------------------------------------------------------ */
@@ -145,7 +89,7 @@ static void rb532_pata_setup_ports(struct ata_host *ah)
 	ap = ah->ports[0];
 
 	ap->ops		= &rb532_pata_port_ops;
-	ap->pio_mask	= 0x1f; /* PIO4 */
+	ap->pio_mask	= ATA_PIO4;
 	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
 
 	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_BASE;
@@ -160,7 +104,7 @@ static void rb532_pata_setup_ports(struct ata_host *ah)
 
 static __devinit int rb532_pata_driver_probe(struct platform_device *pdev)
 {
-	unsigned int irq;
+	int irq;
 	int gpio;
 	struct resource *res;
 	struct ata_host *ah;
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 46d6bc1..0c574c0 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -88,7 +88,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &rz1000_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 9a4bdca..f49814d 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -2,7 +2,6 @@
  * New ATA layer SC1200 driver		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * TODO: Mode selection filtering
- * TODO: Can't enable second channel until ATA core has serialize
  * TODO: Needs custom DMA cleanup code
  *
  * Based very heavily on
@@ -178,6 +177,31 @@ static unsigned int sc1200_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
+/**
+ *	sc1200_qc_defer	-	implement serialization
+ *	@qc: command
+ *
+ *	Serialize command issue on this controller.
+ */
+
+static int sc1200_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+
+	/* First apply the usual rules */
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	/* Now apply serialization rules. Only allow a command if the
+	   other channel state machine is idle */
+	if (alt && alt->qc_active)
+		return	ATA_DEFER_PORT;
+	return 0;
+}
+
 static struct scsi_host_template sc1200_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_DUMB_MAX_PRD,
@@ -187,6 +211,7 @@ static struct ata_port_operations sc1200_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue,
+	.qc_defer	= sc1200_qc_defer,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= sc1200_set_piomode,
 	.set_dmamode	= sc1200_set_dmamode,
@@ -205,13 +230,13 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
 	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	const struct ata_port_info *ppi[] = { &info, };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index d447f1c..4257d6b 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1001,8 +1001,8 @@ static struct ata_port_operations scc_pata_ops = {
 static struct ata_port_info scc_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY,
-		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x00,
+		.pio_mask	= ATA_PIO4,
+		/* No MWDMA */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &scc_pata_ops,
 	},
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 6aeeeeb..99cceb4 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -84,9 +84,9 @@ static struct ata_port_operations sch_pata_ops = {
 
 static struct ata_port_info sch_port_info = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= ATA_PIO4,   /* pio0-4 */
-	.mwdma_mask	= ATA_MWDMA2, /* mwdma0-2 */
-	.udma_mask	= ATA_UDMA5,  /* udma0-5 */
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &sch_pata_ops,
 };
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 8d2fd9d..beaed12 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -398,26 +398,26 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	static const struct ata_port_info info[4] = {
 		{ /* OSB4 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			.udma_mask = ATA_UDMA2,
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* OSB4 no UDMA */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
-			.udma_mask = 0x00,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
+			/* No UDMA */
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* CSB5 */
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA4,
 			.port_ops = &serverworks_csb_port_ops
 		}, { /* CSB5 - later revisions*/
 			.flags = ATA_FLAG_SLAVE_POSS,
-			.pio_mask = 0x1f,
-			.mwdma_mask = 0x07,
+			.pio_mask = ATA_PIO4,
+			.mwdma_mask = ATA_MWDMA2,
 			.udma_mask = ATA_UDMA5,
 			.port_ops = &serverworks_csb_port_ops
 		}
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 9e764e5..4cb649d 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -282,15 +282,15 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &sil680_port_ops
 	};
 	static const struct ata_port_info info_slow = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &sil680_port_ops
 	};
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 27ceb42..488e77b 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -552,51 +552,57 @@ static struct ata_port_operations sis_old_ops = {
 
 static const struct ata_port_info sis_info = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
-	.mwdma_mask	= 0x07,
-	.udma_mask	= 0,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	/* No UDMA */
 	.port_ops	= &sis_old_ops,
 };
 static const struct ata_port_info sis_info33 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
-	.mwdma_mask	= 0x07,
-	.udma_mask	= ATA_UDMA2,	/* UDMA 33 */
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA2,
 	.port_ops	= &sis_old_ops,
 };
 static const struct ata_port_info sis_info66 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
-	.udma_mask	= ATA_UDMA4,	/* UDMA 66 */
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
+	.udma_mask	= ATA_UDMA4,
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info100 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &sis_100_ops,
 };
 static const struct ata_port_info sis_info100_early = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA5,
-	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info133 = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
 const struct ata_port_info sis_info133_for_sata = {
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
-	.pio_mask	= 0x1f,	/* pio0-4 */
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_for_sata_ops,
 };
 static const struct ata_port_info sis_info133_early = {
 	.flags		= ATA_FLAG_SLAVE_POSS,
-	.pio_mask	= 0x1f,	/* pio0-4 */
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_early_ops,
 };
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 1b0e7b6..29f733c 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -283,13 +283,13 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 {
 	static const struct ata_port_info info_dma = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &sl82c105_port_ops
 	};
 	static const struct ata_port_info info_early = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
+		.pio_mask = ATA_PIO4,
 		.port_ops = &sl82c105_port_ops
 	};
 	/* for now use only the first port */
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index ef95975..f1f13ff 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -191,8 +191,8 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &triflex_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ba556d3..b08e6e0 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -422,46 +422,46 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Early VIA without UDMA support */
 	static const struct ata_port_info via_mwdma_info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &via_port_ops
 	};
 	/* Ditto with IRQ masking required */
 	static const struct ata_port_info via_mwdma_info_borked = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.port_ops = &via_port_ops_noirq,
 	};
 	/* VIA UDMA 33 devices (and borked 66) */
 	static const struct ata_port_info via_udma33_info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 66 devices */
 	static const struct ata_port_info via_udma66_info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA4,
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 100 devices */
 	static const struct ata_port_info via_udma100_info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &via_port_ops
 	};
 	/* UDMA133 with bad AST (All current 133) */
 	static const struct ata_port_info via_udma133_info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = ATA_MWDMA2,
 		.udma_mask = ATA_UDMA6,	/* FIXME: should check north bridge */
 		.port_ops = &via_port_ops
 	};
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 319e164..6d8619b 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -193,7 +193,7 @@ static __init int winbond_init_one(unsigned long port)
 		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", cmd_port, ctl_port);
 
 		ap->ops = &winbond_port_ops;
-		ap->pio_mask = 0x1F;
+		ap->pio_mask = ATA_PIO4;
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ioaddr.cmd_addr = cmd_addr;
 		ap->ioaddr.altstatus_addr = ctl_addr;
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index be53545..3958817 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -148,6 +148,8 @@ static struct scsi_host_template adma_ata_sht = {
 static struct ata_port_operations adma_ata_ops = {
 	.inherits		= &ata_sff_port_ops,
 
+	.lost_interrupt		= ATA_OP_NULL,
+
 	.check_atapi_dma	= adma_check_atapi_dma,
 	.qc_prep		= adma_qc_prep,
 	.qc_issue		= adma_qc_issue,
@@ -166,7 +168,7 @@ static struct ata_port_info adma_port_info[] = {
 		.flags		= ATA_FLAG_SLAVE_POSS |
 				  ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
 				  ATA_FLAG_PIO_POLLING,
-		.pio_mask	= 0x10, /* pio4 */
+		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &adma_ata_ops,
 	},
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 55bc88c..c2e90e1 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1279,8 +1279,8 @@ static struct ata_port_operations sata_fsl_ops = {
 static const struct ata_port_info sata_fsl_port_info[] = {
 	{
 	 .flags = SATA_FSL_HOST_FLAGS,
-	 .pio_mask = 0x1f,	/* pio 0-4 */
-	 .udma_mask = 0x7f,	/* udma 0-6 */
+	 .pio_mask = ATA_PIO4,
+	 .udma_mask = ATA_UDMA6,
 	 .port_ops = &sata_fsl_ops,
 	 },
 };
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index fbbd87c..305a4f8 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -744,8 +744,8 @@ static struct ata_port_operations inic_port_ops = {
 
 static struct ata_port_info inic_port_info = {
 	.flags			= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
-	.pio_mask		= 0x1f,	/* pio0-4 */
-	.mwdma_mask		= 0x07, /* mwdma0-2 */
+	.pio_mask		= ATA_PIO4,
+	.mwdma_mask		= ATA_MWDMA2,
 	.udma_mask		= ATA_UDMA6,
 	.port_ops		= &inic_port_ops
 };
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 74b1080..a377226 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1,10 +1,13 @@
 /*
  * sata_mv.c - Marvell SATA support
  *
- * Copyright 2008: Marvell Corporation, all rights reserved.
+ * Copyright 2008-2009: Marvell Corporation, all rights reserved.
  * Copyright 2005: EMC Corporation, all rights reserved.
  * Copyright 2005 Red Hat, Inc.  All rights reserved.
  *
+ * Originally written by Brett Russ.
+ * Extensive overhaul and enhancement by Mark Lord <mlord@pobox.com>.
+ *
  * Please ALWAYS copy linux-ide@vger.kernel.org on emails.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -25,20 +28,13 @@
 /*
  * sata_mv TODO list:
  *
- * --> Errata workaround for NCQ device errors.
- *
  * --> More errata workarounds for PCI-X.
  *
  * --> Complete a full errata audit for all chipsets to identify others.
  *
- * --> ATAPI support (Marvell claims the 60xx/70xx chips can do it).
- *
  * --> Develop a low-power-consumption strategy, and implement it.
  *
- * --> [Experiment, low priority] Investigate interrupt coalescing.
- *       Quite often, especially with PCI Message Signalled Interrupts (MSI),
- *       the overhead reduced by interrupt mitigation is quite often not
- *       worth the latency cost.
+ * --> Add sysfs attributes for per-chip / per-HC IRQ coalescing thresholds.
  *
  * --> [Experiment, Marvell value added] Is it possible to use target
  *       mode to cross-connect two Linux boxes with Marvell cards?  If so,
@@ -68,7 +64,27 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.25"
+#define DRV_VERSION	"1.27"
+
+/*
+ * module options
+ */
+
+static int msi;
+#ifdef CONFIG_PCI
+module_param(msi, int, S_IRUGO);
+MODULE_PARM_DESC(msi, "Enable use of PCI MSI (0=off, 1=on)");
+#endif
+
+static int irq_coalescing_io_count;
+module_param(irq_coalescing_io_count, int, S_IRUGO);
+MODULE_PARM_DESC(irq_coalescing_io_count,
+		 "IRQ coalescing I/O count threshold (0..255)");
+
+static int irq_coalescing_usecs;
+module_param(irq_coalescing_usecs, int, S_IRUGO);
+MODULE_PARM_DESC(irq_coalescing_usecs,
+		 "IRQ coalescing time threshold in usecs");
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -79,13 +95,32 @@ enum {
 	MV_MAJOR_REG_AREA_SZ	= 0x10000,	/* 64KB */
 	MV_MINOR_REG_AREA_SZ	= 0x2000,	/* 8KB */
 
+	/* For use with both IRQ coalescing methods ("all ports" or "per-HC" */
+	COAL_CLOCKS_PER_USEC	= 150,		/* for calculating COAL_TIMEs */
+	MAX_COAL_TIME_THRESHOLD	= ((1 << 24) - 1), /* internal clocks count */
+	MAX_COAL_IO_COUNT	= 255,		/* completed I/O count */
+
 	MV_PCI_REG_BASE		= 0,
-	MV_IRQ_COAL_REG_BASE	= 0x18000,	/* 6xxx part only */
-	MV_IRQ_COAL_CAUSE		= (MV_IRQ_COAL_REG_BASE + 0x08),
-	MV_IRQ_COAL_CAUSE_LO		= (MV_IRQ_COAL_REG_BASE + 0x88),
-	MV_IRQ_COAL_CAUSE_HI		= (MV_IRQ_COAL_REG_BASE + 0x8c),
-	MV_IRQ_COAL_THRESHOLD		= (MV_IRQ_COAL_REG_BASE + 0xcc),
-	MV_IRQ_COAL_TIME_THRESHOLD	= (MV_IRQ_COAL_REG_BASE + 0xd0),
+
+	/*
+	 * Per-chip ("all ports") interrupt coalescing feature.
+	 * This is only for GEN_II / GEN_IIE hardware.
+	 *
+	 * Coalescing defers the interrupt until either the IO_THRESHOLD
+	 * (count of completed I/Os) is met, or the TIME_THRESHOLD is met.
+	 */
+	MV_COAL_REG_BASE	= 0x18000,
+	MV_IRQ_COAL_CAUSE	= (MV_COAL_REG_BASE + 0x08),
+	ALL_PORTS_COAL_IRQ	= (1 << 4),	/* all ports irq event */
+
+	MV_IRQ_COAL_IO_THRESHOLD   = (MV_COAL_REG_BASE + 0xcc),
+	MV_IRQ_COAL_TIME_THRESHOLD = (MV_COAL_REG_BASE + 0xd0),
+
+	/*
+	 * Registers for the (unused here) transaction coalescing feature:
+	 */
+	MV_TRAN_COAL_CAUSE_LO	= (MV_COAL_REG_BASE + 0x88),
+	MV_TRAN_COAL_CAUSE_HI	= (MV_COAL_REG_BASE + 0x8c),
 
 	MV_SATAHC0_REG_BASE	= 0x20000,
 	MV_FLASH_CTL_OFS	= 0x1046c,
@@ -117,17 +152,16 @@ enum {
 
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
-	MV_FLAG_IRQ_COALESCE	= (1 << 29),  /* IRQ coalescing capability */
 
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
-				  ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
+
+	MV_GEN_I_FLAGS		= MV_COMMON_FLAGS | ATA_FLAG_NO_ATAPI,
 
-	MV_6XXX_FLAGS		= MV_FLAG_IRQ_COALESCE,
+	MV_GEN_II_FLAGS		= MV_COMMON_FLAGS | ATA_FLAG_NCQ |
+				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA,
 
-	MV_GENIIE_FLAGS		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ | ATA_FLAG_AN,
+	MV_GEN_IIE_FLAGS	= MV_GEN_II_FLAGS | ATA_FLAG_AN,
 
 	CRQB_FLAG_READ		= (1 << 0),
 	CRQB_TAG_SHIFT		= 1,
@@ -180,16 +214,18 @@ enum {
 	PCI_HC_MAIN_IRQ_MASK_OFS  = 0x1d64,
 	SOC_HC_MAIN_IRQ_CAUSE_OFS = 0x20020,
 	SOC_HC_MAIN_IRQ_MASK_OFS  = 0x20024,
-	ERR_IRQ			= (1 << 0),	/* shift by port # */
-	DONE_IRQ		= (1 << 1),	/* shift by port # */
+	ERR_IRQ			= (1 << 0),	/* shift by (2 * port #) */
+	DONE_IRQ		= (1 << 1),	/* shift by (2 * port #) */
 	HC0_IRQ_PEND		= 0x1ff,	/* bits 0-8 = HC0's ports */
 	HC_SHIFT		= 9,		/* bits 9-17 = HC1's ports */
+	DONE_IRQ_0_3		= 0x000000aa,	/* DONE_IRQ ports 0,1,2,3 */
+	DONE_IRQ_4_7		= (DONE_IRQ_0_3 << HC_SHIFT),  /* 4,5,6,7 */
 	PCI_ERR			= (1 << 18),
-	TRAN_LO_DONE		= (1 << 19),	/* 6xxx: IRQ coalescing */
-	TRAN_HI_DONE		= (1 << 20),	/* 6xxx: IRQ coalescing */
-	PORTS_0_3_COAL_DONE	= (1 << 8),
-	PORTS_4_7_COAL_DONE	= (1 << 17),
-	PORTS_0_7_COAL_DONE	= (1 << 21),	/* 6xxx: IRQ coalescing */
+	TRAN_COAL_LO_DONE	= (1 << 19),	/* transaction coalescing */
+	TRAN_COAL_HI_DONE	= (1 << 20),	/* transaction coalescing */
+	PORTS_0_3_COAL_DONE	= (1 << 8),	/* HC0 IRQ coalescing */
+	PORTS_4_7_COAL_DONE	= (1 << 17),	/* HC1 IRQ coalescing */
+	ALL_PORTS_COAL_DONE	= (1 << 21),	/* GEN_II(E) IRQ coalescing */
 	GPIO_INT		= (1 << 22),
 	SELF_INT		= (1 << 23),
 	TWSI_INT		= (1 << 24),
@@ -205,6 +241,21 @@ enum {
 	HC_COAL_IRQ		= (1 << 4),	/* IRQ coalescing */
 	DEV_IRQ			= (1 << 8),	/* shift by port # */
 
+	/*
+	 * Per-HC (Host-Controller) interrupt coalescing feature.
+	 * This is present on all chip generations.
+	 *
+	 * Coalescing defers the interrupt until either the IO_THRESHOLD
+	 * (count of completed I/Os) is met, or the TIME_THRESHOLD is met.
+	 */
+	HC_IRQ_COAL_IO_THRESHOLD_OFS	= 0x000c,
+	HC_IRQ_COAL_TIME_THRESHOLD_OFS	= 0x0010,
+
+	SOC_LED_CTRL_OFS	= 0x2c,
+	SOC_LED_CTRL_BLINK	= (1 << 0),	/* Active LED blink */
+	SOC_LED_CTRL_ACT_PRESENCE = (1 << 2),	/* Multiplex dev presence */
+						/*  with dev activity LED */
+
 	/* Shadow block registers */
 	SHD_BLK_OFS		= 0x100,
 	SHD_CTL_AST_OFS		= 0x20,		/* ofs from SHD_BLK_OFS */
@@ -346,6 +397,12 @@ enum {
 	EDMA_ARB_CFG_OFS	= 0x38,
 
 	EDMA_HALTCOND_OFS	= 0x60,		/* GenIIe halt conditions */
+	EDMA_UNKNOWN_RSVD_OFS	= 0x6C,		/* GenIIe unknown/reserved */
+
+	BMDMA_CMD_OFS		= 0x224,	/* bmdma command register */
+	BMDMA_STATUS_OFS	= 0x228,	/* bmdma status register */
+	BMDMA_PRD_LOW_OFS	= 0x22c,	/* bmdma PRD addr 31:0 */
+	BMDMA_PRD_HIGH_OFS	= 0x230,	/* bmdma PRD addr 63:32 */
 
 	/* Host private flags (hp_flags) */
 	MV_HP_FLAG_MSI		= (1 << 0),
@@ -359,12 +416,14 @@ enum {
 	MV_HP_PCIE		= (1 << 9),	/* PCIe bus/regs: 7042 */
 	MV_HP_CUT_THROUGH	= (1 << 10),	/* can use EDMA cut-through */
 	MV_HP_FLAG_SOC		= (1 << 11),	/* SystemOnChip, no PCI */
+	MV_HP_QUIRK_LED_BLINK_EN = (1 << 12),	/* is led blinking enabled? */
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
 	MV_PP_FLAG_NCQ_EN	= (1 << 1),	/* is EDMA set up for NCQ? */
 	MV_PP_FLAG_FBS_EN	= (1 << 2),	/* is EDMA set up for FBS? */
 	MV_PP_FLAG_DELAYED_EH	= (1 << 3),	/* delayed dev err handling */
+	MV_PP_FLAG_FAKE_ATA_BUSY = (1 << 4),	/* ignore initial ATA_DRDY */
 };
 
 #define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
@@ -433,6 +492,18 @@ struct mv_sg {
 	__le32			reserved;
 };
 
+/*
+ * We keep a local cache of a few frequently accessed port
+ * registers here, to avoid having to read them (very slow)
+ * when switching between EDMA and non-EDMA modes.
+ */
+struct mv_cached_regs {
+	u32			fiscfg;
+	u32			ltmode;
+	u32			haltcond;
+	u32			unknown_rsvd;
+};
+
 struct mv_port_priv {
 	struct mv_crqb		*crqb;
 	dma_addr_t		crqb_dma;
@@ -445,6 +516,7 @@ struct mv_port_priv {
 	unsigned int		resp_idx;
 
 	u32			pp_flags;
+	struct mv_cached_regs	cached;
 	unsigned int		delayed_eh_pmp_map;
 };
 
@@ -535,7 +607,7 @@ static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
 static int mv_stop_edma(struct ata_port *ap);
 static int mv_stop_edma_engine(void __iomem *port_mmio);
-static void mv_edma_cfg(struct ata_port *ap, int want_ncq);
+static void mv_edma_cfg(struct ata_port *ap, int want_ncq, int want_edma);
 
 static void mv_pmp_select(struct ata_port *ap, int pmp);
 static int mv_pmp_hardreset(struct ata_link *link, unsigned int *class,
@@ -546,6 +618,14 @@ static void mv_pmp_error_handler(struct ata_port *ap);
 static void mv_process_crpb_entries(struct ata_port *ap,
 					struct mv_port_priv *pp);
 
+static void mv_sff_irq_clear(struct ata_port *ap);
+static int mv_check_atapi_dma(struct ata_queued_cmd *qc);
+static void mv_bmdma_setup(struct ata_queued_cmd *qc);
+static void mv_bmdma_start(struct ata_queued_cmd *qc);
+static void mv_bmdma_stop(struct ata_queued_cmd *qc);
+static u8   mv_bmdma_status(struct ata_port *ap);
+static u8 mv_sff_check_status(struct ata_port *ap);
+
 /* .sg_tablesize is (MV_MAX_SG_CT / 2) in the structures below
  * because we have to allow room for worst case splitting of
  * PRDs for 64K boundaries in mv_fill_sg().
@@ -566,6 +646,8 @@ static struct scsi_host_template mv6_sht = {
 static struct ata_port_operations mv5_ops = {
 	.inherits		= &ata_sff_port_ops,
 
+	.lost_interrupt		= ATA_OP_NULL,
+
 	.qc_defer		= mv_qc_defer,
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
@@ -593,6 +675,14 @@ static struct ata_port_operations mv6_ops = {
 	.pmp_softreset		= mv_softreset,
 	.softreset		= mv_softreset,
 	.error_handler		= mv_pmp_error_handler,
+
+	.sff_check_status	= mv_sff_check_status,
+	.sff_irq_clear		= mv_sff_irq_clear,
+	.check_atapi_dma	= mv_check_atapi_dma,
+	.bmdma_setup		= mv_bmdma_setup,
+	.bmdma_start		= mv_bmdma_start,
+	.bmdma_stop		= mv_bmdma_stop,
+	.bmdma_status		= mv_bmdma_status,
 };
 
 static struct ata_port_operations mv_iie_ops = {
@@ -603,53 +693,49 @@ static struct ata_port_operations mv_iie_ops = {
 
 static const struct ata_port_info mv_port_info[] = {
 	{  /* chip_504x */
-		.flags		= MV_COMMON_FLAGS,
+		.flags		= MV_GEN_I_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
-		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
+		.flags		= MV_GEN_I_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
-		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
+		.flags		= MV_GEN_I_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ,
+		.flags		= MV_GEN_II_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  ATA_FLAG_PMP | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_NCQ | MV_FLAG_DUAL_HC,
+		.flags		= MV_GEN_II_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
-		.flags		= MV_GENIIE_FLAGS,
+		.flags		= MV_GEN_IIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
-		.flags		= MV_GENIIE_FLAGS,
+		.flags		= MV_GEN_IIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_soc */
-		.flags		= MV_GENIIE_FLAGS,
+		.flags		= MV_GEN_IIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -794,6 +880,44 @@ static inline int mv_get_hc_count(unsigned long port_flags)
 	return ((port_flags & MV_FLAG_DUAL_HC) ? 2 : 1);
 }
 
+/**
+ *      mv_save_cached_regs - (re-)initialize cached port registers
+ *      @ap: the port whose registers we are caching
+ *
+ *	Initialize the local cache of port registers,
+ *	so that reading them over and over again can
+ *	be avoided on the hotter paths of this driver.
+ *	This saves a few microseconds each time we switch
+ *	to/from EDMA mode to perform (eg.) a drive cache flush.
+ */
+static void mv_save_cached_regs(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	struct mv_port_priv *pp = ap->private_data;
+
+	pp->cached.fiscfg = readl(port_mmio + FISCFG_OFS);
+	pp->cached.ltmode = readl(port_mmio + LTMODE_OFS);
+	pp->cached.haltcond = readl(port_mmio + EDMA_HALTCOND_OFS);
+	pp->cached.unknown_rsvd = readl(port_mmio + EDMA_UNKNOWN_RSVD_OFS);
+}
+
+/**
+ *      mv_write_cached_reg - write to a cached port register
+ *      @addr: hardware address of the register
+ *      @old: pointer to cached value of the register
+ *      @new: new value for the register
+ *
+ *	Write a new value to a cached register,
+ *	but only if the value is different from before.
+ */
+static inline void mv_write_cached_reg(void __iomem *addr, u32 *old, u32 new)
+{
+	if (new != *old) {
+		*old = new;
+		writel(new, addr);
+	}
+}
+
 static void mv_set_edma_ptrs(void __iomem *port_mmio,
 			     struct mv_host_priv *hpriv,
 			     struct mv_port_priv *pp)
@@ -825,6 +949,23 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
 
+static void mv_write_main_irq_mask(u32 mask, struct mv_host_priv *hpriv)
+{
+	/*
+	 * When writing to the main_irq_mask in hardware,
+	 * we must ensure exclusivity between the interrupt coalescing bits
+	 * and the corresponding individual port DONE_IRQ bits.
+	 *
+	 * Note that this register is really an "IRQ enable" register,
+	 * not an "IRQ mask" register as Marvell's naming might suggest.
+	 */
+	if (mask & (ALL_PORTS_COAL_DONE | PORTS_0_3_COAL_DONE))
+		mask &= ~DONE_IRQ_0_3;
+	if (mask & (ALL_PORTS_COAL_DONE | PORTS_4_7_COAL_DONE))
+		mask &= ~DONE_IRQ_4_7;
+	writelfl(mask, hpriv->main_irq_mask_addr);
+}
+
 static void mv_set_main_irq_mask(struct ata_host *host,
 				 u32 disable_bits, u32 enable_bits)
 {
@@ -835,7 +976,7 @@ static void mv_set_main_irq_mask(struct ata_host *host,
 	new_mask = (old_mask & ~disable_bits) | enable_bits;
 	if (new_mask != old_mask) {
 		hpriv->main_irq_mask = new_mask;
-		writelfl(new_mask, hpriv->main_irq_mask_addr);
+		mv_write_main_irq_mask(new_mask, hpriv);
 	}
 }
 
@@ -852,8 +993,94 @@ static void mv_enable_port_irqs(struct ata_port *ap,
 	mv_set_main_irq_mask(ap->host, disable_bits, enable_bits);
 }
 
+static void mv_clear_and_enable_port_irqs(struct ata_port *ap,
+					  void __iomem *port_mmio,
+					  unsigned int port_irqs)
+{
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	int hardport = mv_hardport_from_port(ap->port_no);
+	void __iomem *hc_mmio = mv_hc_base_from_port(
+				mv_host_base(ap->host), ap->port_no);
+	u32 hc_irq_cause;
+
+	/* clear EDMA event indicators, if any */
+	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+	/* clear pending irq events */
+	hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
+	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+
+	/* clear FIS IRQ Cause */
+	if (IS_GEN_IIE(hpriv))
+		writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+
+	mv_enable_port_irqs(ap, port_irqs);
+}
+
+static void mv_set_irq_coalescing(struct ata_host *host,
+				  unsigned int count, unsigned int usecs)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->base, *hc_mmio;
+	u32 coal_enable = 0;
+	unsigned long flags;
+	unsigned int clks, is_dual_hc = hpriv->n_ports > MV_PORTS_PER_HC;
+	const u32 coal_disable = PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
+							ALL_PORTS_COAL_DONE;
+
+	/* Disable IRQ coalescing if either threshold is zero */
+	if (!usecs || !count) {
+		clks = count = 0;
+	} else {
+		/* Respect maximum limits of the hardware */
+		clks = usecs * COAL_CLOCKS_PER_USEC;
+		if (clks > MAX_COAL_TIME_THRESHOLD)
+			clks = MAX_COAL_TIME_THRESHOLD;
+		if (count > MAX_COAL_IO_COUNT)
+			count = MAX_COAL_IO_COUNT;
+	}
+
+	spin_lock_irqsave(&host->lock, flags);
+	mv_set_main_irq_mask(host, coal_disable, 0);
+
+	if (is_dual_hc && !IS_GEN_I(hpriv)) {
+		/*
+		 * GEN_II/GEN_IIE with dual host controllers:
+		 * one set of global thresholds for the entire chip.
+		 */
+		writel(clks,  mmio + MV_IRQ_COAL_TIME_THRESHOLD);
+		writel(count, mmio + MV_IRQ_COAL_IO_THRESHOLD);
+		/* clear leftover coal IRQ bit */
+		writel(~ALL_PORTS_COAL_IRQ, mmio + MV_IRQ_COAL_CAUSE);
+		if (count)
+			coal_enable = ALL_PORTS_COAL_DONE;
+		clks = count = 0; /* force clearing of regular regs below */
+	}
+
+	/*
+	 * All chips: independent thresholds for each HC on the chip.
+	 */
+	hc_mmio = mv_hc_base_from_port(mmio, 0);
+	writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD_OFS);
+	writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD_OFS);
+	writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE_OFS);
+	if (count)
+		coal_enable |= PORTS_0_3_COAL_DONE;
+	if (is_dual_hc) {
+		hc_mmio = mv_hc_base_from_port(mmio, MV_PORTS_PER_HC);
+		writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD_OFS);
+		writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD_OFS);
+		writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE_OFS);
+		if (count)
+			coal_enable |= PORTS_4_7_COAL_DONE;
+	}
+
+	mv_set_main_irq_mask(host, 0, coal_enable);
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
 /**
- *      mv_start_dma - Enable eDMA engine
+ *      mv_start_edma - Enable eDMA engine
  *      @base: port base address
  *      @pp: port private data
  *
@@ -863,7 +1090,7 @@ static void mv_enable_port_irqs(struct ata_port *ap,
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
+static void mv_start_edma(struct ata_port *ap, void __iomem *port_mmio,
 			 struct mv_port_priv *pp, u8 protocol)
 {
 	int want_ncq = (protocol == ATA_PROT_NCQ);
@@ -875,26 +1102,11 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 	}
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
 		struct mv_host_priv *hpriv = ap->host->private_data;
-		int hardport = mv_hardport_from_port(ap->port_no);
-		void __iomem *hc_mmio = mv_hc_base_from_port(
-					mv_host_base(ap->host), ap->port_no);
-		u32 hc_irq_cause;
-
-		/* clear EDMA event indicators, if any */
-		writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-		/* clear pending irq events */
-		hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
-		writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
-
-		mv_edma_cfg(ap, want_ncq);
-
-		/* clear FIS IRQ Cause */
-		if (IS_GEN_IIE(hpriv))
-			writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+		mv_edma_cfg(ap, want_ncq, 1);
 
 		mv_set_edma_ptrs(port_mmio, hpriv, pp);
-		mv_enable_port_irqs(ap, DONE_IRQ|ERR_IRQ);
+		mv_clear_and_enable_port_irqs(ap, port_mmio, DONE_IRQ|ERR_IRQ);
 
 		writelfl(EDMA_EN, port_mmio + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
@@ -952,6 +1164,7 @@ static int mv_stop_edma(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
+	int err = 0;
 
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN))
 		return 0;
@@ -959,9 +1172,10 @@ static int mv_stop_edma(struct ata_port *ap)
 	mv_wait_for_edma_empty_idle(ap);
 	if (mv_stop_edma_engine(port_mmio)) {
 		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
-		return -EIO;
+		err = -EIO;
 	}
-	return 0;
+	mv_edma_cfg(ap, 0, 0);
+	return err;
 }
 
 #ifdef ATA_DEBUG
@@ -1130,35 +1344,33 @@ static int mv_qc_defer(struct ata_queued_cmd *qc)
 	return ATA_DEFER_PORT;
 }
 
-static void mv_config_fbs(void __iomem *port_mmio, int want_ncq, int want_fbs)
+static void mv_config_fbs(struct ata_port *ap, int want_ncq, int want_fbs)
 {
-	u32 new_fiscfg, old_fiscfg;
-	u32 new_ltmode, old_ltmode;
-	u32 new_haltcond, old_haltcond;
+	struct mv_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio;
 
-	old_fiscfg   = readl(port_mmio + FISCFG_OFS);
-	old_ltmode   = readl(port_mmio + LTMODE_OFS);
-	old_haltcond = readl(port_mmio + EDMA_HALTCOND_OFS);
+	u32 fiscfg,   *old_fiscfg   = &pp->cached.fiscfg;
+	u32 ltmode,   *old_ltmode   = &pp->cached.ltmode;
+	u32 haltcond, *old_haltcond = &pp->cached.haltcond;
 
-	new_fiscfg   = old_fiscfg & ~(FISCFG_SINGLE_SYNC | FISCFG_WAIT_DEV_ERR);
-	new_ltmode   = old_ltmode & ~LTMODE_BIT8;
-	new_haltcond = old_haltcond | EDMA_ERR_DEV;
+	ltmode   = *old_ltmode & ~LTMODE_BIT8;
+	haltcond = *old_haltcond | EDMA_ERR_DEV;
 
 	if (want_fbs) {
-		new_fiscfg = old_fiscfg | FISCFG_SINGLE_SYNC;
-		new_ltmode = old_ltmode | LTMODE_BIT8;
+		fiscfg = *old_fiscfg | FISCFG_SINGLE_SYNC;
+		ltmode = *old_ltmode | LTMODE_BIT8;
 		if (want_ncq)
-			new_haltcond &= ~EDMA_ERR_DEV;
+			haltcond &= ~EDMA_ERR_DEV;
 		else
-			new_fiscfg |=  FISCFG_WAIT_DEV_ERR;
+			fiscfg |=  FISCFG_WAIT_DEV_ERR;
+	} else {
+		fiscfg = *old_fiscfg & ~(FISCFG_SINGLE_SYNC | FISCFG_WAIT_DEV_ERR);
 	}
 
-	if (new_fiscfg != old_fiscfg)
-		writelfl(new_fiscfg, port_mmio + FISCFG_OFS);
-	if (new_ltmode != old_ltmode)
-		writelfl(new_ltmode, port_mmio + LTMODE_OFS);
-	if (new_haltcond != old_haltcond)
-		writelfl(new_haltcond, port_mmio + EDMA_HALTCOND_OFS);
+	port_mmio = mv_ap_base(ap);
+	mv_write_cached_reg(port_mmio + FISCFG_OFS, old_fiscfg, fiscfg);
+	mv_write_cached_reg(port_mmio + LTMODE_OFS, old_ltmode, ltmode);
+	mv_write_cached_reg(port_mmio + EDMA_HALTCOND_OFS, old_haltcond, haltcond);
 }
 
 static void mv_60x1_errata_sata25(struct ata_port *ap, int want_ncq)
@@ -1176,7 +1388,86 @@ static void mv_60x1_errata_sata25(struct ata_port *ap, int want_ncq)
 		writel(new, hpriv->base + MV_GPIO_PORT_CTL_OFS);
 }
 
-static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
+/**
+ *	mv_bmdma_enable - set a magic bit on GEN_IIE to allow bmdma
+ *	@ap: Port being initialized
+ *
+ *	There are two DMA modes on these chips:  basic DMA, and EDMA.
+ *
+ *	Bit-0 of the "EDMA RESERVED" register enables/disables use
+ *	of basic DMA on the GEN_IIE versions of the chips.
+ *
+ *	This bit survives EDMA resets, and must be set for basic DMA
+ *	to function, and should be cleared when EDMA is active.
+ */
+static void mv_bmdma_enable_iie(struct ata_port *ap, int enable_bmdma)
+{
+	struct mv_port_priv *pp = ap->private_data;
+	u32 new, *old = &pp->cached.unknown_rsvd;
+
+	if (enable_bmdma)
+		new = *old | 1;
+	else
+		new = *old & ~1;
+	mv_write_cached_reg(mv_ap_base(ap) + EDMA_UNKNOWN_RSVD_OFS, old, new);
+}
+
+/*
+ * SOC chips have an issue whereby the HDD LEDs don't always blink
+ * during I/O when NCQ is enabled. Enabling a special "LED blink" mode
+ * of the SOC takes care of it, generating a steady blink rate when
+ * any drive on the chip is active.
+ *
+ * Unfortunately, the blink mode is a global hardware setting for the SOC,
+ * so we must use it whenever at least one port on the SOC has NCQ enabled.
+ *
+ * We turn "LED blink" off when NCQ is not in use anywhere, because the normal
+ * LED operation works then, and provides better (more accurate) feedback.
+ *
+ * Note that this code assumes that an SOC never has more than one HC onboard.
+ */
+static void mv_soc_led_blink_enable(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *hc_mmio;
+	u32 led_ctrl;
+
+	if (hpriv->hp_flags & MV_HP_QUIRK_LED_BLINK_EN)
+		return;
+	hpriv->hp_flags |= MV_HP_QUIRK_LED_BLINK_EN;
+	hc_mmio = mv_hc_base_from_port(mv_host_base(host), ap->port_no);
+	led_ctrl = readl(hc_mmio + SOC_LED_CTRL_OFS);
+	writel(led_ctrl | SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL_OFS);
+}
+
+static void mv_soc_led_blink_disable(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *hc_mmio;
+	u32 led_ctrl;
+	unsigned int port;
+
+	if (!(hpriv->hp_flags & MV_HP_QUIRK_LED_BLINK_EN))
+		return;
+
+	/* disable led-blink only if no ports are using NCQ */
+	for (port = 0; port < hpriv->n_ports; port++) {
+		struct ata_port *this_ap = host->ports[port];
+		struct mv_port_priv *pp = this_ap->private_data;
+
+		if (pp->pp_flags & MV_PP_FLAG_NCQ_EN)
+			return;
+	}
+
+	hpriv->hp_flags &= ~MV_HP_QUIRK_LED_BLINK_EN;
+	hc_mmio = mv_hc_base_from_port(mv_host_base(host), ap->port_no);
+	led_ctrl = readl(hc_mmio + SOC_LED_CTRL_OFS);
+	writel(led_ctrl & ~SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL_OFS);
+}
+
+static void mv_edma_cfg(struct ata_port *ap, int want_ncq, int want_edma)
 {
 	u32 cfg;
 	struct mv_port_priv *pp    = ap->private_data;
@@ -1185,7 +1476,8 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
 
 	/* set up non-NCQ EDMA configuration */
 	cfg = EDMA_CFG_Q_DEPTH;		/* always 0x1f for *all* chips */
-	pp->pp_flags &= ~MV_PP_FLAG_FBS_EN;
+	pp->pp_flags &=
+	  ~(MV_PP_FLAG_FBS_EN | MV_PP_FLAG_NCQ_EN | MV_PP_FLAG_FAKE_ATA_BUSY);
 
 	if (IS_GEN_I(hpriv))
 		cfg |= (1 << 8);	/* enab config burst size mask */
@@ -1206,7 +1498,7 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
 		 */
 		want_fbs &= want_ncq;
 
-		mv_config_fbs(port_mmio, want_ncq, want_fbs);
+		mv_config_fbs(ap, want_ncq, want_fbs);
 
 		if (want_fbs) {
 			pp->pp_flags |= MV_PP_FLAG_FBS_EN;
@@ -1214,18 +1506,27 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
 		}
 
 		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
-		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
-		if (!IS_SOC(hpriv))
-			cfg |= (1 << 18);	/* enab early completion */
+		if (want_edma) {
+			cfg |= (1 << 22); /* enab 4-entry host queue cache */
+			if (!IS_SOC(hpriv))
+				cfg |= (1 << 18); /* enab early completion */
+		}
 		if (hpriv->hp_flags & MV_HP_CUT_THROUGH)
 			cfg |= (1 << 17); /* enab cut-thru (dis stor&forwrd) */
+		mv_bmdma_enable_iie(ap, !want_edma);
+
+		if (IS_SOC(hpriv)) {
+			if (want_ncq)
+				mv_soc_led_blink_enable(ap);
+			else
+				mv_soc_led_blink_disable(ap);
+		}
 	}
 
 	if (want_ncq) {
 		cfg |= EDMA_CFG_NCQ;
 		pp->pp_flags |=  MV_PP_FLAG_NCQ_EN;
-	} else
-		pp->pp_flags &= ~MV_PP_FLAG_NCQ_EN;
+	}
 
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
 }
@@ -1309,6 +1610,8 @@ static int mv_port_start(struct ata_port *ap)
 			pp->sg_tbl_dma[tag] = pp->sg_tbl_dma[0];
 		}
 	}
+	mv_save_cached_regs(ap);
+	mv_edma_cfg(ap, 0, 0);
 	return 0;
 
 out_port_free_dma_mem:
@@ -1357,12 +1660,13 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 			u32 offset = addr & 0xffff;
 			u32 len = sg_len;
 
-			if ((offset + sg_len > 0x10000))
+			if (offset + len > 0x10000)
 				len = 0x10000 - offset;
 
 			mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
 			mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
 			mv_sg->flags_size = cpu_to_le32(len & 0xffff);
+			mv_sg->reserved = 0;
 
 			sg_len -= len;
 			addr += len;
@@ -1374,6 +1678,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 
 	if (likely(last_sg))
 		last_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+	mb(); /* ensure data structure is visible to the chipset */
 }
 
 static void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
@@ -1384,6 +1689,147 @@ static void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
 }
 
 /**
+ *	mv_sff_irq_clear - Clear hardware interrupt after DMA.
+ *	@ap: Port associated with this ATA transaction.
+ *
+ *	We need this only for ATAPI bmdma transactions,
+ *	as otherwise we experience spurious interrupts
+ *	after libata-sff handles the bmdma interrupts.
+ */
+static void mv_sff_irq_clear(struct ata_port *ap)
+{
+	mv_clear_and_enable_port_irqs(ap, mv_ap_base(ap), ERR_IRQ);
+}
+
+/**
+ *	mv_check_atapi_dma - Filter ATAPI cmds which are unsuitable for DMA.
+ *	@qc: queued command to check for chipset/DMA compatibility.
+ *
+ *	The bmdma engines cannot handle speculative data sizes
+ *	(bytecount under/over flow).  So only allow DMA for
+ *	data transfer commands with known data sizes.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static int mv_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+
+	if (scmd) {
+		switch (scmd->cmnd[0]) {
+		case READ_6:
+		case READ_10:
+		case READ_12:
+		case WRITE_6:
+		case WRITE_10:
+		case WRITE_12:
+		case GPCMD_READ_CD:
+		case GPCMD_SEND_DVD_STRUCTURE:
+		case GPCMD_SEND_CUE_SHEET:
+			return 0; /* DMA is safe */
+		}
+	}
+	return -EOPNOTSUPP; /* use PIO instead */
+}
+
+/**
+ *	mv_bmdma_setup - Set up BMDMA transaction
+ *	@qc: queued command to prepare DMA for.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static void mv_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = mv_ap_base(ap);
+	struct mv_port_priv *pp = ap->private_data;
+
+	mv_fill_sg(qc);
+
+	/* clear all DMA cmd bits */
+	writel(0, port_mmio + BMDMA_CMD_OFS);
+
+	/* load PRD table addr. */
+	writel((pp->sg_tbl_dma[qc->tag] >> 16) >> 16,
+		port_mmio + BMDMA_PRD_HIGH_OFS);
+	writelfl(pp->sg_tbl_dma[qc->tag],
+		port_mmio + BMDMA_PRD_LOW_OFS);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+
+/**
+ *	mv_bmdma_start - Start a BMDMA transaction
+ *	@qc: queued command to start DMA on.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static void mv_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = mv_ap_base(ap);
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	u32 cmd = (rw ? 0 : ATA_DMA_WR) | ATA_DMA_START;
+
+	/* start host DMA transaction */
+	writelfl(cmd, port_mmio + BMDMA_CMD_OFS);
+}
+
+/**
+ *	mv_bmdma_stop - Stop BMDMA transfer
+ *	@qc: queued command to stop DMA on.
+ *
+ *	Clears the ATA_DMA_START flag in the bmdma control register
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 cmd;
+
+	/* clear start/stop bit */
+	cmd = readl(port_mmio + BMDMA_CMD_OFS);
+	cmd &= ~ATA_DMA_START;
+	writelfl(cmd, port_mmio + BMDMA_CMD_OFS);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+
+/**
+ *	mv_bmdma_status - Read BMDMA status
+ *	@ap: port for which to retrieve DMA status.
+ *
+ *	Read and return equivalent of the sff BMDMA status register.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static u8 mv_bmdma_status(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 reg, status;
+
+	/*
+	 * Other bits are valid only if ATA_DMA_ACTIVE==0,
+	 * and the ATA_DMA_INTR bit doesn't exist.
+	 */
+	reg = readl(port_mmio + BMDMA_STATUS_OFS);
+	if (reg & ATA_DMA_ACTIVE)
+		status = ATA_DMA_ACTIVE;
+	else
+		status = (reg & ATA_DMA_ERR) | ATA_DMA_INTR;
+	return status;
+}
+
+/**
  *      mv_qc_prep - Host specific command preparation.
  *      @qc: queued command to prepare
  *
@@ -1545,6 +1991,132 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	mv_sff_check_status - fetch device status, if valid
+ *	@ap: ATA port to fetch status from
+ *
+ *	When using command issue via mv_qc_issue_fis(),
+ *	the initial ATA_BUSY state does not show up in the
+ *	ATA status (shadow) register.  This can confuse libata!
+ *
+ *	So we have a hook here to fake ATA_BUSY for that situation,
+ *	until the first time a BUSY, DRQ, or ERR bit is seen.
+ *
+ *	The rest of the time, it simply returns the ATA status register.
+ */
+static u8 mv_sff_check_status(struct ata_port *ap)
+{
+	u8 stat = ioread8(ap->ioaddr.status_addr);
+	struct mv_port_priv *pp = ap->private_data;
+
+	if (pp->pp_flags & MV_PP_FLAG_FAKE_ATA_BUSY) {
+		if (stat & (ATA_BUSY | ATA_DRQ | ATA_ERR))
+			pp->pp_flags &= ~MV_PP_FLAG_FAKE_ATA_BUSY;
+		else
+			stat = ATA_BUSY;
+	}
+	return stat;
+}
+
+/**
+ *	mv_send_fis - Send a FIS, using the "Vendor-Unique FIS" register
+ *	@fis: fis to be sent
+ *	@nwords: number of 32-bit words in the fis
+ */
+static unsigned int mv_send_fis(struct ata_port *ap, u32 *fis, int nwords)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 ifctl, old_ifctl, ifstat;
+	int i, timeout = 200, final_word = nwords - 1;
+
+	/* Initiate FIS transmission mode */
+	old_ifctl = readl(port_mmio + SATA_IFCTL_OFS);
+	ifctl = 0x100 | (old_ifctl & 0xf);
+	writelfl(ifctl, port_mmio + SATA_IFCTL_OFS);
+
+	/* Send all words of the FIS except for the final word */
+	for (i = 0; i < final_word; ++i)
+		writel(fis[i], port_mmio + VENDOR_UNIQUE_FIS_OFS);
+
+	/* Flag end-of-transmission, and then send the final word */
+	writelfl(ifctl | 0x200, port_mmio + SATA_IFCTL_OFS);
+	writelfl(fis[final_word], port_mmio + VENDOR_UNIQUE_FIS_OFS);
+
+	/*
+	 * Wait for FIS transmission to complete.
+	 * This typically takes just a single iteration.
+	 */
+	do {
+		ifstat = readl(port_mmio + SATA_IFSTAT_OFS);
+	} while (!(ifstat & 0x1000) && --timeout);
+
+	/* Restore original port configuration */
+	writelfl(old_ifctl, port_mmio + SATA_IFCTL_OFS);
+
+	/* See if it worked */
+	if ((ifstat & 0x3000) != 0x1000) {
+		ata_port_printk(ap, KERN_WARNING,
+				"%s transmission error, ifstat=%08x\n",
+				__func__, ifstat);
+		return AC_ERR_OTHER;
+	}
+	return 0;
+}
+
+/**
+ *	mv_qc_issue_fis - Issue a command directly as a FIS
+ *	@qc: queued command to start
+ *
+ *	Note that the ATA shadow registers are not updated
+ *	after command issue, so the device will appear "READY"
+ *	if polled, even while it is BUSY processing the command.
+ *
+ *	So we use a status hook to fake ATA_BUSY until the drive changes state.
+ *
+ *	Note: we don't get updated shadow regs on *completion*
+ *	of non-data commands. So avoid sending them via this function,
+ *	as they will appear to have completed immediately.
+ *
+ *	GEN_IIE has special registers that we could get the result tf from,
+ *	but earlier chipsets do not.  For now, we ignore those registers.
+ */
+static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct mv_port_priv *pp = ap->private_data;
+	struct ata_link *link = qc->dev->link;
+	u32 fis[5];
+	int err = 0;
+
+	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
+	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
+	if (err)
+		return err;
+
+	switch (qc->tf.protocol) {
+	case ATAPI_PROT_PIO:
+		pp->pp_flags |= MV_PP_FLAG_FAKE_ATA_BUSY;
+		/* fall through */
+	case ATAPI_PROT_NODATA:
+		ap->hsm_task_state = HSM_ST_FIRST;
+		break;
+	case ATA_PROT_PIO:
+		pp->pp_flags |= MV_PP_FLAG_FAKE_ATA_BUSY;
+		if (qc->tf.flags & ATA_TFLAG_WRITE)
+			ap->hsm_task_state = HSM_ST_FIRST;
+		else
+			ap->hsm_task_state = HSM_ST;
+		break;
+	default:
+		ap->hsm_task_state = HSM_ST_LAST;
+		break;
+	}
+
+	if (qc->tf.flags & ATA_TFLAG_POLLING)
+		ata_pio_queue_task(ap, qc, 0);
+	return 0;
+}
+
+/**
  *      mv_qc_issue - Initiate a command to the host
  *      @qc: queued command to start
  *
@@ -1558,14 +2130,28 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
  */
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 {
+	static int limit_warnings = 10;
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
 	u32 in_index;
+	unsigned int port_irqs;
 
-	if ((qc->tf.protocol != ATA_PROT_DMA) &&
-	    (qc->tf.protocol != ATA_PROT_NCQ)) {
-		static int limit_warnings = 10;
+	pp->pp_flags &= ~MV_PP_FLAG_FAKE_ATA_BUSY; /* paranoia */
+
+	switch (qc->tf.protocol) {
+	case ATA_PROT_DMA:
+	case ATA_PROT_NCQ:
+		mv_start_edma(ap, port_mmio, pp, qc->tf.protocol);
+		pp->req_idx = (pp->req_idx + 1) & MV_MAX_Q_DEPTH_MASK;
+		in_index = pp->req_idx << EDMA_REQ_Q_PTR_SHIFT;
+
+		/* Write the request in pointer to kick the EDMA to life */
+		writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
+					port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+		return 0;
+
+	case ATA_PROT_PIO:
 		/*
 		 * Errata SATA#16, SATA#24: warn if multiple DRQs expected.
 		 *
@@ -1583,27 +2169,46 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 					": attempting PIO w/multiple DRQ: "
 					"this may fail due to h/w errata\n");
 		}
-		/*
-		 * We're about to send a non-EDMA capable command to the
-		 * port.  Turn off EDMA so there won't be problems accessing
-		 * shadow block, etc registers.
-		 */
-		mv_stop_edma(ap);
-		mv_enable_port_irqs(ap, ERR_IRQ);
-		mv_pmp_select(ap, qc->dev->link->pmp);
-		return ata_sff_qc_issue(qc);
+		/* drop through */
+	case ATA_PROT_NODATA:
+	case ATAPI_PROT_PIO:
+	case ATAPI_PROT_NODATA:
+		if (ap->flags & ATA_FLAG_PIO_POLLING)
+			qc->tf.flags |= ATA_TFLAG_POLLING;
+		break;
 	}
 
-	mv_start_dma(ap, port_mmio, pp, qc->tf.protocol);
-
-	pp->req_idx = (pp->req_idx + 1) & MV_MAX_Q_DEPTH_MASK;
-	in_index = pp->req_idx << EDMA_REQ_Q_PTR_SHIFT;
+	if (qc->tf.flags & ATA_TFLAG_POLLING)
+		port_irqs = ERR_IRQ;	/* mask device interrupt when polling */
+	else
+		port_irqs = ERR_IRQ | DONE_IRQ;	/* unmask all interrupts */
 
-	/* and write the request in pointer to kick the EDMA to life */
-	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
-		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+	/*
+	 * We're about to send a non-EDMA capable command to the
+	 * port.  Turn off EDMA so there won't be problems accessing
+	 * shadow block, etc registers.
+	 */
+	mv_stop_edma(ap);
+	mv_clear_and_enable_port_irqs(ap, mv_ap_base(ap), port_irqs);
+	mv_pmp_select(ap, qc->dev->link->pmp);
 
-	return 0;
+	if (qc->tf.command == ATA_CMD_READ_LOG_EXT) {
+		struct mv_host_priv *hpriv = ap->host->private_data;
+		/*
+		 * Workaround for 88SX60x1 FEr SATA#25 (part 2).
+		 *
+		 * After any NCQ error, the READ_LOG_EXT command
+		 * from libata-eh *must* use mv_qc_issue_fis().
+		 * Otherwise it might fail, due to chip errata.
+		 *
+		 * Rather than special-case it, we'll just *always*
+		 * use this method here for READ_LOG_EXT, making for
+		 * easier testing.
+		 */
+		if (IS_GEN_II(hpriv))
+			return mv_qc_issue_fis(qc);
+	}
+	return ata_sff_qc_issue(qc);
 }
 
 static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
@@ -1614,8 +2219,12 @@ static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
 	if (pp->pp_flags & MV_PP_FLAG_NCQ_EN)
 		return NULL;
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
-		qc = NULL;
+	if (qc) {
+		if (qc->tf.flags & ATA_TFLAG_POLLING)
+			qc = NULL;
+		else if (!(qc->flags & ATA_QCFLAG_ACTIVE))
+			qc = NULL;
+	}
 	return qc;
 }
 
@@ -2084,6 +2693,10 @@ static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 	void __iomem *mmio = hpriv->base, *hc_mmio;
 	unsigned int handled = 0, port;
 
+	/* If asserted, clear the "all ports" IRQ coalescing bit */
+	if (main_irq_cause & ALL_PORTS_COAL_DONE)
+		writel(~ALL_PORTS_COAL_IRQ, mmio + MV_IRQ_COAL_CAUSE);
+
 	for (port = 0; port < hpriv->n_ports; port++) {
 		struct ata_port *ap = host->ports[port];
 		unsigned int p, shift, hardport, port_cause;
@@ -2116,6 +2729,8 @@ static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 			 * to ack (only) those ports via hc_irq_cause.
 			 */
 			ack_irqs = 0;
+			if (hc_cause & PORTS_0_3_COAL_DONE)
+				ack_irqs = HC_COAL_IRQ;
 			for (p = 0; p < MV_PORTS_PER_HC; ++p) {
 				if ((port + p) >= hpriv->n_ports)
 					break;
@@ -2204,7 +2819,7 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 
 	/* for MSI:  block new interrupts while in here */
 	if (using_msi)
-		writel(0, hpriv->main_irq_mask_addr);
+		mv_write_main_irq_mask(0, hpriv);
 
 	main_irq_cause = readl(hpriv->main_irq_cause_addr);
 	pending_irqs   = main_irq_cause & hpriv->main_irq_mask;
@@ -2221,7 +2836,7 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 
 	/* for MSI: unmask; interrupt cause bits will retrigger now */
 	if (using_msi)
-		writel(hpriv->main_irq_mask, hpriv->main_irq_mask_addr);
+		mv_write_main_irq_mask(hpriv->main_irq_mask, hpriv);
 
 	spin_unlock(&host->lock);
 
@@ -2774,6 +3389,8 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 
 	mv_reset_channel(hpriv, mmio, ap->port_no);
 	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+	pp->pp_flags &=
+	  ~(MV_PP_FLAG_FBS_EN | MV_PP_FLAG_NCQ_EN | MV_PP_FLAG_FAKE_ATA_BUSY);
 
 	/* Workaround for errata FEr SATA#10 (part 2) */
 	do {
@@ -2793,6 +3410,8 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 				extra = HZ; /* only extend it once, max */
 		}
 	} while (sstatus != 0x0 && sstatus != 0x113 && sstatus != 0x123);
+	mv_save_cached_regs(ap);
+	mv_edma_cfg(ap, 0, 0);
 
 	return rc;
 }
@@ -3126,6 +3745,8 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	 * The per-port interrupts get done later as ports are set up.
 	 */
 	mv_set_main_irq_mask(host, 0, PCI_ERR);
+	mv_set_irq_coalescing(host, irq_coalescing_io_count,
+				    irq_coalescing_usecs);
 done:
 	return rc;
 }
@@ -3287,12 +3908,6 @@ static struct pci_driver mv_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-/*
- * module options
- */
-static int msi;	      /* Use PCI msi; either zero (off, default) or non-zero */
-
-
 /* move to PCI layer or libata core? */
 static int pci_go_64(struct pci_dev *pdev)
 {
@@ -3474,10 +4089,5 @@ MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
 
-#ifdef CONFIG_PCI
-module_param(msi, int, 0444);
-MODULE_PARM_DESC(msi, "Enable use of PCI MSI (0=off, 1=on)");
-#endif
-
 module_init(mv_init);
 module_exit(mv_exit);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f65b537..6cda12b 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -57,9 +57,9 @@ enum {
 	NV_MMIO_BAR			= 5,
 
 	NV_PORTS			= 2,
-	NV_PIO_MASK			= 0x1f,
-	NV_MWDMA_MASK			= 0x07,
-	NV_UDMA_MASK			= 0x7f,
+	NV_PIO_MASK			= ATA_PIO4,
+	NV_MWDMA_MASK			= ATA_MWDMA2,
+	NV_UDMA_MASK			= ATA_UDMA6,
 	NV_PORT0_SCR_REG_OFFSET		= 0x00,
 	NV_PORT1_SCR_REG_OFFSET		= 0x40,
 
@@ -408,6 +408,7 @@ static struct scsi_host_template nv_swncq_sht = {
 
 static struct ata_port_operations nv_common_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.lost_interrupt		= ATA_OP_NULL,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 };
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index ba9a257..b1fd7d6 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -176,7 +176,9 @@ static const struct ata_port_operations pdc_common_ops = {
 	.check_atapi_dma	= pdc_check_atapi_dma,
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue,
+
 	.sff_irq_clear		= pdc_irq_clear,
+	.lost_interrupt		= ATA_OP_NULL,
 
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.error_handler		= pdc_error_handler,
@@ -213,8 +215,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_SATA_PATA,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
@@ -222,8 +224,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	[board_2037x_pata] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
@@ -232,8 +234,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_4_PORTS,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
@@ -242,8 +244,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
 				  PDC_FLAG_4_PORTS,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
@@ -252,8 +254,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_GEN_II | PDC_FLAG_SATA_PATA,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
@@ -262,8 +264,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
 				  PDC_FLAG_GEN_II,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
@@ -272,8 +274,8 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index a000c86..c3936d3 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -147,6 +147,7 @@ static struct ata_port_operations qs_ata_ops = {
 	.softreset		= ATA_OP_NULL,
 	.error_handler		= qs_error_handler,
 	.post_internal_cmd	= ATA_OP_NULL,
+	.lost_interrupt		= ATA_OP_NULL,
 
 	.scr_read		= qs_scr_read,
 	.scr_write		= qs_scr_write,
@@ -160,7 +161,7 @@ static const struct ata_port_info qs_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
-		.pio_mask	= 0x10, /* pio4 */
+		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &qs_ata_ops,
 	},
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index d009160..e67ce8e 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -200,8 +200,8 @@ static const struct ata_port_info sil_port_info[] = {
 	/* sil_3112 */
 	{
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_MOD15WRITE,
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
@@ -209,24 +209,24 @@ static const struct ata_port_info sil_port_info[] = {
 	{
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_MOD15WRITE |
 				  SIL_FLAG_NO_SATA_IRQ,
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3512 */
 	{
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT,
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
 	/* sil_3114 */
 	{
 		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT,
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil_ops,
 	},
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 2590c22..0d8990d 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -429,25 +429,25 @@ static const struct ata_port_info sil24_port_info[] = {
 	{
 		.flags		= SIL24_COMMON_FLAGS | SIL24_NPORTS2FLAG(4) |
 				  SIL24_FLAG_PCIX_IRQ_WOC,
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3132 */
 	{
 		.flags		= SIL24_COMMON_FLAGS | SIL24_NPORTS2FLAG(2),
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3131/sil_3531 */
 	{
 		.flags		= SIL24_COMMON_FLAGS | SIL24_NPORTS2FLAG(1),
-		.pio_mask	= 0x1f,			/* pio0-4 */
-		.mwdma_mask	= 0x07,			/* mwdma0-2 */
-		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &sil24_ops,
 	},
 };
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 9c43b4e..8f98332 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -97,8 +97,8 @@ static struct ata_port_operations sis_ops = {
 
 static const struct ata_port_info sis_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
-	.pio_mask	= 0x1f,
-	.mwdma_mask	= 0x7,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_ops,
 };
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 609d147..7257f2d 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -361,8 +361,8 @@ static const struct ata_port_info k2_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
@@ -371,8 +371,8 @@ static const struct ata_port_info k2_port_info[] = {
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA |
 				  K2_FLAG_SATA_8_PORTS,
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
@@ -380,8 +380,8 @@ static const struct ata_port_info k2_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | K2_FLAG_BAR_POS_3,
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
@@ -389,8 +389,8 @@ static const struct ata_port_info k2_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO,
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index ec04b8d..dce3dcc 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -265,8 +265,8 @@ static const struct ata_port_info pdc_port_info[] = {
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_SRST | ATA_FLAG_MMIO |
 				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
-		.pio_mask	= 0x1f, /* pio0-4 */
-		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_20621_ops,
 	},
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 019575b..e5bff47 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -89,7 +89,7 @@ static struct ata_port_operations uli_ops = {
 static const struct ata_port_info uli_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 			  ATA_FLAG_IGN_SIMPLEX,
-	.pio_mask       = 0x1f,		/* pio0-4 */
+	.pio_mask       = ATA_PIO4,
 	.udma_mask      = ATA_UDMA6,
 	.port_ops       = &uli_ops,
 };
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 5c62da9..98e8c50 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -146,24 +146,24 @@ static struct ata_port_operations vt8251_ops = {
 
 static const struct ata_port_info vt6420_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
-	.pio_mask	= 0x1f,
-	.mwdma_mask	= 0x07,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6420_sata_ops,
 };
 
 static struct ata_port_info vt6421_sport_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
-	.pio_mask	= 0x1f,
-	.mwdma_mask	= 0x07,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6421_sata_ops,
 };
 
 static struct ata_port_info vt6421_pport_info = {
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
-	.pio_mask	= 0x1f,
-	.mwdma_mask	= 0,
+	.pio_mask	= ATA_PIO4,
+	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt6421_pata_ops,
 };
@@ -171,8 +171,8 @@ static struct ata_port_info vt6421_pport_info = {
 static struct ata_port_info vt8251_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
 			  ATA_FLAG_NO_LEGACY,
-	.pio_mask	= 0x1f,
-	.mwdma_mask	= 0x07,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &vt8251_ops,
 };
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index c57cdff..ed70bd2 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -308,6 +308,9 @@ static struct scsi_host_template vsc_sata_sht = {
 
 static struct ata_port_operations vsc_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	/* The IRQ handling is not quite standard SFF behaviour so we
+	   cannot use the default lost interrupt handler */
+	.lost_interrupt		= ATA_OP_NULL,
 	.sff_tf_load		= vsc_sata_tf_load,
 	.sff_tf_read		= vsc_sata_tf_read,
 	.freeze			= vsc_freeze,
@@ -345,8 +348,8 @@ static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
 	static const struct ata_port_info pi = {
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO,
-		.pio_mask	= 0x1f,
-		.mwdma_mask	= 0x07,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &vsc_sata_ops,
 	};
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 9a061ac..3901b00 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -108,6 +108,8 @@ enum {
 	ATA_PIO5		= ATA_PIO4 | (1 << 5),
 	ATA_PIO6		= ATA_PIO5 | (1 << 6),
 
+	ATA_PIO4_ONLY		= (1 << 4),
+
 	ATA_SWDMA0		= (1 << 0),
 	ATA_SWDMA1		= ATA_SWDMA0 | (1 << 1),
 	ATA_SWDMA2		= ATA_SWDMA1 | (1 << 2),
@@ -117,6 +119,8 @@ enum {
 	ATA_MWDMA0		= (1 << 0),
 	ATA_MWDMA1		= ATA_MWDMA0 | (1 << 1),
 	ATA_MWDMA2		= ATA_MWDMA1 | (1 << 2),
+	ATA_MWDMA3		= ATA_MWDMA2 | (1 << 3),
+	ATA_MWDMA4		= ATA_MWDMA3 | (1 << 4),
 
 	ATA_MWDMA12_ONLY	= (1 << 1) | (1 << 2),
 	ATA_MWDMA2_ONLY		= (1 << 2),
@@ -131,6 +135,8 @@ enum {
 	ATA_UDMA7		= ATA_UDMA6 | (1 << 7),
 	/* ATA_UDMA7 is just for completeness... doesn't exist (yet?).  */
 
+	ATA_UDMA24_ONLY		= (1 << 2) | (1 << 4),
+
 	ATA_UDMA_MASK_40C	= ATA_UDMA2,	/* udma0-2 */
 
 	/* DMA-related */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index dc18b87..76262d8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -795,6 +795,7 @@ struct ata_port_operations {
 	ata_reset_fn_t		pmp_hardreset;
 	ata_postreset_fn_t	pmp_postreset;
 	void (*error_handler)(struct ata_port *ap);
+	void (*lost_interrupt)(struct ata_port *ap);
 	void (*post_internal_cmd)(struct ata_queued_cmd *qc);
 
 	/*
@@ -836,6 +837,8 @@ struct ata_port_operations {
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
+
+	void (*drain_fifo)(struct ata_queued_cmd *qc);
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -1008,6 +1011,9 @@ extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_ignore(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 
+extern void ata_pio_queue_task(struct ata_port *ap, void *data,
+			       unsigned long delay);
+
 /* Timing helpers */
 extern unsigned int ata_pio_need_iordy(const struct ata_device *);
 extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
@@ -1572,6 +1578,7 @@ extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
 extern unsigned int ata_sff_host_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_sff_interrupt(int irq, void *dev_instance);
+extern void ata_sff_lost_interrupt(struct ata_port *ap);
 extern void ata_sff_freeze(struct ata_port *ap);
 extern void ata_sff_thaw(struct ata_port *ap);
 extern int ata_sff_prereset(struct ata_link *link, unsigned long deadline);
@@ -1584,6 +1591,7 @@ extern int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 			       unsigned long deadline);
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
+extern void ata_sff_drain_fifo(struct ata_queued_cmd *qc);
 extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_sff_port_start(struct ata_port *ap);
