Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbXGJShA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbXGJShA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXGJSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:36:47 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33696 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXGJSgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:36:36 -0400
Date: Tue, 10 Jul 2007 14:36:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20070710183633.GA8862@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Very little of note.  Tejun's ACPI updates are useful.  And a big Tejun
"port multiplier" (== SATA version of ethernet or USB hub) patchbomb is
waiting to be reviewed.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |  159 +++++--
 drivers/ata/ata_generic.c       |    4 +-
 drivers/ata/ata_piix.c          |   35 +-
 drivers/ata/libata-acpi.c       |  914 +++++++++++++++++----------------------
 drivers/ata/libata-core.c       |  105 ++++-
 drivers/ata/libata-eh.c         |   11 +-
 drivers/ata/libata-scsi.c       |    2 +-
 drivers/ata/libata.h            |   18 +-
 drivers/ata/pata_ali.c          |   22 +-
 drivers/ata/pata_amd.c          |   38 +-
 drivers/ata/pata_artop.c        |    6 +-
 drivers/ata/pata_atiixp.c       |    3 +-
 drivers/ata/pata_cmd640.c       |    2 +-
 drivers/ata/pata_cmd64x.c       |   12 +-
 drivers/ata/pata_cs5520.c       |    4 +-
 drivers/ata/pata_cs5530.c       |    8 +-
 drivers/ata/pata_cs5535.c       |    4 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_hpt366.c       |    4 +-
 drivers/ata/pata_hpt37x.c       |   20 +-
 drivers/ata/pata_hpt3x2n.c      |    4 +-
 drivers/ata/pata_hpt3x3.c       |    2 +-
 drivers/ata/pata_icside.c       |    2 +-
 drivers/ata/pata_it8213.c       |    4 +-
 drivers/ata/pata_it821x.c       |    6 +-
 drivers/ata/pata_ixp4xx_cf.c    |   76 ++--
 drivers/ata/pata_jmicron.c      |    4 +-
 drivers/ata/pata_marvell.c      |    8 +-
 drivers/ata/pata_netcell.c      |    4 +-
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |    4 +-
 drivers/ata/pata_pdc202xx_old.c |    6 +-
 drivers/ata/pata_platform.c     |    6 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_rz1000.c       |    2 +-
 drivers/ata/pata_sc1200.c       |    6 +-
 drivers/ata/pata_serverworks.c  |   12 +-
 drivers/ata/pata_sil680.c       |   21 +-
 drivers/ata/pata_sis.c          |   14 +-
 drivers/ata/pata_sl82c105.c     |    4 +-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |    8 +-
 drivers/ata/pdc_adma.c          |   20 +-
 drivers/ata/sata_inic162x.c     |    6 +-
 drivers/ata/sata_mv.c           |   31 +-
 drivers/ata/sata_promise.c      |   78 ++--
 drivers/ata/sata_qstor.c        |    2 +-
 drivers/ata/sata_sil.c          |   13 +-
 drivers/ata/sata_sil24.c        |    8 +-
 drivers/ata/sata_sis.c          |    2 +-
 drivers/ata/sata_svw.c          |   15 +-
 drivers/ata/sata_sx4.c          |  168 +++++---
 drivers/ata/sata_uli.c          |    2 +-
 drivers/ata/sata_via.c          |   10 +-
 drivers/ata/sata_vsc.c          |    2 +-
 include/linux/ata.h             |    1 +
 include/linux/libata.h          |   30 ++-
 include/linux/pata_platform.h   |    5 +
 61 files changed, 1052 insertions(+), 919 deletions(-)

Alan Cox (1):
      libata: Support chips with 64K PRD quirk

Alessandro Zummo (1):
      [libata] pata_ixp4xx: convert to new EH

Christian Lamparter (1):
      Add a PCI ID for santa rosa's PATA controller.

Jeff Garzik (17):
      [libata] pata_atiixp: add SB700 PCI ID
      [libata] sata_sil: register table cleanup
      [libata] PATA drivers: remove ATA_FLAG_SRST
      [libata] drivers: remove 'void __iomem *' casts from pre-iomap days
      [libata] pdc_adma: Reorder initializers with a couple structs
      [libata] sata_sx4: named constant cleanup
      [libata] pata_sil680: minor cleanups from benh
      [libata] ahci: Factor out SATA port init into a separate function
      [libata] ahci: minor internal cleanups
      [libata] sata_sx4, sata_via: minor documentation updates
      [ATA] Add named constant for ATAPI command DEVICE RESET
      [libata] ahci: minor internal cleanups
      [libata] pata_ixp4xx: kill unused var
      [libata] Clean up driver udma_mask initializers
      [libata] AHCI: Add support for Marvell AHCI-like chips (initially 6145)
      [libata] Use ATA_UDMAx standard masks when filling driver's udma_mask info
      [libata] sata_mv: print out additional chip info during probe

Jens Axboe (1):
      use_clustering (sht) bit set to 0 in AHCI ?

Mikael Pettersson (2):
      sata_promise: cleanups
      sata_sil24: sil24_interrupt() micro-optimisation

Sonic Zhang (1):
      Add irq_flags to struct pata_platform_info

Tejun Heo (8):
      libata-acpi: implement ata_acpi_associate()
      libata-acpi: clean up ata_acpi_exec_tfs()
      libata-acpi: miscellaneous cleanups
      libata: reimplement ACPI invocation
      libata-acpi: remove redundant checks
      libata-acpi: implement _GTM/_STM support
      libata: replace ap->cbl tests with ATA_FLAG_SATA tests
      ata_piix: fix pio/mwdma programming

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ca5229d..11e4eb9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 
 enum {
@@ -54,7 +54,7 @@ enum {
 	AHCI_MAX_PORTS		= 32,
 	AHCI_MAX_SG		= 168, /* hardware max is 64K */
 	AHCI_DMA_BOUNDARY	= 0xffffffff,
-	AHCI_USE_CLUSTERING	= 0,
+	AHCI_USE_CLUSTERING	= 1,
 	AHCI_MAX_CMDS		= 32,
 	AHCI_CMD_SZ		= 32,
 	AHCI_CMD_SLOT_SZ	= AHCI_MAX_CMDS * AHCI_CMD_SZ,
@@ -81,6 +81,7 @@ enum {
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
 	board_ahci_sb600	= 4,
+	board_ahci_mv		= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -171,6 +172,8 @@ enum {
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
+	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
+	AHCI_FLAG_NO_MSI		= (1 << 30), /* no PCI MSI */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -228,9 +231,12 @@ static void ahci_thaw(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
+static int ahci_port_resume(struct ata_port *ap);
+static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_port_resume(struct ata_port *ap);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -327,14 +333,14 @@ static const struct ata_port_info ahci_port_info[] = {
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
@@ -342,14 +348,14 @@ static const struct ata_port_info ahci_port_info[] = {
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
@@ -358,7 +364,19 @@ static const struct ata_port_info ahci_port_info[] = {
 				  AHCI_FLAG_IGN_SERR_INTERNAL |
 				  AHCI_FLAG_32BIT_ONLY,
 		.pio_mask	= 0x1f, /* pio0-4 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	/* board_ahci_mv */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY | AHCI_FLAG_HONOR_PI |
+				  AHCI_FLAG_NO_NCQ | AHCI_FLAG_NO_MSI |
+				  AHCI_FLAG_MV_PATA,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 };
@@ -456,6 +474,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
 
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -481,11 +502,17 @@ static inline int ahci_nr_ports(u32 cap)
 	return (cap & 0x1f) + 1;
 }
 
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
 {
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+
+	return mmio + 0x100 + (port_no * 0x80);
+}
 
-	return mmio + 0x100 + (ap->port_no * 0x80);
+static inline void __iomem *ahci_port_base(struct ata_port *ap)
+{
+	return __ahci_port_base(ap->host, ap->port_no);
 }
 
 /**
@@ -535,6 +562,20 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		hpriv->saved_port_map = port_map;
 	}
 
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (pi->flags & AHCI_FLAG_MV_PATA) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "MV_AHCI HACK: port_map %x -> %x\n",
+			   hpriv->port_map,
+			   hpriv->port_map & 0xf);
+
+		port_map &= 0xf;
+	}
+
 	/* cross check port_map and cap.n_ports */
 	if (pi->flags & AHCI_FLAG_HONOR_PI) {
 		u32 tmp_port_map = port_map;
@@ -740,7 +781,7 @@ static void ahci_power_down(struct ata_port *ap)
 }
 #endif
 
-static void ahci_init_port(struct ata_port *ap)
+static void ahci_start_port(struct ata_port *ap)
 {
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
@@ -814,39 +855,62 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
+static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio)
+{
+	const char *emsg = NULL;
+	int rc;
+	u32 tmp;
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "%s (%d)\n", emsg, rc);
+
+	/* clear SError */
+	tmp = readl(port_mmio + PORT_SCR_ERR);
+	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
+	writel(tmp, port_mmio + PORT_SCR_ERR);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	if (tmp)
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+}
+
 static void ahci_init_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	int i, rc;
+	int i;
+	void __iomem *port_mmio;
 	u32 tmp;
 
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		void __iomem *port_mmio = ahci_port_base(ap);
-		const char *emsg = NULL;
-
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		/* make sure port is not active */
-		rc = ahci_deinit_port(ap, &emsg);
-		if (rc)
-			dev_printk(KERN_WARNING, &pdev->dev,
-				   "%s (%d)\n", emsg, rc);
+	if (host->ports[0]->flags & AHCI_FLAG_MV_PATA) {
+		port_mmio = __ahci_port_base(host, 4);
 
-		/* clear SError */
-		tmp = readl(port_mmio + PORT_SCR_ERR);
-		VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
-		writel(tmp, port_mmio + PORT_SCR_ERR);
+		writel(0, port_mmio + PORT_IRQ_MASK);
 
 		/* clear port IRQ */
 		tmp = readl(port_mmio + PORT_IRQ_STAT);
 		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
 		if (tmp)
 			writel(tmp, port_mmio + PORT_IRQ_STAT);
+	}
 
-		writel(1 << i, mmio + HOST_IRQ_STAT);
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		port_mmio = ahci_port_base(ap);
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ahci_port_init(pdev, ap, i, mmio, port_mmio);
 	}
 
 	tmp = readl(mmio + HOST_CTL);
@@ -1232,7 +1296,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_host_intr(struct ata_port *ap)
+static void ahci_port_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
 	struct ata_eh_info *ehi = &ap->eh_info;
@@ -1358,7 +1422,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_host_intr(ap);
+			ahci_port_intr(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1466,7 +1530,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ahci_power_down(ap);
 	else {
 		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
-		ahci_init_port(ap);
+		ahci_start_port(ap);
 	}
 
 	return rc;
@@ -1475,7 +1539,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 static int ahci_port_resume(struct ata_port *ap)
 {
 	ahci_power_up(ap);
-	ahci_init_port(ap);
+	ahci_start_port(ap);
 
 	return 0;
 }
@@ -1573,13 +1637,8 @@ static int ahci_port_start(struct ata_port *ap)
 
 	ap->private_data = pp;
 
-	/* power up port */
-	ahci_power_up(ap);
-
-	/* initialize port */
-	ahci_init_port(ap);
-
-	return 0;
+	/* engage engines, captain */
+	return ahci_port_resume(ap);
 }
 
 static void ahci_port_stop(struct ata_port *ap)
@@ -1724,7 +1783,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	if (pci_enable_msi(pdev))
+	if ((pi.flags & AHCI_FLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
@@ -1745,14 +1804,18 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->private_data = hpriv;
 
 	for (i = 0; i < host->n_ports; i++) {
-		if (hpriv->port_map & (1 << i)) {
-			struct ata_port *ap = host->ports[i];
-			void __iomem *port_mmio = ahci_port_base(ap);
+		struct ata_port *ap = host->ports[i];
+		void __iomem *port_mmio = ahci_port_base(ap);
 
+		/* standard SATA port setup */
+		if (hpriv->port_map & (1 << i)) {
 			ap->ioaddr.cmd_addr = port_mmio;
 			ap->ioaddr.scr_addr = port_mmio + PORT_SCR;
-		} else
-			host->ports[i]->ops = &ata_dummy_port_ops;
+		}
+
+		/* disabled/not-implemented port */
+		else
+			ap->ops = &ata_dummy_port_ops;
 	}
 
 	/* initialize adapter */
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 4c6e95c..430fcf4 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -143,10 +143,10 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	u16 command;
 	static const struct ata_port_info info = {
 		.sht = &generic_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &generic_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9c07b88..6a3bfef 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -200,6 +200,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH7/7-R (i945, i975) UDMA 100*/
 	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	/* ICH8 Mobile PATA Controller */
+	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
 	/* NOTE: The following PCI ids must be kept in sync with the
 	 * list in drivers/pci/quirks.c.
@@ -495,7 +497,7 @@ static struct ata_port_info piix_port_info[] = {
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -505,7 +507,7 @@ static struct ata_port_info piix_port_info[] = {
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -516,7 +518,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -527,7 +529,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -538,7 +540,7 @@ static struct ata_port_info piix_port_info[] = {
 				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 
@@ -685,8 +687,14 @@ static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
 
+	/* PIO configuration clears DTE unconditionally.  It will be
+	 * programmed in set_dmamode which is guaranteed to be called
+	 * after set_piomode if any DMA mode is available.
+	 */
 	pci_read_config_word(dev, master_port, &master_data);
 	if (is_slave) {
+		/* clear TIME1|IE1|PPE1|DTE1 */
+		master_data &= 0xff0f;
 		/* Enable SITRE (seperate slave timing register) */
 		master_data |= 0x4000;
 		/* enable PPE1, IE1 and TIME1 as needed */
@@ -694,12 +702,14 @@ static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_byte(dev, slave_port, &slave_data);
 		slave_data &= (ap->port_no ? 0x0f : 0xf0);
 		/* Load the timing nibble for this slave */
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
+						<< (ap->port_no ? 4 : 0);
 	} else {
-		/* Master keeps the bits in a different format */
-		master_data &= 0xccf8;
+		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
+		master_data &= 0xccf0;
 		/* Enable PPE, IE and TIME as appropriate */
 		master_data |= control;
+		/* load ISP and RCT */
 		master_data |=
 			(timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
@@ -816,7 +826,7 @@ static void do_pata_set_dmamode (struct ata_port *ap, struct ata_device *adev, i
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= (ap->port_no ? 0x0f : 0xf0);
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
@@ -828,8 +838,11 @@ static void do_pata_set_dmamode (struct ata_port *ap, struct ata_device *adev, i
 				(timings[pio][0] << 12) |
 				(timings[pio][1] << 8);
 		}
-		udma_enable &= ~(1 << devid);
-		pci_write_config_word(dev, master_port, master_data);
+
+		if (ap->udma_mask) {
+			udma_enable &= ~(1 << devid);
+			pci_write_config_word(dev, master_port, master_data);
+		}
 	}
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 0223673..c059f78 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -24,15 +24,13 @@
 #include <acpi/acmacros.h>
 #include <acpi/actypes.h>
 
-#define SATA_ROOT_PORT(x)	(((x) >> 16) & 0xffff)
-#define SATA_PORT_NUMBER(x)	((x) & 0xffff)	/* or NO_PORT_MULT */
 #define NO_PORT_MULT		0xffff
-#define SATA_ADR_RSVD		0xffffffff
+#define SATA_ADR(root,pmp)	(((root) << 16) | (pmp))
 
 #define REGS_PER_GTF		7
-struct taskfile_array {
-	u8	tfa[REGS_PER_GTF];	/* regs. 0x1f1 - 0x1f7 */
-};
+struct ata_acpi_gtf {
+	u8	tf[REGS_PER_GTF];	/* regs. 0x1f1 - 0x1f7 */
+} __packed;
 
 /*
  *	Helper - belongs in the PCI layer somewhere eventually
@@ -42,237 +40,173 @@ static int is_pci_dev(struct device *dev)
 	return (dev->bus == &pci_bus_type);
 }
 
+static void ata_acpi_associate_sata_port(struct ata_port *ap)
+{
+	acpi_integer adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
+
+	ap->device->acpi_handle = acpi_get_child(ap->host->acpi_handle, adr);
+}
+
+static void ata_acpi_associate_ide_port(struct ata_port *ap)
+{
+	int max_devices, i;
+
+	ap->acpi_handle = acpi_get_child(ap->host->acpi_handle, ap->port_no);
+	if (!ap->acpi_handle)
+		return;
+
+	max_devices = 1;
+	if (ap->flags & ATA_FLAG_SLAVE_POSS)
+		max_devices++;
+
+	for (i = 0; i < max_devices; i++) {
+		struct ata_device *dev = &ap->device[i];
+
+		dev->acpi_handle = acpi_get_child(ap->acpi_handle, i);
+	}
+}
+
 /**
- * sata_get_dev_handle - finds acpi_handle and PCI device.function
- * @dev: device to locate
- * @handle: returned acpi_handle for @dev
- * @pcidevfn: return PCI device.func for @dev
+ * ata_acpi_associate - associate ATA host with ACPI objects
+ * @host: target ATA host
+ *
+ * Look up ACPI objects associated with @host and initialize
+ * acpi_handle fields of @host, its ports and devices accordingly.
  *
- * This function is somewhat SATA-specific.  Or at least the
- * PATA & SATA versions of this function are different,
- * so it's not entirely generic code.
+ * LOCKING:
+ * EH context.
  *
- * Returns 0 on success, <0 on error.
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
-static int sata_get_dev_handle(struct device *dev, acpi_handle *handle,
-					acpi_integer *pcidevfn)
+void ata_acpi_associate(struct ata_host *host)
 {
-	struct pci_dev	*pci_dev;
-	acpi_integer	addr;
-
-	if (!is_pci_dev(dev))
-		return -ENODEV;
-
-	pci_dev = to_pci_dev(dev);	/* NOTE: PCI-specific */
-	/* Please refer to the ACPI spec for the syntax of _ADR. */
-	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
-	*pcidevfn = addr;
-	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), addr);
-	if (!*handle)
-		return -ENODEV;
-	return 0;
+	int i;
+
+	if (!is_pci_dev(host->dev) || libata_noacpi)
+		return;
+
+	host->acpi_handle = DEVICE_ACPI_HANDLE(host->dev);
+	if (!host->acpi_handle)
+		return;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (host->ports[0]->flags & ATA_FLAG_ACPI_SATA)
+			ata_acpi_associate_sata_port(ap);
+		else
+			ata_acpi_associate_ide_port(ap);
+	}
 }
 
 /**
- * pata_get_dev_handle - finds acpi_handle and PCI device.function
- * @dev: device to locate
- * @handle: returned acpi_handle for @dev
- * @pcidevfn: return PCI device.func for @dev
+ * ata_acpi_gtm - execute _GTM
+ * @ap: target ATA port
+ * @gtm: out parameter for _GTM result
+ *
+ * Evaluate _GTM and store the result in @gtm.
  *
- * The PATA and SATA versions of this function are different.
+ * LOCKING:
+ * EH context.
  *
- * Returns 0 on success, <0 on error.
+ * RETURNS:
+ * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
  */
-static int pata_get_dev_handle(struct device *dev, acpi_handle *handle,
-				acpi_integer *pcidevfn)
+static int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *gtm)
 {
-	unsigned int bus, devnum, func;
-	acpi_integer addr;
-	acpi_handle dev_handle, parent_handle;
-	struct acpi_buffer buffer = {.length = ACPI_ALLOCATE_BUFFER,
-					.pointer = NULL};
+	struct acpi_buffer output = { .length = ACPI_ALLOCATE_BUFFER };
+	union acpi_object *out_obj;
 	acpi_status status;
-	struct acpi_device_info	*dinfo = NULL;
-	int ret = -ENODEV;
-	struct pci_dev *pdev;
-
-	if (!is_pci_dev(dev))
-		return -ENODEV;
-
-	pdev = to_pci_dev(dev);
-
-	bus = pdev->bus->number;
-	devnum = PCI_SLOT(pdev->devfn);
-	func = PCI_FUNC(pdev->devfn);
-
-	dev_handle = DEVICE_ACPI_HANDLE(dev);
-	parent_handle = DEVICE_ACPI_HANDLE(dev->parent);
-
-	status = acpi_get_object_info(parent_handle, &buffer);
-	if (ACPI_FAILURE(status))
-		goto err;
-
-	dinfo = buffer.pointer;
-	if (dinfo && (dinfo->valid & ACPI_VALID_ADR) &&
-	    dinfo->address == bus) {
-		/* ACPI spec for _ADR for PCI bus: */
-		addr = (acpi_integer)(devnum << 16 | func);
-		*pcidevfn = addr;
-		*handle = dev_handle;
-	} else {
-		goto err;
+	int rc = 0;
+
+	status = acpi_evaluate_object(ap->acpi_handle, "_GTM", NULL, &output);
+
+	rc = -ENOENT;
+	if (status == AE_NOT_FOUND)
+		goto out_free;
+
+	rc = -EINVAL;
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR,
+				"ACPI get timing mode failed (AE 0x%x)\n",
+				status);
+		goto out_free;
 	}
 
-	if (!*handle)
-		goto err;
-	ret = 0;
-err:
-	kfree(dinfo);
-	return ret;
-}
+	out_obj = output.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER) {
+		ata_port_printk(ap, KERN_WARNING,
+				"_GTM returned unexpected object type 0x%x\n",
+				out_obj->type);
 
-struct walk_info {		/* can be trimmed some */
-	struct device	*dev;
-	struct acpi_device *adev;
-	acpi_handle	handle;
-	acpi_integer	pcidevfn;
-	unsigned int	drivenum;
-	acpi_handle	obj_handle;
-	struct ata_port *ataport;
-	struct ata_device *atadev;
-	u32		sata_adr;
-	int		status;
-	char		basepath[ACPI_PATHNAME_MAX];
-	int		basepath_len;
-};
-
-static acpi_status get_devices(acpi_handle handle,
-				u32 level, void *context, void **return_value)
-{
-	acpi_status		status;
-	struct walk_info	*winfo = context;
-	struct acpi_buffer	namebuf = {ACPI_ALLOCATE_BUFFER, NULL};
-	char			*pathname;
-	struct acpi_buffer	buffer;
-	struct acpi_device_info	*dinfo;
-
-	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &namebuf);
-	if (status)
-		goto ret;
-	pathname = namebuf.pointer;
-
-	buffer.length = ACPI_ALLOCATE_BUFFER;
-	buffer.pointer = NULL;
-	status = acpi_get_object_info(handle, &buffer);
-	if (ACPI_FAILURE(status))
-		goto out2;
-
-	dinfo = buffer.pointer;
-
-	/* find full device path name for pcidevfn */
-	if (dinfo && (dinfo->valid & ACPI_VALID_ADR) &&
-	    dinfo->address == winfo->pcidevfn) {
-		if (ata_msg_probe(winfo->ataport))
-			ata_dev_printk(winfo->atadev, KERN_DEBUG,
-				":%s: matches pcidevfn (0x%llx)\n",
-				pathname, winfo->pcidevfn);
-		strlcpy(winfo->basepath, pathname,
-			sizeof(winfo->basepath));
-		winfo->basepath_len = strlen(pathname);
-		goto out;
+		goto out_free;
 	}
 
-	/* if basepath is not yet known, ignore this object */
-	if (!winfo->basepath_len)
-		goto out;
-
-	/* if this object is in scope of basepath, maybe use it */
-	if (strncmp(pathname, winfo->basepath,
-	    winfo->basepath_len) == 0) {
-		if (!(dinfo->valid & ACPI_VALID_ADR))
-			goto out;
-		if (ata_msg_probe(winfo->ataport))
-			ata_dev_printk(winfo->atadev, KERN_DEBUG,
-				"GOT ONE: (%s) root_port = 0x%llx,"
-				" port_num = 0x%llx\n", pathname,
-				SATA_ROOT_PORT(dinfo->address),
-				SATA_PORT_NUMBER(dinfo->address));
-		/* heuristics: */
-		if (SATA_PORT_NUMBER(dinfo->address) != NO_PORT_MULT)
-			if (ata_msg_probe(winfo->ataport))
-				ata_dev_printk(winfo->atadev,
-					KERN_DEBUG, "warning: don't"
-					" know how to handle SATA port"
-					" multiplier\n");
-		if (SATA_ROOT_PORT(dinfo->address) ==
-			winfo->ataport->port_no &&
-		    SATA_PORT_NUMBER(dinfo->address) == NO_PORT_MULT) {
-			if (ata_msg_probe(winfo->ataport))
-				ata_dev_printk(winfo->atadev,
-					KERN_DEBUG,
-					"THIS ^^^^^ is the requested"
-					" SATA drive (handle = 0x%p)\n",
-					handle);
-			winfo->sata_adr = dinfo->address;
-			winfo->obj_handle = handle;
-		}
+	if (out_obj->buffer.length != sizeof(struct ata_acpi_gtm)) {
+		ata_port_printk(ap, KERN_ERR,
+				"_GTM returned invalid length %d\n",
+				out_obj->buffer.length);
+		goto out_free;
 	}
-out:
-	kfree(dinfo);
-out2:
-	kfree(pathname);
 
-ret:
-	return status;
+	memcpy(gtm, out_obj->buffer.pointer, sizeof(struct ata_acpi_gtm));
+	rc = 0;
+ out_free:
+	kfree(output.pointer);
+	return rc;
 }
 
-/* Get the SATA drive _ADR object. */
-static int get_sata_adr(struct device *dev, acpi_handle handle,
-			acpi_integer pcidevfn, unsigned int drive,
-			struct ata_port *ap,
-			struct ata_device *atadev, u32 *dev_adr)
+/**
+ * ata_acpi_stm - execute _STM
+ * @ap: target ATA port
+ * @stm: timing parameter to _STM
+ *
+ * Evaluate _STM with timing parameter @stm.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -ENOENT if _STM doesn't exist, -errno on failure.
+ */
+static int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm)
 {
-	acpi_status	status;
-	struct walk_info *winfo;
-	int		err = -ENOMEM;
-
-	winfo = kzalloc(sizeof(struct walk_info), GFP_KERNEL);
-	if (!winfo)
-		goto out;
-
-	winfo->dev = dev;
-	winfo->atadev = atadev;
-	winfo->ataport = ap;
-	if (acpi_bus_get_device(handle, &winfo->adev) < 0)
-		if (ata_msg_probe(ap))
-			ata_dev_printk(winfo->atadev, KERN_DEBUG,
-				"acpi_bus_get_device failed\n");
-	winfo->handle = handle;
-	winfo->pcidevfn = pcidevfn;
-	winfo->drivenum = drive;
+	acpi_status status;
+	struct acpi_object_list         input;
+	union acpi_object               in_params[3];
 
-	status = acpi_get_devices(NULL, get_devices, winfo, NULL);
+	in_params[0].type = ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length = sizeof(struct ata_acpi_gtm);
+	in_params[0].buffer.pointer = (u8 *)stm;
+	/* Buffers for id may need byteswapping ? */
+	in_params[1].type = ACPI_TYPE_BUFFER;
+	in_params[1].buffer.length = 512;
+	in_params[1].buffer.pointer = (u8 *)ap->device[0].id;
+	in_params[2].type = ACPI_TYPE_BUFFER;
+	in_params[2].buffer.length = 512;
+	in_params[2].buffer.pointer = (u8 *)ap->device[1].id;
+
+	input.count = 3;
+	input.pointer = in_params;
+
+	status = acpi_evaluate_object(ap->acpi_handle, "_STM", &input, NULL);
+
+	if (status == AE_NOT_FOUND)
+		return -ENOENT;
 	if (ACPI_FAILURE(status)) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(winfo->atadev, KERN_DEBUG,
-				"%s: acpi_get_devices failed\n",
-				__FUNCTION__);
-		err = -ENODEV;
-	} else {
-		*dev_adr = winfo->sata_adr;
-		atadev->obj_handle = winfo->obj_handle;
-		err = 0;
+		ata_port_printk(ap, KERN_ERR,
+			"ACPI set timing mode failed (status=0x%x)\n", status);
+		return -EINVAL;
 	}
-	kfree(winfo);
-out:
-	return err;
+	return 0;
 }
 
 /**
- * do_drive_get_GTF - get the drive bootup default taskfile settings
+ * ata_dev_get_GTF - get the drive bootup default taskfile settings
  * @dev: target ATA device
- * @gtf_length: number of bytes of _GTF data returned at @gtf_address
- * @gtf_address: buffer containing _GTF taskfile arrays
+ * @gtf: output parameter for buffer containing _GTF taskfile arrays
+ * @ptr_to_free: pointer which should be freed
  *
  * This applies to both PATA and SATA drives.
  *
@@ -282,121 +216,41 @@ out:
  * The <variable number> is not known in advance, so have ACPI-CA
  * allocate the buffer as needed and return it, then free it later.
  *
- * The returned @gtf_length and @gtf_address are only valid if the
- * function return value is 0.
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
+ * contain valid data.  -errno on other errors.
  */
-static int do_drive_get_GTF(struct ata_device *dev, unsigned int *gtf_length,
-			    unsigned long *gtf_address, unsigned long *obj_loc)
+static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
+			   void **ptr_to_free)
 {
 	struct ata_port *ap = dev->ap;
 	acpi_status status;
-	acpi_handle dev_handle = NULL;
-	acpi_handle chan_handle, drive_handle;
-	acpi_integer pcidevfn = 0;
-	u32 dev_adr;
 	struct acpi_buffer output;
 	union acpi_object *out_obj;
-	struct device *gdev = ap->host->dev;
-	int err = -ENODEV;
+	int rc = 0;
 
-	*gtf_length = 0;
-	*gtf_address = 0UL;
-	*obj_loc = 0UL;
-
-	if (libata_noacpi)
-		return 0;
+	/* set up output buffer */
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
 			       __FUNCTION__, ap->port_no);
 
-	if (!ata_dev_enabled(dev) || (ap->flags & ATA_FLAG_DISABLED)) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG, "%s: ERR: "
-				"ata_dev_present: %d, PORT_DISABLED: %lu\n",
-				__FUNCTION__, ata_dev_enabled(dev),
-				ap->flags & ATA_FLAG_DISABLED);
-		goto out;
-	}
-
-	/* Don't continue if device has no _ADR method.
-	 * _GTF is intended for known motherboard devices. */
-	if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
-		err = pata_get_dev_handle(gdev, &dev_handle, &pcidevfn);
-		if (err < 0) {
-			if (ata_msg_probe(ap))
-				ata_dev_printk(dev, KERN_DEBUG,
-					"%s: pata_get_dev_handle failed (%d)\n",
-					__FUNCTION__, err);
-			goto out;
-		}
-	} else {
-		err = sata_get_dev_handle(gdev, &dev_handle, &pcidevfn);
-		if (err < 0) {
-			if (ata_msg_probe(ap))
-				ata_dev_printk(dev, KERN_DEBUG,
-					"%s: sata_get_dev_handle failed (%d\n",
-					__FUNCTION__, err);
-			goto out;
-		}
-	}
-
-	/* Get this drive's _ADR info. if not already known. */
-	if (!dev->obj_handle) {
-		if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
-			/* get child objects of dev_handle == channel objects,
-	 		 * + _their_ children == drive objects */
-			/* channel is ap->port_no */
-			chan_handle = acpi_get_child(dev_handle,
-						ap->port_no);
-			if (ata_msg_probe(ap))
-				ata_dev_printk(dev, KERN_DEBUG,
-					"%s: chan adr=%d: chan_handle=0x%p\n",
-					__FUNCTION__, ap->port_no,
-					chan_handle);
-			if (!chan_handle) {
-				err = -ENODEV;
-				goto out;
-			}
-			/* TBD: could also check ACPI object VALID bits */
-			drive_handle = acpi_get_child(chan_handle, dev->devno);
-			if (!drive_handle) {
-				err = -ENODEV;
-				goto out;
-			}
-			dev_adr = dev->devno;
-			dev->obj_handle = drive_handle;
-		} else {	/* for SATA mode */
-			dev_adr = SATA_ADR_RSVD;
-			err = get_sata_adr(gdev, dev_handle, pcidevfn, 0,
-					ap, dev, &dev_adr);
-		}
-		if (err < 0 || dev_adr == SATA_ADR_RSVD ||
-		    !dev->obj_handle) {
-			if (ata_msg_probe(ap))
-				ata_dev_printk(dev, KERN_DEBUG,
-					"%s: get_sata/pata_adr failed: "
-					"err=%d, dev_adr=%u, obj_handle=0x%p\n",
-					__FUNCTION__, err, dev_adr,
-					dev->obj_handle);
-			goto out;
-		}
-	}
-
-	/* Setting up output buffer */
-	output.length = ACPI_ALLOCATE_BUFFER;
-	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
-
 	/* _GTF has no input parameters */
-	err = -EIO;
-	status = acpi_evaluate_object(dev->obj_handle, "_GTF",
-					NULL, &output);
+	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
+
 	if (ACPI_FAILURE(status)) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				"%s: Run _GTF error: status = 0x%x\n",
-				__FUNCTION__, status);
-		goto out;
+		if (status != AE_NOT_FOUND) {
+			ata_dev_printk(dev, KERN_WARNING,
+				       "_GTF evaluation failed (AE 0x%x)\n",
+				       status);
+			rc = -EIO;
+		}
+		goto out_free;
 	}
 
 	if (!output.length || !output.pointer) {
@@ -406,43 +260,39 @@ static int do_drive_get_GTF(struct ata_device *dev, unsigned int *gtf_length,
 				__FUNCTION__,
 				(unsigned long long)output.length,
 				output.pointer);
-		kfree(output.pointer);
-		goto out;
+		goto out_free;
 	}
 
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		kfree(output.pointer);
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
-				"error: expected object type of "
-				" ACPI_TYPE_BUFFER, got 0x%x\n",
-				__FUNCTION__, out_obj->type);
-		err = -ENOENT;
-		goto out;
+		ata_dev_printk(dev, KERN_WARNING,
+			       "_GTF unexpected object type 0x%x\n",
+			       out_obj->type);
+		rc = -EINVAL;
+		goto out_free;
 	}
 
-	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
-	    out_obj->buffer.length % REGS_PER_GTF) {
-		if (ata_msg_drv(ap))
-			ata_dev_printk(dev, KERN_ERR,
-				"%s: unexpected GTF length (%d) or addr (0x%p)\n",
-				__FUNCTION__, out_obj->buffer.length,
-				out_obj->buffer.pointer);
-		err = -ENOENT;
-		goto out;
+	if (out_obj->buffer.length % REGS_PER_GTF) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "unexpected _GTF length (%d)\n",
+			       out_obj->buffer.length);
+		rc = -EINVAL;
+		goto out_free;
 	}
 
-	*gtf_length = out_obj->buffer.length;
-	*gtf_address = (unsigned long)out_obj->buffer.pointer;
-	*obj_loc = (unsigned long)out_obj;
+	*ptr_to_free = out_obj;
+	*gtf = (void *)out_obj->buffer.pointer;
+	rc = out_obj->buffer.length / REGS_PER_GTF;
+
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: returning "
-			"gtf_length=%d, gtf_address=0x%lx, obj_loc=0x%lx\n",
-			__FUNCTION__, *gtf_length, *gtf_address, *obj_loc);
-	err = 0;
-out:
-	return err;
+			"gtf=%p, gtf_count=%d, ptr_to_free=%p\n",
+			__FUNCTION__, *gtf, rc, *ptr_to_free);
+	return rc;
+
+ out_free:
+	kfree(output.pointer);
+	return rc;
 }
 
 /**
@@ -461,154 +311,99 @@ out:
  * function also waits for idle after writing control and before
  * writing the remaining registers.
  *
- * LOCKING: TBD:
- * Inherited from caller.
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
-static void taskfile_load_raw(struct ata_device *dev,
-			      const struct taskfile_array *gtf)
+static int taskfile_load_raw(struct ata_device *dev,
+			      const struct ata_acpi_gtf *gtf)
 {
 	struct ata_port *ap = dev->ap;
-	struct ata_taskfile tf;
-	unsigned int err;
+	struct ata_taskfile tf, rtf;
+	unsigned int err_mask;
 
-	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: (0x1f1-1f7): hex: "
-			"%02x %02x %02x %02x %02x %02x %02x\n",
-			__FUNCTION__,
-			gtf->tfa[0], gtf->tfa[1], gtf->tfa[2],
-			gtf->tfa[3], gtf->tfa[4], gtf->tfa[5], gtf->tfa[6]);
-
-	if ((gtf->tfa[0] == 0) && (gtf->tfa[1] == 0) && (gtf->tfa[2] == 0)
-	    && (gtf->tfa[3] == 0) && (gtf->tfa[4] == 0) && (gtf->tfa[5] == 0)
-	    && (gtf->tfa[6] == 0))
-		return;
+	if ((gtf->tf[0] == 0) && (gtf->tf[1] == 0) && (gtf->tf[2] == 0)
+	    && (gtf->tf[3] == 0) && (gtf->tf[4] == 0) && (gtf->tf[5] == 0)
+	    && (gtf->tf[6] == 0))
+		return 0;
 
 	ata_tf_init(dev, &tf);
 
 	/* convert gtf to tf */
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE; /* TBD */
 	tf.protocol = ATA_PROT_NODATA;
-	tf.feature = gtf->tfa[0];	/* 0x1f1 */
-	tf.nsect   = gtf->tfa[1];	/* 0x1f2 */
-	tf.lbal    = gtf->tfa[2];	/* 0x1f3 */
-	tf.lbam    = gtf->tfa[3];	/* 0x1f4 */
-	tf.lbah    = gtf->tfa[4];	/* 0x1f5 */
-	tf.device  = gtf->tfa[5];	/* 0x1f6 */
-	tf.command = gtf->tfa[6];	/* 0x1f7 */
-
-	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
-	if (err && ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_ERR,
-			"%s: ata_exec_internal failed: %u\n",
-			__FUNCTION__, err);
-}
-
-/**
- * do_drive_set_taskfiles - write the drive taskfile settings from _GTF
- * @dev: target ATA device
- * @gtf_length: total number of bytes of _GTF taskfiles
- * @gtf_address: location of _GTF taskfile arrays
- *
- * This applies to both PATA and SATA drives.
- *
- * Write {gtf_address, length gtf_length} in groups of
- * REGS_PER_GTF bytes.
- */
-static int do_drive_set_taskfiles(struct ata_device *dev,
-				  unsigned int gtf_length,
-				  unsigned long gtf_address)
-{
-	struct ata_port *ap = dev->ap;
-	int err = -ENODEV;
-	int gtf_count = gtf_length / REGS_PER_GTF;
-	int ix;
-	struct taskfile_array	*gtf;
+	tf.feature = gtf->tf[0];	/* 0x1f1 */
+	tf.nsect   = gtf->tf[1];	/* 0x1f2 */
+	tf.lbal    = gtf->tf[2];	/* 0x1f3 */
+	tf.lbam    = gtf->tf[3];	/* 0x1f4 */
+	tf.lbah    = gtf->tf[4];	/* 0x1f5 */
+	tf.device  = gtf->tf[5];	/* 0x1f6 */
+	tf.command = gtf->tf[6];	/* 0x1f7 */
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
-			       __FUNCTION__, ap->port_no);
-
-	if (libata_noacpi || !(ap->flags & ATA_FLAG_ACPI_SATA))
-		return 0;
-
-	if (!ata_dev_enabled(dev) || (ap->flags & ATA_FLAG_DISABLED))
-		goto out;
-	if (!gtf_count)		/* shouldn't be here */
-		goto out;
-
-	if (gtf_length % REGS_PER_GTF) {
-		if (ata_msg_drv(ap))
-			ata_dev_printk(dev, KERN_ERR,
-				"%s: unexpected GTF length (%d)\n",
-				__FUNCTION__, gtf_length);
-		goto out;
-	}
-
-	for (ix = 0; ix < gtf_count; ix++) {
-		gtf = (struct taskfile_array *)
-			(gtf_address + ix * REGS_PER_GTF);
-
-		/* send all TaskFile registers (0x1f1-0x1f7) *in*that*order* */
-		taskfile_load_raw(dev, gtf);
+		ata_dev_printk(dev, KERN_DEBUG, "executing ACPI cmd "
+			       "%02x/%02x:%02x:%02x:%02x:%02x:%02x\n",
+			       tf.command, tf.feature, tf.nsect,
+			       tf.lbal, tf.lbam, tf.lbah, tf.device);
+
+	rtf = tf;
+	err_mask = ata_exec_internal(dev, &rtf, NULL, DMA_NONE, NULL, 0);
+	if (err_mask) {
+		ata_dev_printk(dev, KERN_ERR,
+			"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x failed "
+			"(Emask=0x%x Stat=0x%02x Err=0x%02x)\n",
+			tf.command, tf.feature, tf.nsect, tf.lbal, tf.lbam,
+			tf.lbah, tf.device, err_mask, rtf.command, rtf.feature);
+		return -EIO;
 	}
 
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 
 /**
  * ata_acpi_exec_tfs - get then write drive taskfile settings
- * @ap: the ata_port for the drive
+ * @dev: target ATA device
  *
- * This applies to both PATA and SATA drives.
+ * Evaluate _GTF and excute returned taskfiles.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * Number of executed taskfiles on success, 0 if _GTF doesn't exist or
+ * doesn't contain valid data.  -errno on other errors.
  */
-int ata_acpi_exec_tfs(struct ata_port *ap)
+static int ata_acpi_exec_tfs(struct ata_device *dev)
 {
-	int ix;
-	int ret = 0;
-	unsigned int gtf_length;
-	unsigned long gtf_address;
-	unsigned long obj_loc;
-
-	if (libata_noacpi)
-		return 0;
-	/*
-	 * TBD - implement PATA support.  For now,
-	 * we should not run GTF on PATA devices since some
-	 * PATA require execution of GTM/STM before GTF.
-	 */
-	if (!(ap->flags & ATA_FLAG_ACPI_SATA))
-		return 0;
-
-	for (ix = 0; ix < ATA_MAX_DEVICES; ix++) {
-		struct ata_device *dev = &ap->device[ix];
-
-		if (!ata_dev_enabled(dev))
-			continue;
-
-		ret = do_drive_get_GTF(dev, &gtf_length, &gtf_address,
-				       &obj_loc);
-		if (ret < 0) {
-			if (ata_msg_probe(ap))
-				ata_port_printk(ap, KERN_DEBUG,
-					"%s: get_GTF error (%d)\n",
-					__FUNCTION__, ret);
-			break;
-		}
-
-		ret = do_drive_set_taskfiles(dev, gtf_length, gtf_address);
-		kfree((void *)obj_loc);
-		if (ret < 0) {
-			if (ata_msg_probe(ap))
-				ata_port_printk(ap, KERN_DEBUG,
-					"%s: set_taskfiles error (%d)\n",
-					__FUNCTION__, ret);
-			break;
-		}
+	struct ata_acpi_gtf *gtf = NULL;
+	void *ptr_to_free = NULL;
+	int gtf_count, i, rc;
+
+	/* get taskfiles */
+	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
+	if (rc < 0)
+		return rc;
+	gtf_count = rc;
+
+	/* execute them */
+	for (i = 0, rc = 0; i < gtf_count; i++) {
+		int tmp;
+
+		/* ACPI errors are eventually ignored.  Run till the
+		 * end even after errors.
+		 */
+		tmp = taskfile_load_raw(dev, gtf++);
+		if (!rc)
+			rc = tmp;
 	}
 
-	return ret;
+	kfree(ptr_to_free);
+
+	if (rc == 0)
+		return gtf_count;
+	return rc;
 }
 
 /**
@@ -620,62 +415,25 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
  * ATM this function never returns a failure.  It is an optional
  * method and if it fails for whatever reason, we should still
  * just keep going.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
-int ata_acpi_push_id(struct ata_device *dev)
+static int ata_acpi_push_id(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->ap;
-	acpi_handle handle;
-	acpi_integer pcidevfn;
 	int err;
-	struct device *gdev = ap->host->dev;
-	u32 dev_adr;
 	acpi_status status;
 	struct acpi_object_list input;
 	union acpi_object in_params[1];
 
-	if (libata_noacpi)
-		return 0;
-
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
 			       __FUNCTION__, dev->devno, ap->port_no);
 
-	/* Don't continue if not a SATA device. */
-	if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				"%s: Not a SATA device\n", __FUNCTION__);
-		goto out;
-	}
-
-	/* Don't continue if device has no _ADR method.
-	 * _SDD is intended for known motherboard devices. */
-	err = sata_get_dev_handle(gdev, &handle, &pcidevfn);
-	if (err < 0) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				"%s: sata_get_dev_handle failed (%d\n",
-				__FUNCTION__, err);
-		goto out;
-	}
-
-	/* Get this drive's _ADR info, if not already known */
-	if (!dev->obj_handle) {
-		dev_adr = SATA_ADR_RSVD;
-		err = get_sata_adr(gdev, handle, pcidevfn, dev->devno, ap, dev,
-					&dev_adr);
-		if (err < 0 || dev_adr == SATA_ADR_RSVD ||
-			!dev->obj_handle) {
-			if (ata_msg_probe(ap))
-				ata_dev_printk(dev, KERN_DEBUG,
-					"%s: get_sata_adr failed: "
-					"err=%d, dev_adr=%u, obj_handle=0x%p\n",
-					__FUNCTION__, err, dev_adr,
-					dev->obj_handle);
-			goto out;
-		}
-	}
-
 	/* Give the drive Identify data to the drive via the _SDD method */
 	/* _SDD: set up input parameters */
 	input.count = 1;
@@ -687,20 +445,150 @@ int ata_acpi_push_id(struct ata_device *dev)
 
 	/* It's OK for _SDD to be missing too. */
 	swap_buf_le16(dev->id, ATA_ID_WORDS);
-	status = acpi_evaluate_object(dev->obj_handle, "_SDD", &input, NULL);
+	status = acpi_evaluate_object(dev->acpi_handle, "_SDD", &input, NULL);
 	swap_buf_le16(dev->id, ATA_ID_WORDS);
 
 	err = ACPI_FAILURE(status) ? -EIO : 0;
-	if (err < 0) {
-		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "%s _SDD error: status = 0x%x\n",
-				       __FUNCTION__, status);
+	if (err < 0)
+		ata_dev_printk(dev, KERN_WARNING,
+			       "ACPI _SDD failed (AE 0x%x)\n", status);
+
+	return err;
+}
+
+/**
+ * ata_acpi_on_suspend - ATA ACPI hook called on suspend
+ * @ap: target ATA port
+ *
+ * This function is called when @ap is about to be suspended.  All
+ * devices are already put to sleep but the port_suspend() callback
+ * hasn't been executed yet.  Error return from this function aborts
+ * suspend.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int ata_acpi_on_suspend(struct ata_port *ap)
+{
+	unsigned long flags;
+	int rc;
+
+	/* proceed iff per-port acpi_handle is valid */
+	if (!ap->acpi_handle)
+		return 0;
+	BUG_ON(ap->flags & ATA_FLAG_ACPI_SATA);
+
+	/* store timing parameters */
+	rc = ata_acpi_gtm(ap, &ap->acpi_gtm);
+
+	spin_lock_irqsave(ap->lock, flags);
+	if (rc == 0)
+		ap->pflags |= ATA_PFLAG_GTM_VALID;
+	else
+		ap->pflags &= ~ATA_PFLAG_GTM_VALID;
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (rc == -ENOENT)
+		rc = 0;
+	return rc;
+}
+
+/**
+ * ata_acpi_on_resume - ATA ACPI hook called on resume
+ * @ap: target ATA port
+ *
+ * This function is called when @ap is resumed - right after port
+ * itself is resumed but before any EH action is taken.
+ *
+ * LOCKING:
+ * EH context.
+ */
+void ata_acpi_on_resume(struct ata_port *ap)
+{
+	int i;
+
+	if (ap->acpi_handle && (ap->pflags & ATA_PFLAG_GTM_VALID)) {
+		BUG_ON(ap->flags & ATA_FLAG_ACPI_SATA);
+
+		/* restore timing parameters */
+		ata_acpi_stm(ap, &ap->acpi_gtm);
 	}
 
-	/* always return success */
-out:
-	return 0;
+	/* schedule _GTF */
+	for (i = 0; i < ATA_MAX_DEVICES; i++)
+		ap->device[i].flags |= ATA_DFLAG_ACPI_PENDING;
 }
 
+/**
+ * ata_acpi_on_devcfg - ATA ACPI hook called on device donfiguration
+ * @dev: target ATA device
+ *
+ * This function is called when @dev is about to be configured.
+ * IDENTIFY data might have been modified after this hook is run.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * Positive number if IDENTIFY data needs to be refreshed, 0 if not,
+ * -errno on failure.
+ */
+int ata_acpi_on_devcfg(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->ap;
+	struct ata_eh_context *ehc = &ap->eh_context;
+	int acpi_sata = ap->flags & ATA_FLAG_ACPI_SATA;
+	int rc;
+
+	if (!dev->acpi_handle)
+		return 0;
+
+	/* do we need to do _GTF? */
+	if (!(dev->flags & ATA_DFLAG_ACPI_PENDING) &&
+	    !(acpi_sata && (ehc->i.flags & ATA_EHI_DID_HARDRESET)))
+		return 0;
+
+	/* do _SDD if SATA */
+	if (acpi_sata) {
+		rc = ata_acpi_push_id(dev);
+		if (rc)
+			goto acpi_err;
+	}
+
+	/* do _GTF */
+	rc = ata_acpi_exec_tfs(dev);
+	if (rc < 0)
+		goto acpi_err;
+
+	dev->flags &= ~ATA_DFLAG_ACPI_PENDING;
+
+	/* refresh IDENTIFY page if any _GTF command has been executed */
+	if (rc > 0) {
+		rc = ata_dev_reread_id(dev, 0);
+		if (rc < 0) {
+			ata_dev_printk(dev, KERN_ERR, "failed to IDENTIFY "
+				       "after ACPI commands\n");
+			return rc;
+		}
+	}
 
+	return 0;
+
+ acpi_err:
+	/* let EH retry on the first failure, disable ACPI on the second */
+	if (dev->flags & ATA_DFLAG_ACPI_FAILED) {
+		ata_dev_printk(dev, KERN_WARNING, "ACPI on devcfg failed the "
+			       "second time, disabling (errno=%d)\n", rc);
+
+		dev->acpi_handle = NULL;
+
+		/* if port is working, request IDENTIFY reload and continue */
+		if (!(ap->pflags & ATA_PFLAG_FROZEN))
+			rc = 1;
+	}
+	dev->flags |= ATA_DFLAG_ACPI_FAILED;
+	return rc;
+}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 981b397..5b25311 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1845,7 +1845,8 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 int ata_dev_configure(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->ap;
-	int print_info = ap->eh_context.i.flags & ATA_EHI_PRINTINFO;
+	struct ata_eh_context *ehc = &ap->eh_context;
+	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	const u16 *id = dev->id;
 	unsigned int xfer_mask;
 	char revbuf[7];		/* XYZ-99\0 */
@@ -1862,15 +1863,10 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
-	/* set _SDD */
-	rc = ata_acpi_push_id(dev);
-	if (rc) {
-		ata_dev_printk(dev, KERN_WARNING, "failed to set _SDD(%d)\n",
-			rc);
-	}
-
-	/* retrieve and execute the ATA task file of _GTF */
-	ata_acpi_exec_tfs(ap);
+	/* let ACPI work its magic */
+	rc = ata_acpi_on_devcfg(dev);
+	if (rc)
+		return rc;
 
 	/* print device capabilities */
 	if (ata_msg_probe(ap))
@@ -3359,7 +3355,7 @@ int ata_std_prereset(struct ata_port *ap, unsigned long deadline)
 		return 0;
 
 	/* if SATA, resume phy */
-	if (ap->cbl == ATA_CBL_SATA) {
+	if (ap->flags & ATA_FLAG_SATA) {
 		rc = sata_phy_resume(ap, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
@@ -4107,6 +4103,68 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_fill_sg_dumb - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command. Perform the fill
+ *	so that we avoid writing any length 64K records for
+ *	controllers that don't follow the spec.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len, blen;
+
+ 		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			blen = len & 0xffff;
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			if (blen == 0) {
+			   /* Some PATA chipsets like the CS5530 can't
+			      cope with 0x0000 meaning 64K as the spec says */
+				ap->prd[idx].flags_len = cpu_to_le32(0x8000);
+				blen = 0x8000;
+				ap->prd[++idx].addr = cpu_to_le32(addr + 0x8000);
+			}
+			ap->prd[idx].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx)
+		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
  *	ata_check_atapi_dma - Check whether ATAPI DMA can be supported
  *	@qc: Metadata associated with taskfile to check
  *
@@ -4153,6 +4211,23 @@ void ata_qc_prep(struct ata_queued_cmd *qc)
 	ata_fill_sg(qc);
 }
 
+/**
+ *	ata_dumb_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_dumb_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_fill_sg_dumb(qc);
+}
+
 void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
 
 /**
@@ -5660,7 +5735,7 @@ irqreturn_t ata_interrupt (int irq, void *dev_instance)
  */
 int sata_scr_valid(struct ata_port *ap)
 {
-	return ap->cbl == ATA_CBL_SATA && ap->ops->scr_read;
+	return (ap->flags & ATA_FLAG_SATA) && ap->ops->scr_read;
 }
 
 /**
@@ -6293,6 +6368,9 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	if (rc)
 		return rc;
 
+	/* associate with ACPI nodes */
+	ata_acpi_associate(host);
+
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -6324,7 +6402,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		if (!ata_port_is_dummy(ap))
 			ata_port_printk(ap, KERN_INFO, "%cATA max %s cmd 0x%p "
 					"ctl 0x%p bmdma 0x%p irq %d\n",
-					ap->cbl == ATA_CBL_SATA ? 'S' : 'P',
+					(ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
 					ata_mode_string(xfer_mask),
 					ap->ioaddr.cmd_addr,
 					ap->ioaddr.ctl_addr,
@@ -6822,6 +6900,7 @@ EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_data_xfer);
 EXPORT_SYMBOL_GPL(ata_data_xfer_noirq);
 EXPORT_SYMBOL_GPL(ata_qc_prep);
+EXPORT_SYMBOL_GPL(ata_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f7582c9..9ee0a8c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2154,19 +2154,25 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 
 	WARN_ON(ap->pflags & ATA_PFLAG_SUSPENDED);
 
+	/* tell ACPI we're suspending */
+	rc = ata_acpi_on_suspend(ap);
+	if (rc)
+		goto out;
+
 	/* suspend */
 	ata_eh_freeze_port(ap);
 
 	if (ap->ops->port_suspend)
 		rc = ap->ops->port_suspend(ap, ap->pm_mesg);
 
+ out:
 	/* report result */
 	spin_lock_irqsave(ap->lock, flags);
 
 	ap->pflags &= ~ATA_PFLAG_PM_PENDING;
 	if (rc == 0)
 		ap->pflags |= ATA_PFLAG_SUSPENDED;
-	else
+	else if (ap->pflags & ATA_PFLAG_FROZEN)
 		ata_port_schedule_eh(ap);
 
 	if (ap->pm_result) {
@@ -2207,6 +2213,9 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 	if (ap->ops->port_resume)
 		rc = ap->ops->port_resume(ap);
 
+	/* tell ACPI that we're resuming */
+	ata_acpi_on_resume(ap);
+
 	/* report result */
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~(ATA_PFLAG_PM_PENDING | ATA_PFLAG_SUSPENDED);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4ddf00c..cfde22d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2620,7 +2620,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 			ata_dev_printk(dev, KERN_WARNING,
 				       "invalid multi_count %u ignored\n",
 				       multi_count);
-	}	
+	}
 
 	/* READ/WRITE LONG use a non-standard sect_size */
 	qc->sect_size = ATA_SECT_SIZE;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5e24666..ba17fc5 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -98,17 +98,15 @@ extern struct ata_port *ata_port_alloc(struct ata_host *host);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
-extern int ata_acpi_exec_tfs(struct ata_port *ap);
-extern int ata_acpi_push_id(struct ata_device *dev);
+extern void ata_acpi_associate(struct ata_host *host);
+extern int ata_acpi_on_suspend(struct ata_port *ap);
+extern void ata_acpi_on_resume(struct ata_port *ap);
+extern int ata_acpi_on_devcfg(struct ata_device *adev);
 #else
-static inline int ata_acpi_exec_tfs(struct ata_port *ap)
-{
-	return 0;
-}
-static inline int ata_acpi_push_id(struct ata_device *dev)
-{
-	return 0;
-}
+static inline void ata_acpi_associate(struct ata_host *host) { }
+static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
+static inline void ata_acpi_on_resume(struct ata_port *ap) { }
+static inline int ata_acpi_on_devcfg(struct ata_device *adev) { return 0; }
 #endif
 
 /* libata-scsi.c */
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 75e95bd..30c4276 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -520,14 +520,14 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_early = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &ali_early_port_ops
 	};
 	/* Revision 0x20 added DMA */
 	static const struct ata_port_info info_20 = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &ali_20_port_ops
@@ -535,7 +535,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Revision 0x20 with support logic added UDMA */
 	static const struct ata_port_info info_20_udma = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,	/* UDMA33 */
@@ -544,37 +544,37 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Revision 0xC2 adds UDMA66 */
 	static const struct ata_port_info info_c2 = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA66 for now */
 	static const struct ata_port_info info_c3 = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA100 */
 	static const struct ata_port_info info_c4 = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
 	static const struct ata_port_info info_c5 = {
 		.sht = &ali_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &ali_c5_port_ops
 	};
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index a16f629..b9c44c5 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -541,7 +541,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info info[10] = {
 		{	/* 0: AMD 7401 */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,	/* No SWDMA */
 			.udma_mask = 0x07,	/* UDMA 33 */
@@ -549,74 +549,74 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		},
 		{	/* 1: Early AMD7409 - no swdma */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,	/* UDMA 66 */
+			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 2: AMD 7409, no swdma errata */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,	/* UDMA 66 */
+			.udma_mask = ATA_UDMA4,	/* UDMA 66 */
 			.port_ops = &amd66_port_ops
 		},
 		{	/* 3: AMD 7411 */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 4: AMD 7441 */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		},
 		{	/* 5: AMD 8111*/
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x7f,	/* UDMA 133, no swdma */
+			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 6: AMD 8111 UDMA 100 (Serenade) */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100, no swdma */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100, no swdma */
 			.port_ops = &amd133_port_ops
 		},
 		{	/* 7: Nvidia Nforce */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &nv100_port_ops
 		},
 		{	/* 8: Nvidia Nforce2 and later */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x7f,	/* UDMA 133, no swdma */
+			.udma_mask = ATA_UDMA6,	/* UDMA 133, no swdma */
 			.port_ops = &nv133_port_ops
 		},
 		{	/* 9: AMD CS5536 (Geode companion) */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,	/* UDMA 100 */
+			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
 			.port_ops = &amd100_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 03b6ddd..ce589d9 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -416,7 +416,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	static int printed_version;
 	static const struct ata_port_info info_6210 = {
 		.sht		= &artop_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA2,
@@ -424,7 +424,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	};
 	static const struct ata_port_info info_626x = {
 		.sht		= &artop_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA4,
@@ -432,7 +432,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	};
 	static const struct ata_port_info info_626x_fast = {
 		.sht		= &artop_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask 	= ATA_UDMA5,
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 8449146..80509be 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -270,7 +270,7 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &atiixp_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x06,	/* No MWDMA0 support */
 		.udma_mask = 0x3F,
@@ -285,6 +285,7 @@ static const struct pci_device_id atiixp[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP300_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 31cbf8d..0feb5ae 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -251,7 +251,7 @@ static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &cmd640_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &cmd640_port_ops
 	};
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 320a5b1..dc443e7 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -380,21 +380,21 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info cmd_info[6] = {
 		{	/* CMD 643 - no UDMA */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with broken UDMA */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 with working UDMA */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA1,
@@ -402,14 +402,14 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		},
 		{	/* CMD 646 rev 1  */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.port_ops = &cmd646r1_port_ops
 		},
 		{	/* CMD 648 */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA2,
@@ -417,7 +417,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		},
 		{	/* CMD 649 */
 			.sht = &cmd64x_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA3,
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 00cf013..6bf037d 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -146,7 +146,7 @@ static struct scsi_host_template cs5520_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -178,7 +178,7 @@ static struct ata_port_operations cs5520_port_ops = {
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
-	.qc_prep		= ata_qc_prep,
+	.qc_prep		= ata_dumb_qc_prep,
 	.qc_issue		= ata_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
 
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 848f030..3fca589 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -167,7 +167,7 @@ static struct scsi_host_template cs5530_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -201,7 +201,7 @@ static struct ata_port_operations cs5530_port_ops = {
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= ata_cable_40wire,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
@@ -337,7 +337,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &cs5530_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
@@ -346,7 +346,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* The docking connector doesn't do UDMA, and it seems not MWDMA */
 	static const struct ata_port_info info_palmax_secondary = {
 		.sht = &cs5530_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &cs5530_port_ops
 	};
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index aa3256f..360b6f3 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -225,10 +225,10 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &cs5535_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &cs5535_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index d41a769..6cbc877 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -167,7 +167,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 {
 	static const struct ata_port_info info = {
 		.sht = &cy82c693_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &cy82c693_port_ops
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 079248a..c8ba59c 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -303,7 +303,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht		= &efar_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.udma_mask 	= 0x0f, /* UDMA 66 */
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 0c9cb60..6f7d34a 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -393,10 +393,10 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_hpt366 = {
 		.sht = &hpt36x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x1f,
+		.udma_mask = ATA_UDMA4,
 		.port_ops = &hpt366_port_ops
 	};
 	struct ata_port_info info = info_hpt366;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index a8c0cbe..b0af65a 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -889,25 +889,25 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT370 - UDMA100 */
 	static const struct ata_port_info info_hpt370 = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
 	static const struct ata_port_info info_hpt370a = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
 	static const struct ata_port_info info_hpt370_33 = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x0f,
@@ -916,7 +916,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT370A - UDMA100 */
 	static const struct ata_port_info info_hpt370a_33 = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x0f,
@@ -925,19 +925,19 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT371, 372 and friends - UDMA133 */
 	static const struct ata_port_info info_hpt372 = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA100 */
 	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt374_port_ops
 	};
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index e947433..aa29cde 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -490,10 +490,10 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* HPT372N and friends - UDMA133 */
 	static const struct ata_port_info info = {
 		.sht = &hpt3x2n_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt3x2n_port_ops
 	};
 	struct ata_port_info port = info;
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 8ce5e23..d928c91 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -173,7 +173,7 @@ static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index c791a46..321d98b 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -530,7 +530,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 
 		ap->pio_mask = 0x1f;
 		ap->mwdma_mask = info->mwdma_mask;
-		ap->flags |= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST;
+		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ops = &pata_icside_port_ops;
 
 		pata_icside_setup_ioaddr(&ap->ioaddr, info->base, info->port[i]);
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 95b0bb6..b8af55e 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -313,10 +313,10 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht		= &it8213_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask 	= 0x1f, /* UDMA 100 */
+		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 12c6e08..b67bbf6 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -714,17 +714,17 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	static const struct ata_port_info info_smart = {
 		.sht = &it821x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &it821x_smart_port_ops
 	};
 	static const struct ata_port_info info_passthru = {
 		.sht = &it821x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_passthru_port_ops
 	};
 
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 8d2bc1e..4ca7fd6 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -1,13 +1,14 @@
 /*
  * ixp4xx PATA/Compact Flash driver
- * Copyright (c) 2006 Tower Technologies
+ * Copyright (C) 2006-07 Tower Technologies
  * Author: Alessandro Zummo <a.zummo@towertech.it>
  *
  * An ATA driver to handle a Compact Flash connected
  * to the ixp4xx expansion bus in TrueIDE mode. The CF
  * must have it chip selects connected to two CS lines
- * on the ixp4xx. The interrupt line is optional, if not
- * specified the driver will run in polling mode.
+ * on the ixp4xx. In the irq is not available, you might
+ * want to modify both this driver and libata to run in
+ * polling mode.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -23,7 +24,7 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.3"
+#define DRV_VERSION	"0.2"
 
 static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 {
@@ -42,13 +43,6 @@ static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 	return 0;
 }
 
-static void ixp4xx_phy_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
-}
-
 static void ixp4xx_mmio_data_xfer(struct ata_device *adev, unsigned char *buf,
 				unsigned int buflen, int write_data)
 {
@@ -56,7 +50,7 @@ static void ixp4xx_mmio_data_xfer(struct ata_device *adev, unsigned char *buf,
 	unsigned int words = buflen >> 1;
 	u16 *buf16 = (u16 *) buf;
 	struct ata_port *ap = adev->ap;
-	void __iomem *mmio = (void __iomem *)ap->ioaddr.data_addr;
+	void __iomem *mmio = ap->ioaddr.data_addr;
 	struct ixp4xx_pata_data *data = ap->host->dev->platform_data;
 
 	/* set the expansion bus in 16bit mode and restore
@@ -92,10 +86,6 @@ static void ixp4xx_mmio_data_xfer(struct ata_device *adev, unsigned char *buf,
 	*data->cs0_cfg |= 0x01;
 }
 
-static void ixp4xx_irq_clear(struct ata_port *ap)
-{
-}
-
 static struct scsi_host_template ixp4xx_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -115,29 +105,32 @@ static struct scsi_host_template ixp4xx_sht = {
 };
 
 static struct ata_port_operations ixp4xx_port_ops = {
-	.set_mode	= ixp4xx_set_mode,
-	.mode_filter	= ata_pci_default_filter,
-
-	.port_disable	= ata_port_disable,
-	.tf_load	= ata_tf_load,
-	.tf_read	= ata_tf_read,
-	.check_status 	= ata_check_status,
-	.exec_command	= ata_exec_command,
-	.dev_select 	= ata_std_dev_select,
-
-	.qc_prep 	= ata_qc_prep,
-	.qc_issue	= ata_qc_issue_prot,
-	.eng_timeout	= ata_eng_timeout,
-	.data_xfer	= ixp4xx_mmio_data_xfer,
-	.cable_detect	= ata_cable_40wire,
-
-	.irq_clear	= ixp4xx_irq_clear,
-	.irq_on		= ata_irq_on,
-	.irq_ack	= ata_irq_ack,
-
-	.port_start	= ata_port_start,
-
-	.phy_reset	= ixp4xx_phy_reset,
+	.set_mode		= ixp4xx_set_mode,
+	.mode_filter		= ata_pci_default_filter,
+
+	.port_disable		= ata_port_disable,
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.exec_command		= ata_exec_command,
+	.check_status 		= ata_check_status,
+	.dev_select 		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= ata_bmdma_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	.qc_prep 		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ixp4xx_mmio_data_xfer,
+	.cable_detect		= ata_cable_40wire,
+
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_dummy_irq_ack,
+
+	.port_start		= ata_port_start,
 };
 
 static void ixp4xx_setup_port(struct ata_ioports *ioaddr,
@@ -178,7 +171,6 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	struct ata_host *host;
 	struct ata_port *ap;
 	struct ixp4xx_pata_data *data = pdev->dev.platform_data;
-	int rc;
 
 	cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -211,10 +203,6 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	ap->pio_mask = 0x1f; /* PIO4 */
 	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
 
-	/* run in polling mode if no irq has been assigned */
-	if (!irq)
-		ap->flags |= ATA_FLAG_PIO_POLLING;
-
 	ixp4xx_setup_port(&ap->ioaddr, data);
 
 	dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 2af7ff8..4d67f23 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -193,11 +193,11 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 {
 	static const struct ata_port_info info = {
 		.sht		= &jmicron_sht,
-		.flags	= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags	= ATA_FLAG_SLAVE_POSS,
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x3f,
+		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &jmicron_ops,
 	};
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index edbfe0d..87594c0 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -163,22 +163,22 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 {
 	static const struct ata_port_info info = {
 		.sht		= &marvell_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x3f,
+		.udma_mask 	= ATA_UDMA5,
 
 		.port_ops	= &marvell_ops,
 	};
 	static const struct ata_port_info info_sata = {
 		.sht		= &marvell_sht,
 		/* Slave possible as its magically mapped not real */
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask 	= 0x7f,
+		.udma_mask 	= ATA_UDMA6,
 
 		.port_ops	= &marvell_ops,
 	};
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 81f5634..40eb574 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -94,12 +94,12 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht		= &netcell_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		/* Actually we don't really care about these as the
 		   firmware deals with it */
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask 	= 0x3f, /* UDMA 133 */
+		.udma_mask 	= ATA_UDMA5, /* UDMA 133 */
 		.port_ops	= &netcell_ops,
 	};
 	const struct ata_port_info *port_info[] = { &info, NULL };
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index ea70ec7..2f5d714 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -193,7 +193,7 @@ static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &ns87410_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x0F,
 		.port_ops = &ns87410_port_ops
 	};
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 29c23dd..091a70a 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -291,7 +291,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht		= &oldpiix_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.port_ops	= &oldpiix_pata_ops,
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 1c44653..458bf67 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -218,7 +218,7 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &opti_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &opti_port_ops
 	};
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 3093b02..f89bdfd 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -484,14 +484,14 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_82c700 = {
 		.sht = &optidma_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &optidma_port_ops
 	};
 	static const struct ata_port_info info_82c700_udma = {
 		.sht = &optidma_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index d277246..92447be 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -320,7 +320,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	static const struct ata_port_info info[3] = {
 		{
 			.sht = &pdc202xx_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA2,
@@ -328,7 +328,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		},
 		{
 			.sht = &pdc202xx_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA4,
@@ -336,7 +336,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		},
 		{
 			.sht = &pdc202xx_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index cbb7866..79f841b 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -139,6 +139,7 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	struct resource *io_res, *ctl_res;
 	struct ata_host *host;
 	struct ata_port *ap;
+	struct pata_platform_info *pp_info;
 	unsigned int mmio;
 
 	/*
@@ -208,11 +209,12 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 
 	ap->ioaddr.altstatus_addr = ap->ioaddr.ctl_addr;
 
-	pata_platform_setup_port(&ap->ioaddr, pdev->dev.platform_data);
+	pp_info = (struct pata_platform_info *)(pdev->dev.platform_data);
+	pata_platform_setup_port(&ap->ioaddr, pp_info);
 
 	/* activate */
 	return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-				 0, &pata_platform_sht);
+				 pp_info->irq_flags, &pata_platform_sht);
 }
 
 /**
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index ba96b54..7d1aabe 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -257,7 +257,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht		= &radisys_sht,
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.udma_mask	= 0x14, /* UDMA33/66 only */
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index a3488b4..7632fcb 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -133,7 +133,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht = &rz1000_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &rz1000_port_ops
 	};
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 1233063..b8b2d11 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -185,7 +185,7 @@ static struct scsi_host_template sc1200_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -219,7 +219,7 @@ static struct ata_port_operations sc1200_port_ops = {
 	.bmdma_stop	= ata_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
@@ -245,7 +245,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &sc1200_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 1e8f421..0231aba 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -478,31 +478,31 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	static const struct ata_port_info info[4] = {
 		{ /* OSB4 */
 			.sht = &serverworks_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x07,
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* OSB4 no UDMA */
 			.sht = &serverworks_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x00,
 			.port_ops = &serverworks_osb4_port_ops
 		}, { /* CSB5 */
 			.sht = &serverworks_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x1f,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &serverworks_csb_port_ops
 		}, { /* CSB5 - later revisions*/
 			.sht = &serverworks_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = 0x3f,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &serverworks_csb_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 440e2cb..b0cd52d 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -35,6 +35,8 @@
 #define DRV_NAME "pata_sil680"
 #define DRV_VERSION "0.4.6"
 
+#define SIL680_MMIO_BAR		5
+
 /**
  *	sil680_selreg		-	return register base
  *	@hwif: interface
@@ -293,8 +295,8 @@ static u8 sil680_init_chip(struct pci_dev *pdev)
 
 	pci_read_config_byte(pdev, 0x8A, &tmpbyte);
 
-	printk(KERN_INFO "sil680: BA5_EN = %d clock = %02X\n",
-			tmpbyte & 1, tmpbyte & 0x30);
+	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
+		tmpbyte & 1, tmpbyte & 0x30);
 
 	switch(tmpbyte & 0x30) {
 		case 0x00:
@@ -315,8 +317,8 @@ static u8 sil680_init_chip(struct pci_dev *pdev)
 	}
 
 	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
-	printk(KERN_INFO "sil680: BA5_EN = %d clock = %02X\n",
-			tmpbyte & 1, tmpbyte & 0x30);
+	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
+		tmpbyte & 1, tmpbyte & 0x30);
 
 	pci_write_config_byte(pdev,  0xA1, 0x72);
 	pci_write_config_word(pdev,  0xA2, 0x328A);
@@ -339,22 +341,23 @@ static u8 sil680_init_chip(struct pci_dev *pdev)
 	return tmpbyte & 0x30;
 }
 
-static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit sil680_init_one(struct pci_dev *pdev,
+				     const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &sil680_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &sil680_port_ops
 	};
 	static const struct ata_port_info info_slow = {
 		.sht = &sil680_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &sil680_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index cfe4ec6..2b45082 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -732,7 +732,7 @@ static const struct ata_port_operations sis_old_ops = {
 
 static const struct ata_port_info sis_info = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.mwdma_mask	= 0x07,
 	.udma_mask	= 0,
@@ -740,7 +740,7 @@ static const struct ata_port_info sis_info = {
 };
 static const struct ata_port_info sis_info33 = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA2,	/* UDMA 33 */
@@ -748,28 +748,28 @@ static const struct ata_port_info sis_info33 = {
 };
 static const struct ata_port_info sis_info66 = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA4,	/* UDMA 66 */
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info100 = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &sis_100_ops,
 };
 static const struct ata_port_info sis_info100_early = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.udma_mask	= ATA_UDMA5,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
 static const struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
@@ -783,7 +783,7 @@ const struct ata_port_info sis_info133_for_sata = {
 };
 static const struct ata_port_info sis_info133_early = {
 	.sht		= &sis_sht,
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_early_ops,
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index e5aaec4..bde7341 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -303,14 +303,14 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 {
 	static const struct ata_port_info info_dma = {
 		.sht = &sl82c105_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &sl82c105_port_ops
 	};
 	static const struct ata_port_info info_early = {
 		.sht = &sl82c105_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.port_ops = &sl82c105_port_ops
 	};
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index b1d3076..af21f44 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -235,7 +235,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.sht = &triflex_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &triflex_port_ops
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
index f12c2b6..bec1de5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -145,32 +145,32 @@ static struct scsi_host_template adma_ata_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+	.proc_name		= DRV_NAME,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
+	.dma_boundary		= ADMA_DMA_BOUNDARY,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.proc_name		= DRV_NAME,
-	.dma_boundary		= ADMA_DMA_BOUNDARY,
-	.slave_configure	= ata_scsi_slave_config,
-	.slave_destroy		= ata_scsi_slave_destroy,
-	.bios_param		= ata_std_bios_param,
+	.emulated		= ATA_SHT_EMULATED,
 };
 
 static const struct ata_port_operations adma_ata_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
-	.check_status		= ata_check_status,
-	.check_atapi_dma	= adma_check_atapi_dma,
 	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
 	.phy_reset		= adma_phy_reset,
+	.check_atapi_dma	= adma_check_atapi_dma,
+	.data_xfer		= ata_data_xfer,
 	.qc_prep		= adma_qc_prep,
 	.qc_issue		= adma_qc_issue,
 	.eng_timeout		= adma_eng_timeout,
-	.data_xfer		= ata_data_xfer,
 	.irq_clear		= adma_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
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
index dc3bbce..3de1834 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -192,7 +192,7 @@ static void inic_reset_port(void __iomem *port_base)
 
 static u32 inic_scr_read(struct ata_port *ap, unsigned sc_reg)
 {
-	void __iomem *scr_addr = (void __iomem *)ap->ioaddr.scr_addr;
+	void __iomem *scr_addr = ap->ioaddr.scr_addr;
 	void __iomem *addr;
 	u32 val;
 
@@ -210,7 +210,7 @@ static u32 inic_scr_read(struct ata_port *ap, unsigned sc_reg)
 
 static void inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = (void __iomem *)ap->ioaddr.scr_addr;
+	void __iomem *scr_addr = ap->ioaddr.scr_addr;
 	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
@@ -594,7 +594,7 @@ static struct ata_port_info inic_port_info = {
 	.flags			= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 	.pio_mask		= 0x1f,	/* pio0-4 */
 	.mwdma_mask		= 0x07, /* mwdma0-2 */
-	.udma_mask		= 0x7f,	/* udma0-6 */
+	.udma_mask		= ATA_UDMA6,
 	.port_ops		= &inic_port_ops
 };
 
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
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 6dc0b01..2ad5872 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -45,8 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.07"
-
+#define DRV_VERSION	"2.08"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -94,7 +93,7 @@ enum {
 	board_20319		= 2,	/* FastTrak S150 TX4 */
 	board_20619		= 3,	/* FastTrak TX4000 */
 	board_2057x		= 4,	/* SATAII150 Tx2plus */
-	board_2057x_pata	= 5,	/* SATAII150 Tx2plus */
+	board_2057x_pata	= 5,	/* SATAII150 Tx2plus PATA port */
 	board_40518		= 6,	/* SATAII150 Tx4 */
 
 	PDC_HAS_PATA		= (1 << 1), /* PDC20375/20575 has PATA */
@@ -124,7 +123,6 @@ enum {
 	PDC_FLAG_4_PORTS	= (1 << 26), /* 4 ports */
 };
 
-
 struct pdc_port_priv {
 	u8			*pkt;
 	dma_addr_t		pkt_dma;
@@ -252,7 +250,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_SATA_PATA,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -261,7 +259,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -271,7 +269,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
@@ -281,7 +279,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -291,7 +289,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II | PDC_FLAG_SATA_PATA,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
 
@@ -301,7 +299,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_pata_ops,
 	},
 
@@ -311,7 +309,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_sata_ops,
 	},
 };
@@ -340,7 +338,6 @@ static const struct pci_device_id pdc_ata_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
-
 static struct pci_driver pdc_ata_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= pdc_ata_pci_tbl,
@@ -348,7 +345,6 @@ static struct pci_driver pdc_ata_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-
 static int pdc_common_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
@@ -382,7 +378,7 @@ static int pdc_sata_port_start(struct ata_port *ap)
 
 	/* fix up PHYMODE4 align timing */
 	if (ap->flags & PDC_FLAG_GEN_II) {
-		void __iomem *mmio = (void __iomem *) ap->ioaddr.scr_addr;
+		void __iomem *mmio = ap->ioaddr.scr_addr;
 		unsigned int tmp;
 
 		tmp = readl(mmio + 0x014);
@@ -418,7 +414,7 @@ static void pdc_reset_port(struct ata_port *ap)
 static int pdc_pata_cable_detect(struct ata_port *ap)
 {
 	u8 tmp;
-	void __iomem *mmio = (void __iomem *) ap->ioaddr.cmd_addr + PDC_CTLSTAT + 0x03;
+	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT + 0x03;
 
 	tmp = readb(mmio);
 	if (tmp & 0x01)
@@ -438,7 +434,6 @@ static u32 pdc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
 	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
-
 static void pdc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
 			       u32 val)
 {
@@ -573,7 +568,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 
 static void pdc_freeze(struct ata_port *ap)
 {
-	void __iomem *mmio = (void __iomem *) ap->ioaddr.cmd_addr;
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
 	u32 tmp;
 
 	tmp = readl(mmio + PDC_CTLSTAT);
@@ -585,7 +580,7 @@ static void pdc_freeze(struct ata_port *ap)
 
 static void pdc_thaw(struct ata_port *ap)
 {
-	void __iomem *mmio = (void __iomem *) ap->ioaddr.cmd_addr;
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
 	u32 tmp;
 
 	/* clear IRQ */
@@ -657,8 +652,8 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	ata_port_abort(ap);
 }
 
-static inline unsigned int pdc_host_intr( struct ata_port *ap,
-                                          struct ata_queued_cmd *qc)
+static inline unsigned int pdc_host_intr(struct ata_port *ap,
+					 struct ata_queued_cmd *qc)
 {
 	unsigned int handled = 0;
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
@@ -685,10 +680,10 @@ static inline unsigned int pdc_host_intr( struct ata_port *ap,
 		handled = 1;
 		break;
 
-        default:
+	default:
 		ap->stats.idle_irq++;
 		break;
-        }
+	}
 
 	return handled;
 }
@@ -701,6 +696,18 @@ static void pdc_irq_clear(struct ata_port *ap)
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
+static inline int pdc_is_sataii_tx4(unsigned long flags)
+{
+	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
+	return (flags & mask) == mask;
+}
+
+static inline unsigned int pdc_port_no_to_ata_no(unsigned int port_no, int is_sataii_tx4)
+{
+	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
+}
+
 static irqreturn_t pdc_interrupt (int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -807,7 +814,6 @@ static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 	ata_tf_load(ap, tf);
 }
 
-
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
@@ -867,7 +873,6 @@ static void pdc_ata_setup_port(struct ata_port *ap,
 	ap->ioaddr.scr_addr		= scr_addr;
 }
 
-
 static void pdc_host_init(struct ata_host *host)
 {
 	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
@@ -955,10 +960,8 @@ static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 
 	if (pi->flags & PDC_FLAG_SATA_PATA) {
 		u8 tmp = readb(base + PDC_FLASH_CTL+1);
-		if (!(tmp & 0x80)) {
+		if (!(tmp & 0x80))
 			ppi[n_ports++] = pi + 1;
-			dev_printk(KERN_INFO, &pdev->dev, "PATA port found\n");
-		}
 	}
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
@@ -968,22 +971,12 @@ static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
-	is_sataii_tx4 = 0;
-	if ((pi->flags & (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) == (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) {
-		is_sataii_tx4 = 1;
-		dev_printk(KERN_INFO, &pdev->dev, "applying SATAII TX4 port numbering workaround\n");
-	}
+	is_sataii_tx4 = pdc_is_sataii_tx4(pi->flags);
 	for (i = 0; i < host->n_ports; i++) {
-		static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
-		int ata_nr;
-
-		ata_nr = i;
-		if (is_sataii_tx4)
-			ata_nr = sataii_tx4_port_remap[i];
-
+		unsigned int ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
 		pdc_ata_setup_port(host->ports[i],
-				   base + 0x200 + ata_nr * 0x80,
-				   base + 0x400 + ata_nr * 0x100);
+				   base + 0x200 + ata_no * 0x80,
+				   base + 0x400 + ata_no * 0x100);
 	}
 
 	/* initialize adapter */
@@ -1002,19 +995,16 @@ static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 				 &pdc_ata_sht);
 }
 
-
 static int __init pdc_ata_init(void)
 {
 	return pci_register_driver(&pdc_ata_pci_driver);
 }
 
-
 static void __exit pdc_ata_exit(void)
 {
 	pci_unregister_driver(&pdc_ata_pci_driver);
 }
 
-
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Promise ATA TX2/TX4/TX4000 low-level driver");
 MODULE_LICENSE("GPL");
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
index a3b339b..2a86dc4 100644
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
@@ -262,8 +262,9 @@ static const struct {
 	unsigned long sfis_cfg;	/* SATA FIS reception config register */
 } sil_port[] = {
 	/* port 0 ... */
-	{ 0x80, 0x8A, 0x00, 0x10, 0x40, 0x100, 0x148, 0xb4, 0x14c },
-	{ 0xC0, 0xCA, 0x08, 0x18, 0x44, 0x180, 0x1c8, 0xf4, 0x1cc },
+	/*   tf    ctl  bmdma  bmdma2  fifo    scr   sien   mode   sfis */
+	{  0x80,  0x8A,   0x0,  0x10,  0x40, 0x100, 0x148,  0xb4, 0x14c },
+	{  0xC0,  0xCA,   0x8,  0x18,  0x44, 0x180, 0x1c8,  0xf4, 0x1cc },
 	{ 0x280, 0x28A, 0x200, 0x210, 0x240, 0x300, 0x348, 0x2b4, 0x34c },
 	{ 0x2C0, 0x2CA, 0x208, 0x218, 0x244, 0x380, 0x3c8, 0x2f4, 0x3cc },
 	/* ... port 3 */
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 0ddfae9..ac43a30 100644
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
@@ -888,7 +888,7 @@ static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
 		if (status & (1 << i)) {
 			struct ata_port *ap = host->ports[i];
 			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				sil24_host_intr(host->ports[i]);
+				sil24_host_intr(ap);
 				handled++;
 			} else
 				printk(KERN_ERR DRV_NAME
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
index bcb2cd8..63fe99a 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -107,7 +107,7 @@ static u32 k2_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
 {
 	if (sc_reg > SCR_CONTROL)
 		return 0xffffffffU;
-	return readl((void __iomem *) ap->ioaddr.scr_addr + (sc_reg * 4));
+	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
 
@@ -116,7 +116,7 @@ static void k2_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
 {
 	if (sc_reg > SCR_CONTROL)
 		return;
-	writel(val, (void __iomem *) ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
 
@@ -197,7 +197,8 @@ static void k2_bmdma_setup_mmio (struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
 	u8 dmactl;
-	void __iomem *mmio = (void __iomem *) ap->ioaddr.bmdma_addr;
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
 	writel(ap->prd_dma, mmio + ATA_DMA_TABLE_OFS);
@@ -225,7 +226,7 @@ static void k2_bmdma_setup_mmio (struct ata_queued_cmd *qc)
 static void k2_bmdma_start_mmio (struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	void __iomem *mmio = (void __iomem *) ap->ioaddr.bmdma_addr;
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 	u8 dmactl;
 
 	/* start host DMA transaction */
@@ -253,7 +254,7 @@ static void k2_bmdma_start_mmio (struct ata_queued_cmd *qc)
 
 static u8 k2_stat_check_status(struct ata_port *ap)
 {
-       	return readl((void __iomem *) ap->ioaddr.status_addr);
+       	return readl(ap->ioaddr.status_addr);
 }
 
 #ifdef CONFIG_PPC_OF
@@ -360,7 +361,7 @@ static const struct ata_port_info k2_port_info[] = {
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask	= 0x7f,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
 	/* board_svw8 */
@@ -370,7 +371,7 @@ static const struct ata_port_info k2_port_info[] = {
 				  K2_FLAG_SATA_8_PORTS,
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,
-		.udma_mask	= 0x7f,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
 };
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 2d14f3d..5193bd8 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -30,6 +30,54 @@
  *
  */
 
+/*
+	Theory of operation
+	-------------------
+
+	The SX4 (PDC20621) chip features a single Host DMA (HDMA) copy
+	engine, DIMM memory, and four ATA engines (one per SATA port).
+	Data is copied to/from DIMM memory by the HDMA engine, before
+	handing off to one (or more) of the ATA engines.  The ATA
+	engines operate solely on DIMM memory.
+
+	The SX4 behaves like a PATA chip, with no SATA controls or
+	knowledge whatsoever, leading to the presumption that
+	PATA<->SATA bridges exist on SX4 boards, external to the
+	PDC20621 chip itself.
+
+	The chip is quite capable, supporting an XOR engine and linked
+	hardware commands (permits a string to transactions to be
+	submitted and waited-on as a single unit), and an optional
+	microprocessor.
+
+	The limiting factor is largely software.  This Linux driver was
+	written to multiplex the single HDMA engine to copy disk
+	transactions into a fixed DIMM memory space, from where an ATA
+	engine takes over.  As a result, each WRITE looks like this:
+
+		submit HDMA packet to hardware
+		hardware copies data from system memory to DIMM
+		hardware raises interrupt
+
+		submit ATA packet to hardware
+		hardware executes ATA WRITE command, w/ data in DIMM
+		hardware raises interrupt
+	
+	and each READ looks like this:
+
+		submit ATA packet to hardware
+		hardware executes ATA READ command, w/ data in DIMM
+		hardware raises interrupt
+	
+		submit HDMA packet to hardware
+		hardware copies data from DIMM to system memory
+		hardware raises interrupt
+
+	This is a very slow, lock-step way of doing things that can
+	certainly be improved by motivated kernel hackers.
+
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -58,6 +106,8 @@ enum {
 	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
 	PDC_HDMA_CTLSTAT	= 0x12C, /* Host DMA control / status */
 
+	PDC_CTLSTAT		= 0x60,	/* IDEn control / status */
+
 	PDC_20621_SEQCTL	= 0x400,
 	PDC_20621_SEQMASK	= 0x480,
 	PDC_20621_GENERAL_CTL	= 0x484,
@@ -87,48 +137,60 @@ enum {
 
 	board_20621		= 0,	/* FastTrak S150 SX4 */
 
-	PDC_RESET		= (1 << 11), /* HDMA reset */
+	PDC_MASK_INT		= (1 << 10), /* HDMA/ATA mask int */
+	PDC_RESET		= (1 << 11), /* HDMA/ATA reset */
+	PDC_DMA_ENABLE		= (1 << 7),  /* DMA start/stop */
 
 	PDC_MAX_HDMA		= 32,
 	PDC_HDMA_Q_MASK		= (PDC_MAX_HDMA - 1),
 
-	PDC_DIMM0_SPD_DEV_ADDRESS     = 0x50,
-	PDC_DIMM1_SPD_DEV_ADDRESS     = 0x51,
-	PDC_MAX_DIMM_MODULE           = 0x02,
-	PDC_I2C_CONTROL_OFFSET        = 0x48,
-	PDC_I2C_ADDR_DATA_OFFSET      = 0x4C,
-	PDC_DIMM0_CONTROL_OFFSET      = 0x80,
-	PDC_DIMM1_CONTROL_OFFSET      = 0x84,
-	PDC_SDRAM_CONTROL_OFFSET      = 0x88,
-	PDC_I2C_WRITE                 = 0x00000000,
-	PDC_I2C_READ                  = 0x00000040,
-	PDC_I2C_START                 = 0x00000080,
-	PDC_I2C_MASK_INT              = 0x00000020,
-	PDC_I2C_COMPLETE              = 0x00010000,
-	PDC_I2C_NO_ACK                = 0x00100000,
-	PDC_DIMM_SPD_SUBADDRESS_START = 0x00,
-	PDC_DIMM_SPD_SUBADDRESS_END   = 0x7F,
-	PDC_DIMM_SPD_ROW_NUM          = 3,
-	PDC_DIMM_SPD_COLUMN_NUM       = 4,
-	PDC_DIMM_SPD_MODULE_ROW       = 5,
-	PDC_DIMM_SPD_TYPE             = 11,
-	PDC_DIMM_SPD_FRESH_RATE       = 12,
-	PDC_DIMM_SPD_BANK_NUM         = 17,
-	PDC_DIMM_SPD_CAS_LATENCY      = 18,
-	PDC_DIMM_SPD_ATTRIBUTE        = 21,
-	PDC_DIMM_SPD_ROW_PRE_CHARGE   = 27,
-	PDC_DIMM_SPD_ROW_ACTIVE_DELAY = 28,
-	PDC_DIMM_SPD_RAS_CAS_DELAY    = 29,
-	PDC_DIMM_SPD_ACTIVE_PRECHARGE = 30,
-	PDC_DIMM_SPD_SYSTEM_FREQ      = 126,
-	PDC_CTL_STATUS		      = 0x08,
-	PDC_DIMM_WINDOW_CTLR	      = 0x0C,
-	PDC_TIME_CONTROL              = 0x3C,
-	PDC_TIME_PERIOD               = 0x40,
-	PDC_TIME_COUNTER              = 0x44,
-	PDC_GENERAL_CTLR	      = 0x484,
-	PCI_PLL_INIT                  = 0x8A531824,
-	PCI_X_TCOUNT                  = 0xEE1E5CFF
+	PDC_DIMM0_SPD_DEV_ADDRESS	= 0x50,
+	PDC_DIMM1_SPD_DEV_ADDRESS	= 0x51,
+	PDC_I2C_CONTROL			= 0x48,
+	PDC_I2C_ADDR_DATA		= 0x4C,
+	PDC_DIMM0_CONTROL		= 0x80,
+	PDC_DIMM1_CONTROL		= 0x84,
+	PDC_SDRAM_CONTROL		= 0x88,
+	PDC_I2C_WRITE			= 0,		/* master -> slave */
+	PDC_I2C_READ			= (1 << 6),	/* master <- slave */
+	PDC_I2C_START			= (1 << 7),	/* start I2C proto */
+	PDC_I2C_MASK_INT		= (1 << 5),	/* mask I2C interrupt */
+	PDC_I2C_COMPLETE		= (1 << 16),	/* I2C normal compl. */
+	PDC_I2C_NO_ACK			= (1 << 20),	/* slave no-ack addr */
+	PDC_DIMM_SPD_SUBADDRESS_START	= 0x00,
+	PDC_DIMM_SPD_SUBADDRESS_END	= 0x7F,
+	PDC_DIMM_SPD_ROW_NUM		= 3,
+	PDC_DIMM_SPD_COLUMN_NUM		= 4,
+	PDC_DIMM_SPD_MODULE_ROW		= 5,
+	PDC_DIMM_SPD_TYPE		= 11,
+	PDC_DIMM_SPD_FRESH_RATE		= 12,
+	PDC_DIMM_SPD_BANK_NUM		= 17,
+	PDC_DIMM_SPD_CAS_LATENCY	= 18,
+	PDC_DIMM_SPD_ATTRIBUTE		= 21,
+	PDC_DIMM_SPD_ROW_PRE_CHARGE	= 27,
+	PDC_DIMM_SPD_ROW_ACTIVE_DELAY	= 28,
+	PDC_DIMM_SPD_RAS_CAS_DELAY	= 29,
+	PDC_DIMM_SPD_ACTIVE_PRECHARGE	= 30,
+	PDC_DIMM_SPD_SYSTEM_FREQ	= 126,
+	PDC_CTL_STATUS			= 0x08,
+	PDC_DIMM_WINDOW_CTLR		= 0x0C,
+	PDC_TIME_CONTROL		= 0x3C,
+	PDC_TIME_PERIOD			= 0x40,
+	PDC_TIME_COUNTER		= 0x44,
+	PDC_GENERAL_CTLR		= 0x484,
+	PCI_PLL_INIT			= 0x8A531824,
+	PCI_X_TCOUNT			= 0xEE1E5CFF,
+
+	/* PDC_TIME_CONTROL bits */
+	PDC_TIMER_BUZZER		= (1 << 10),
+	PDC_TIMER_MODE_PERIODIC		= 0,		/* bits 9:8 == 00 */
+	PDC_TIMER_MODE_ONCE		= (1 << 8),	/* bits 9:8 == 01 */
+	PDC_TIMER_ENABLE		= (1 << 7),
+	PDC_TIMER_MASK_INT		= (1 << 5),
+	PDC_TIMER_SEQ_MASK		= 0x1f,		/* SEQ ID for timer */
+	PDC_TIMER_DEFAULT		= PDC_TIMER_MODE_ONCE |
+					  PDC_TIMER_ENABLE |
+					  PDC_TIMER_MASK_INT,
 };
 
 
@@ -217,7 +279,7 @@ static const struct ata_port_info pdc_port_info[] = {
 				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
-		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &pdc_20621_ops,
 	},
 
@@ -999,17 +1061,17 @@ static unsigned int pdc20621_i2c_read(struct ata_host *host, u32 device,
 	i2creg |= subaddr << 16;
 
 	/* Set the device and subaddress */
-	writel(i2creg, mmio + PDC_I2C_ADDR_DATA_OFFSET);
-	readl(mmio + PDC_I2C_ADDR_DATA_OFFSET);
+	writel(i2creg, mmio + PDC_I2C_ADDR_DATA);
+	readl(mmio + PDC_I2C_ADDR_DATA);
 
 	/* Write Control to perform read operation, mask int */
 	writel(PDC_I2C_READ | PDC_I2C_START | PDC_I2C_MASK_INT,
-	       mmio + PDC_I2C_CONTROL_OFFSET);
+	       mmio + PDC_I2C_CONTROL);
 
 	for (count = 0; count <= 1000; count ++) {
-		status = readl(mmio + PDC_I2C_CONTROL_OFFSET);
+		status = readl(mmio + PDC_I2C_CONTROL);
 		if (status & PDC_I2C_COMPLETE) {
-			status = readl(mmio + PDC_I2C_ADDR_DATA_OFFSET);
+			status = readl(mmio + PDC_I2C_ADDR_DATA);
 			break;
 		} else if (count == 1000)
 			return 0;
@@ -1099,8 +1161,8 @@ static int pdc20621_prog_dimm0(struct ata_host *host)
    	data |= (((size / 16) - 1) << 16);
    	data |= (0 << 23);
 	data |= 8;
-   	writel(data, mmio + PDC_DIMM0_CONTROL_OFFSET);
-	readl(mmio + PDC_DIMM0_CONTROL_OFFSET);
+   	writel(data, mmio + PDC_DIMM0_CONTROL);
+	readl(mmio + PDC_DIMM0_CONTROL);
    	return size;
 }
 
@@ -1122,27 +1184,27 @@ static unsigned int pdc20621_prog_dimm_global(struct ata_host *host)
 	*/
 
 	data = 0x022259F1;
-	writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
-	readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+	writel(data, mmio + PDC_SDRAM_CONTROL);
+	readl(mmio + PDC_SDRAM_CONTROL);
 
 	/* Turn on for ECC */
 	pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS,
 			  PDC_DIMM_SPD_TYPE, &spd0);
 	if (spd0 == 0x02) {
 		data |= (0x01 << 16);
-		writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
-		readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+		writel(data, mmio + PDC_SDRAM_CONTROL);
+		readl(mmio + PDC_SDRAM_CONTROL);
 		printk(KERN_ERR "Local DIMM ECC Enabled\n");
    	}
 
    	/* DIMM Initialization Select/Enable (bit 18/19) */
    	data &= (~(1<<18));
    	data |= (1<<19);
-   	writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
+   	writel(data, mmio + PDC_SDRAM_CONTROL);
 
    	error = 1;
    	for (i = 1; i <= 10; i++) {   /* polling ~5 secs */
-		data = readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+		data = readl(mmio + PDC_SDRAM_CONTROL);
 		if (!(data & (1<<19))) {
 	   		error = 0;
 	   		break;
@@ -1176,7 +1238,7 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	VPRINTK("Time Period Register (0x40): 0x%x\n", time_period);
 
 	/* Enable timer */
-	writel(0x00001a0, mmio + PDC_TIME_CONTROL);
+	writel(PDC_TIMER_DEFAULT, mmio + PDC_TIME_CONTROL);
 	readl(mmio + PDC_TIME_CONTROL);
 
 	/* Wait 3 seconds */
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
index e8b90e7..a4c0832 100644
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
 
@@ -303,9 +303,7 @@ static int vt6420_prereset(struct ata_port *ap, unsigned long deadline)
 	if (!(ap->pflags & ATA_PFLAG_LOADING))
 		goto skip_scr;
 
-	/* Resume phy.  This is the old resume sequence from
-	 * __sata_phy_reset().
-	 */
+	/* Resume phy.  This is the old SATA resume sequence */
 	svia_scr_write(ap, SCR_CONTROL, 0x300);
 	svia_scr_read(ap, SCR_CONTROL); /* flush */
 
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
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 703febb..407dc7e 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -126,6 +126,7 @@ enum {
 	ATA_REG_IRQ		= ATA_REG_NSECT,
 
 	/* ATA device commands */
+	ATA_CMD_DEV_RESET	= 0x08, /* ATAPI device reset */
 	ATA_CMD_CHK_POWER	= 0xE5, /* check power mode */
 	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
 	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 620da7b..a3df646 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -116,6 +116,7 @@ static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
+	LIBATA_DUMB_MAX_PRD	= ATA_MAX_PRD / 4,	/* Worst case */
 	ATA_MAX_PORTS		= 8,
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
@@ -136,6 +137,8 @@ enum {
 	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
 	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
+	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
+	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
@@ -196,6 +199,7 @@ enum {
 	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
+	ATA_PFLAG_GTM_VALID	= (1 << 19), /* acpi_gtm data valid */
 
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
@@ -363,6 +367,9 @@ struct ata_host {
 	void			*private_data;
 	const struct ata_port_operations *ops;
 	unsigned long		flags;
+#ifdef CONFIG_ATA_ACPI
+	acpi_handle		acpi_handle;
+#endif
 	struct ata_port		*simplex_claimed;	/* channel owning the DMA */
 	struct ata_port		*ports[0];
 };
@@ -429,6 +436,9 @@ struct ata_device {
 	unsigned int		devno;		/* 0 or 1 */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
+#ifdef CONFIG_ATA_ACPI
+	acpi_handle		acpi_handle;
+#endif
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
@@ -457,10 +467,6 @@ struct ata_device {
 	struct ata_ering	ering;
 	int			spdn_cnt;
 	unsigned int		horkage;	/* List of broken features */
-#ifdef CONFIG_ATA_ACPI
-	/* ACPI objects info */
-	acpi_handle obj_handle;
-#endif
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained
@@ -489,6 +495,17 @@ struct ata_eh_context {
 	unsigned int		did_probe_mask;
 };
 
+struct ata_acpi_drive
+{
+	u32 pio;
+	u32 dma;
+} __packed;
+
+struct ata_acpi_gtm {
+	struct ata_acpi_drive drive[2];
+	u32 flags;
+} __packed;
+
 struct ata_port {
 	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
 	const struct ata_port_operations *ops;
@@ -549,6 +566,10 @@ struct ata_port {
 
 	void			*private_data;
 
+#ifdef CONFIG_ATA_ACPI
+	acpi_handle		acpi_handle;
+	struct ata_acpi_gtm	acpi_gtm;
+#endif
 	u8			sector_buf[ATA_SECT_SIZE]; /* owned by EH */
 };
 
@@ -758,6 +779,7 @@ extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
 			  unsigned int buflen, int write_data);
 extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
 				unsigned int buflen, int write_data);
+extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
diff --git a/include/linux/pata_platform.h b/include/linux/pata_platform.h
index 2d5fd64..5799e8d 100644
--- a/include/linux/pata_platform.h
+++ b/include/linux/pata_platform.h
@@ -8,6 +8,11 @@ struct pata_platform_info {
 	 * spacing used by ata_std_ports().
 	 */
 	unsigned int ioport_shift;
+	/* 
+	 * Indicate platform specific irq types and initial
+	 * IRQ flags when call request_irq()
+	 */
+	unsigned int irq_flags;
 };
 
 #endif /* __LINUX_PATA_PLATFORM_H */
