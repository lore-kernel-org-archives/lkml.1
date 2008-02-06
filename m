Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbYBFMPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbYBFMPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762174AbYBFMOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:14:50 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35320 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762161AbYBFMOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:14:46 -0500
Date: Wed, 6 Feb 2008 07:14:16 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080206121416.GA7068@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 arch/arm/mach-rpc/riscpc.c                        |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf533/boards/H8606.c           |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf537/boards/minotaur.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |    2 +-
 arch/sh/boards/landisk/setup.c                    |    2 +-
 arch/sh/boards/lboxre2/setup.c                    |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c            |    2 +-
 arch/sh/boards/renesas/rts7751r2d/setup.c         |    2 +-
 arch/sh/boards/renesas/sdk7780/setup.c            |    2 +-
 arch/sh/boards/se/7722/setup.c                    |    2 +-
 drivers/ata/ahci.c                                |   35 +-
 drivers/ata/ata_piix.c                            |    3 +-
 drivers/ata/libata-core.c                         |    2 -
 drivers/ata/pata_of_platform.c                    |    2 +-
 drivers/ata/pata_platform.c                       |    2 +-
 drivers/ata/sata_fsl.c                            |    4 +-
 drivers/ata/sata_mv.c                             |  366 ++++++++++++++++++---
 drivers/ata/sata_nv.c                             |   78 ++++-
 drivers/ata/sata_via.c                            |    2 -
 drivers/ide/legacy/ide_platform.c                 |    2 +-
 include/linux/{pata_platform.h => ata_platform.h} |   13 +-
 include/linux/libata.h                            |    2 -
 30 files changed, 440 insertions(+), 107 deletions(-)
 rename include/linux/{pata_platform.h => ata_platform.h} (75%)

Adrian Bunk (1):
      ata_piix.c:piix_init_one() must be __devinit

Alejandro Riveira Fernández (1):
      sata_via.c: Remove missleading comment.

Andrew Morton (1):
      ata: drivers/ata/sata_mv.c needs dmapool.h

David Milburn (1):
      libata-core: unblacklist HITACHI drives

James Bottomley (1):
      libata: kill now unused n_iter and fix sata_fsl

Jeff Garzik (1):
      Rename: linux/pata_platform.h to linux/ata_platform.h

Robert Hancock (1):
      sata_nv: fix ATAPI issues with memory over 4GB (v7)

Saeed Bishara (1):
      sata_mv: Support SoC controllers

Tejun Heo (1):
      ahci: fix CAP.NP and PI handling

diff --git a/arch/arm/mach-rpc/riscpc.c b/arch/arm/mach-rpc/riscpc.c
index a454451..eca558c 100644
--- a/arch/arm/mach-rpc/riscpc.c
+++ b/arch/arm/mach-rpc/riscpc.c
@@ -17,7 +17,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/serial_8250.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 
 #include <asm/elf.h>
 #include <asm/io.h>
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index f8c411a..1795aab 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -37,7 +37,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb/sl811.h>
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index a72c7a6..97378b0 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -38,7 +38,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 
 #include <asm/dma.h>
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 21df2f3..886f260 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -34,7 +34,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/usb/isp1362.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index c37dd45..4026c2f 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -35,7 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/usb/isp1362.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index ac52b04..0185350 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -38,7 +38,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 8703b67..f7c1f96 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -36,7 +36,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/usb/isp1362.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 3e52f3f..8a3397d 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -38,7 +38,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb/sl811.h>
diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c b/arch/blackfin/mach-bf537/boards/minotaur.c
index b8bbba8..d71e0be 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -10,7 +10,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb_isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb_sl811.h>
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 7725415..119e6ea 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -38,7 +38,7 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb/sl811.h>
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 3a79a90..bf9e738 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -34,7 +34,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/usb/isp1362.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 7601c3b..ed863ce 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -35,7 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
diff --git a/arch/sh/boards/landisk/setup.c b/arch/sh/boards/landisk/setup.c
index eda7176..2b708ec 100644
--- a/arch/sh/boards/landisk/setup.c
+++ b/arch/sh/boards/landisk/setup.c
@@ -14,7 +14,7 @@
  */
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/pm.h>
 #include <linux/mm.h>
 #include <asm/machvec.h>
diff --git a/arch/sh/boards/lboxre2/setup.c b/arch/sh/boards/lboxre2/setup.c
index 9c830fd..c74440d 100644
--- a/arch/sh/boards/lboxre2/setup.c
+++ b/arch/sh/boards/lboxre2/setup.c
@@ -13,7 +13,7 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <asm/machvec.h>
 #include <asm/addrspace.h>
 #include <asm/lboxre2.h>
diff --git a/arch/sh/boards/renesas/r7780rp/setup.c b/arch/sh/boards/renesas/r7780rp/setup.c
index a43b477..f7a8d5c 100644
--- a/arch/sh/boards/renesas/r7780rp/setup.c
+++ b/arch/sh/boards/renesas/r7780rp/setup.c
@@ -15,7 +15,7 @@
  */
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/types.h>
 #include <net/ax88796.h>
 #include <asm/machvec.h>
diff --git a/arch/sh/boards/renesas/rts7751r2d/setup.c b/arch/sh/boards/renesas/rts7751r2d/setup.c
index 3452b07..a0ef81b 100644
--- a/arch/sh/boards/renesas/rts7751r2d/setup.c
+++ b/arch/sh/boards/renesas/rts7751r2d/setup.c
@@ -10,7 +10,7 @@
  */
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/serial_8250.h>
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
diff --git a/arch/sh/boards/renesas/sdk7780/setup.c b/arch/sh/boards/renesas/sdk7780/setup.c
index 5df32f2..acc5932 100644
--- a/arch/sh/boards/renesas/sdk7780/setup.c
+++ b/arch/sh/boards/renesas/sdk7780/setup.c
@@ -11,7 +11,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <asm/machvec.h>
 #include <asm/sdk7780.h>
 #include <asm/heartbeat.h>
diff --git a/arch/sh/boards/se/7722/setup.c b/arch/sh/boards/se/7722/setup.c
index eb97dca..b1a3d9d 100644
--- a/arch/sh/boards/se/7722/setup.c
+++ b/arch/sh/boards/se/7722/setup.c
@@ -12,7 +12,7 @@
  */
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <asm/machvec.h>
 #include <asm/se7722.h>
 #include <asm/io.h>
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 27c8d56..29e71bd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -679,24 +679,20 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 
 	/* cross check port_map and cap.n_ports */
 	if (port_map) {
-		u32 tmp_port_map = port_map;
-		int n_ports = ahci_nr_ports(cap);
+		int map_ports = 0;
 
-		for (i = 0; i < AHCI_MAX_PORTS && n_ports; i++) {
-			if (tmp_port_map & (1 << i)) {
-				n_ports--;
-				tmp_port_map &= ~(1 << i);
-			}
-		}
+		for (i = 0; i < AHCI_MAX_PORTS; i++)
+			if (port_map & (1 << i))
+				map_ports++;
 
-		/* If n_ports and port_map are inconsistent, whine and
-		 * clear port_map and let it be generated from n_ports.
+		/* If PI has more ports than n_ports, whine, clear
+		 * port_map and let it be generated from n_ports.
 		 */
-		if (n_ports || tmp_port_map) {
+		if (map_ports > ahci_nr_ports(cap)) {
 			dev_printk(KERN_WARNING, &pdev->dev,
-				   "nr_ports (%u) and implemented port map "
-				   "(0x%x) don't match, using nr_ports\n",
-				   ahci_nr_ports(cap), port_map);
+				   "implemented port map (0x%x) contains more "
+				   "ports than nr_ports (%u), using nr_ports\n",
+				   port_map, ahci_nr_ports(cap));
 			port_map = 0;
 		}
 	}
@@ -2201,7 +2197,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int i, rc;
+	int n_ports, i, rc;
 
 	VPRINTK("ENTER\n");
 
@@ -2255,7 +2251,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	host = ata_host_alloc_pinfo(&pdev->dev, ppi, fls(hpriv->port_map));
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
 	host->iomap = pcim_iomap_table(pdev);
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 4b99ed0..9c2515f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1603,7 +1603,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
  *	Zero on success, or -ERRNO value.
  */
 
-static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit piix_init_one(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 361cf50..3011919 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4154,8 +4154,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* NCQ is broken */
 	{ "Maxtor *",		"BANC*",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
-	{ "HITACHI HDS7250SASUN500G*", NULL,    ATA_HORKAGE_NONCQ },
-	{ "HITACHI HDS7225SBSUN250G*", NULL,    ATA_HORKAGE_NONCQ },
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 938f48a..408da30 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 
 static int __devinit pata_of_platform_probe(struct of_device *ofdev,
 					    const struct of_device_id *match)
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 224bb6c..aad7adc 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -19,7 +19,7 @@
 #include <linux/ata.h>
 #include <linux/libata.h>
 #include <linux/platform_device.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 
 #define DRV_NAME "pata_platform"
 #define DRV_VERSION "1.2"
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 922d7b2..efcb66b 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -355,8 +355,8 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g len unaligned : 0x%x\n", sg_len);
 
-		if ((num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1)) &&
-		    (qc->n_iter + 1 != qc->n_elem)) {
+		if (num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1) &&
+		    sg_next(sg) != NULL) {
 			VPRINTK("setting indirect prde\n");
 			prd_ptr_to_indirect_ext = prd;
 			prd->dba = cpu_to_le32(indirect_ext_segment_paddr);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 3c1b5c9..080b836 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -69,8 +69,11 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/ata_platform.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -179,6 +182,8 @@ enum {
 
 	HC_MAIN_IRQ_CAUSE_OFS	= 0x1d60,
 	HC_MAIN_IRQ_MASK_OFS	= 0x1d64,
+	HC_SOC_MAIN_IRQ_CAUSE_OFS = 0x20020,
+	HC_SOC_MAIN_IRQ_MASK_OFS = 0x20024,
 	PORT0_ERR		= (1 << 0),	/* shift by port # */
 	PORT0_DONE		= (1 << 1),	/* shift by port # */
 	HC0_IRQ_PEND		= 0x1ff,	/* bits 0-8 = HC0's ports */
@@ -194,11 +199,13 @@ enum {
 	TWSI_INT		= (1 << 24),
 	HC_MAIN_RSVD		= (0x7f << 25),	/* bits 31-25 */
 	HC_MAIN_RSVD_5		= (0x1fff << 19), /* bits 31-19 */
+	HC_MAIN_RSVD_SOC 	= (0x3fffffb << 6),     /* bits 31-9, 7-6 */
 	HC_MAIN_MASKED_IRQS	= (TRAN_LO_DONE | TRAN_HI_DONE |
 				   PORTS_0_7_COAL_DONE | GPIO_INT | TWSI_INT |
 				   HC_MAIN_RSVD),
 	HC_MAIN_MASKED_IRQS_5	= (PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
 				   HC_MAIN_RSVD_5),
+	HC_MAIN_MASKED_IRQS_SOC = (PORTS_0_3_COAL_DONE | HC_MAIN_RSVD_SOC),
 
 	/* SATAHC registers */
 	HC_CFG_OFS		= 0,
@@ -368,6 +375,7 @@ enum chip_type {
 	chip_608x,
 	chip_6042,
 	chip_7042,
+	chip_soc,
 };
 
 /* Command ReQuest Block: 32B */
@@ -424,6 +432,10 @@ struct mv_host_priv {
 	u32			hp_flags;
 	struct mv_port_signal	signal[8];
 	const struct mv_hw_ops	*ops;
+	int			n_ports;
+	void __iomem		*base;
+	void __iomem		*main_cause_reg_addr;
+	void __iomem		*main_mask_reg_addr;
 	u32			irq_cause_ofs;
 	u32			irq_mask_ofs;
 	u32			unmask_all_irqs;
@@ -482,6 +494,15 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 static int mv6_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 			unsigned int n_hc);
 static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
+static void mv_soc_enable_leds(struct mv_host_priv *hpriv,
+				      void __iomem *mmio);
+static void mv_soc_read_preamp(struct mv_host_priv *hpriv, int idx,
+				      void __iomem *mmio);
+static int mv_soc_reset_hc(struct mv_host_priv *hpriv,
+				  void __iomem *mmio, unsigned int n_hc);
+static void mv_soc_reset_flash(struct mv_host_priv *hpriv,
+				      void __iomem *mmio);
+static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio);
 static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
@@ -661,6 +682,12 @@ static const struct ata_port_info mv_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
+	{  /* chip_soc */
+		.flags = MV_COMMON_FLAGS | MV_FLAG_SOC,
+		.pio_mask = 0x1f,      /* pio0-4 */
+		.udma_mask = ATA_UDMA6,
+		.port_ops = &mv_iie_ops,
+	},
 };
 
 static const struct pci_device_id mv_pci_tbl[] = {
@@ -711,6 +738,15 @@ static const struct mv_hw_ops mv6xxx_ops = {
 	.reset_bus		= mv_reset_pci_bus,
 };
 
+static const struct mv_hw_ops mv_soc_ops = {
+	.phy_errata		= mv6_phy_errata,
+	.enable_leds		= mv_soc_enable_leds,
+	.read_preamp		= mv_soc_read_preamp,
+	.reset_hc		= mv_soc_reset_hc,
+	.reset_flash		= mv_soc_reset_flash,
+	.reset_bus		= mv_soc_reset_bus,
+};
+
 /*
  * Functions
  */
@@ -749,9 +785,15 @@ static inline void __iomem *mv_port_base(void __iomem *base, unsigned int port)
 		(mv_hardport_from_port(port) * MV_PORT_REG_SZ);
 }
 
+static inline void __iomem *mv_host_base(struct ata_host *host)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	return hpriv->base;
+}
+
 static inline void __iomem *mv_ap_base(struct ata_port *ap)
 {
-	return mv_port_base(ap->host->iomap[MV_PRIMARY_BAR], ap->port_no);
+	return mv_port_base(mv_host_base(ap->host), ap->port_no);
 }
 
 static inline int mv_get_hc_count(unsigned long port_flags)
@@ -1649,16 +1691,21 @@ static void mv_intr_edma(struct ata_port *ap)
  */
 static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 {
-	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->base;
 	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
 	u32 hc_irq_cause;
-	int port, port0;
+	int port, port0, last_port;
 
 	if (hc == 0)
 		port0 = 0;
 	else
 		port0 = MV_PORTS_PER_HC;
 
+	if (HAS_PCI(host))
+		last_port = port0 + MV_PORTS_PER_HC;
+	else
+		last_port = port0 + hpriv->n_ports;
 	/* we'll need the HC success int register in most cases */
 	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
 	if (!hc_irq_cause)
@@ -1669,7 +1716,7 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc, relevant, hc_irq_cause);
 
-	for (port = port0; port < port0 + MV_PORTS_PER_HC; port++) {
+	for (port = port0; port < port0 + last_port; port++) {
 		struct ata_port *ap = host->ports[port];
 		struct mv_port_priv *pp = ap->private_data;
 		int have_err_bits, hard_port, shift;
@@ -1764,13 +1811,15 @@ static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
 static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
+	struct mv_host_priv *hpriv = host->private_data;
 	unsigned int hc, handled = 0, n_hcs;
-	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
+	void __iomem *mmio = hpriv->base;
 	u32 irq_stat, irq_mask;
 
 	spin_lock(&host->lock);
-	irq_stat = readl(mmio + HC_MAIN_IRQ_CAUSE_OFS);
-	irq_mask = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+
+	irq_stat = readl(hpriv->main_cause_reg_addr);
+	irq_mask = readl(hpriv->main_mask_reg_addr);
 
 	/* check the cases where we either have nothing pending or have read
 	 * a bogus register value which can indicate HW removal or PCI fault
@@ -1827,7 +1876,8 @@ static unsigned int mv5_scr_offset(unsigned int sc_reg_in)
 
 static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 {
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->base;
 	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
@@ -1840,7 +1890,8 @@ static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 
 static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 {
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->base;
 	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
@@ -2178,6 +2229,93 @@ static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 	writel(m2, port_mmio + PHY_MODE2);
 }
 
+/* TODO: use the generic LED interface to configure the SATA Presence */
+/* & Acitivy LEDs on the board */
+static void mv_soc_enable_leds(struct mv_host_priv *hpriv,
+				      void __iomem *mmio)
+{
+	return;
+}
+
+static void mv_soc_read_preamp(struct mv_host_priv *hpriv, int idx,
+			   void __iomem *mmio)
+{
+	void __iomem *port_mmio;
+	u32 tmp;
+
+	port_mmio = mv_port_base(mmio, idx);
+	tmp = readl(port_mmio + PHY_MODE2);
+
+	hpriv->signal[idx].amps = tmp & 0x700;	/* bits 10:8 */
+	hpriv->signal[idx].pre = tmp & 0xe0;	/* bits 7:5 */
+}
+
+#undef ZERO
+#define ZERO(reg) writel(0, port_mmio + (reg))
+static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
+					void __iomem *mmio, unsigned int port)
+{
+	void __iomem *port_mmio = mv_port_base(mmio, port);
+
+	writelfl(EDMA_DS, port_mmio + EDMA_CMD_OFS);
+
+	mv_channel_reset(hpriv, mmio, port);
+
+	ZERO(0x028);		/* command */
+	writel(0x101f, port_mmio + EDMA_CFG_OFS);
+	ZERO(0x004);		/* timer */
+	ZERO(0x008);		/* irq err cause */
+	ZERO(0x00c);		/* irq err mask */
+	ZERO(0x010);		/* rq bah */
+	ZERO(0x014);		/* rq inp */
+	ZERO(0x018);		/* rq outp */
+	ZERO(0x01c);		/* respq bah */
+	ZERO(0x024);		/* respq outp */
+	ZERO(0x020);		/* respq inp */
+	ZERO(0x02c);		/* test control */
+	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
+}
+
+#undef ZERO
+
+#define ZERO(reg) writel(0, hc_mmio + (reg))
+static void mv_soc_reset_one_hc(struct mv_host_priv *hpriv,
+				       void __iomem *mmio)
+{
+	void __iomem *hc_mmio = mv_hc_base(mmio, 0);
+
+	ZERO(0x00c);
+	ZERO(0x010);
+	ZERO(0x014);
+
+}
+
+#undef ZERO
+
+static int mv_soc_reset_hc(struct mv_host_priv *hpriv,
+				  void __iomem *mmio, unsigned int n_hc)
+{
+	unsigned int port;
+
+	for (port = 0; port < hpriv->n_ports; port++)
+		mv_soc_reset_hc_port(hpriv, mmio, port);
+
+	mv_soc_reset_one_hc(hpriv, mmio);
+
+	return 0;
+}
+
+static void mv_soc_reset_flash(struct mv_host_priv *hpriv,
+				      void __iomem *mmio)
+{
+	return;
+}
+
+static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio)
+{
+	return;
+}
+
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no)
 {
@@ -2342,7 +2480,7 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 {
 	struct ata_port *ap = link->ap;
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	void __iomem *mmio = hpriv->base;
 
 	mv_stop_dma(ap);
 
@@ -2383,7 +2521,7 @@ static void mv_error_handler(struct ata_port *ap)
 
 static void mv_eh_freeze(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	struct mv_host_priv *hpriv = ap->host->private_data;
 	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
 	u32 tmp, mask;
 	unsigned int shift;
@@ -2397,13 +2535,14 @@ static void mv_eh_freeze(struct ata_port *ap)
 	mask = 0x3 << shift;
 
 	/* disable assertion of portN err, done events */
-	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
-	writelfl(tmp & ~mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+	tmp = readl(hpriv->main_mask_reg_addr);
+	writelfl(tmp & ~mask, hpriv->main_mask_reg_addr);
 }
 
 static void mv_eh_thaw(struct ata_port *ap)
 {
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = hpriv->base;
 	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
 	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
 	void __iomem *port_mmio = mv_ap_base(ap);
@@ -2430,8 +2569,8 @@ static void mv_eh_thaw(struct ata_port *ap)
 	writel(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	/* enable assertion of portN err, done events */
-	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
-	writelfl(tmp | mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+	tmp = readl(hpriv->main_mask_reg_addr);
+	writelfl(tmp | mask, hpriv->main_mask_reg_addr);
 }
 
 /**
@@ -2598,9 +2737,13 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			break;
 		}
 		break;
+	case chip_soc:
+		hpriv->ops = &mv_soc_ops;
+		hp_flags |= MV_HP_ERRATA_60X1C0;
+		break;
 
 	default:
-		dev_printk(KERN_ERR, &pdev->dev,
+		dev_printk(KERN_ERR, host->dev,
 			   "BUG: invalid board index %u\n", board_idx);
 		return 1;
 	}
@@ -2633,15 +2776,25 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 {
 	int rc = 0, n_hc, port, hc;
-	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
 	struct mv_host_priv *hpriv = host->private_data;
-
-	/* global interrupt mask */
-	writel(0, mmio + HC_MAIN_IRQ_MASK_OFS);
+	void __iomem *mmio = hpriv->base;
 
 	rc = mv_chip_id(host, board_idx);
 	if (rc)
-		goto done;
+	goto done;
+
+	if (HAS_PCI(host)) {
+		hpriv->main_cause_reg_addr = hpriv->base +
+		  HC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_mask_reg_addr = hpriv->base + HC_MAIN_IRQ_MASK_OFS;
+	} else {
+		hpriv->main_cause_reg_addr = hpriv->base +
+		  HC_SOC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_mask_reg_addr = hpriv->base +
+		  HC_SOC_MAIN_IRQ_MASK_OFS;
+	}
+	/* global interrupt mask */
+	writel(0, hpriv->main_mask_reg_addr);
 
 	n_hc = mv_get_hc_count(host->ports[0]->flags);
 
@@ -2672,13 +2825,15 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	for (port = 0; port < host->n_ports; port++) {
 		struct ata_port *ap = host->ports[port];
 		void __iomem *port_mmio = mv_port_base(mmio, port);
-		unsigned int offset = port_mmio - mmio;
 
 		mv_port_init(&ap->ioaddr, port_mmio);
 
 #ifdef CONFIG_PCI
-		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
-		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
+		if (HAS_PCI(host)) {
+			unsigned int offset = port_mmio - mmio;
+			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
+			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
+		}
 #endif
 	}
 
@@ -2694,35 +2849,141 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		writelfl(0, hc_mmio + HC_IRQ_CAUSE_OFS);
 	}
 
-	/* Clear any currently outstanding host interrupt conditions */
-	writelfl(0, mmio + hpriv->irq_cause_ofs);
+	if (HAS_PCI(host)) {
+		/* Clear any currently outstanding host interrupt conditions */
+		writelfl(0, mmio + hpriv->irq_cause_ofs);
 
-	/* and unmask interrupt generation for host regs */
-	writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
+		/* and unmask interrupt generation for host regs */
+		writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
+		if (IS_GEN_I(hpriv))
+			writelfl(~HC_MAIN_MASKED_IRQS_5,
+				 hpriv->main_mask_reg_addr);
+		else
+			writelfl(~HC_MAIN_MASKED_IRQS,
+				 hpriv->main_mask_reg_addr);
+
+		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
+			"PCI int cause/mask=0x%08x/0x%08x\n",
+			readl(hpriv->main_cause_reg_addr),
+			readl(hpriv->main_mask_reg_addr),
+			readl(mmio + hpriv->irq_cause_ofs),
+			readl(mmio + hpriv->irq_mask_ofs));
+	} else {
+		writelfl(~HC_MAIN_MASKED_IRQS_SOC,
+			 hpriv->main_mask_reg_addr);
+		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x\n",
+			readl(hpriv->main_cause_reg_addr),
+			readl(hpriv->main_mask_reg_addr));
+	}
+done:
+	return rc;
+}
 
-	if (IS_GEN_I(hpriv))
-		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
-	else
-		writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
+/**
+ *      mv_platform_probe - handle a positive probe of an soc Marvell
+ *      host
+ *      @pdev: platform device found
+ *
+ *      LOCKING:
+ *      Inherited from caller.
+ */
+static int mv_platform_probe(struct platform_device *pdev)
+{
+	static int printed_version;
+	const struct mv_sata_platform_data *mv_platform_data;
+	const struct ata_port_info *ppi[] =
+	    { &mv_port_info[chip_soc], NULL };
+	struct ata_host *host;
+	struct mv_host_priv *hpriv;
+	struct resource *res;
+	int n_ports, rc;
 
-	VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
-		"PCI int cause/mask=0x%08x/0x%08x\n",
-		readl(mmio + HC_MAIN_IRQ_CAUSE_OFS),
-		readl(mmio + HC_MAIN_IRQ_MASK_OFS),
-		readl(mmio + hpriv->irq_cause_ofs),
-		readl(mmio + hpriv->irq_mask_ofs));
+	if (!printed_version++)
+		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
 
-done:
-	return rc;
+	/*
+	 * Simple resource validation ..
+	 */
+	if (unlikely(pdev->num_resources != 2)) {
+		dev_err(&pdev->dev, "invalid number of resources\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Get the register base first
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL)
+		return -EINVAL;
+
+	/* allocate host */
+	mv_platform_data = pdev->dev.platform_data;
+	n_ports = mv_platform_data->n_ports;
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
+
+	if (!host || !hpriv)
+		return -ENOMEM;
+	host->private_data = hpriv;
+	hpriv->n_ports = n_ports;
+
+	host->iomap = NULL;
+	hpriv->base = ioremap(res->start, res->end - res->start + 1);
+	hpriv->base -= MV_SATAHC0_REG_BASE;
+
+	/* initialize adapter */
+	rc = mv_init_host(host, chip_soc);
+	if (rc)
+		return rc;
+
+	dev_printk(KERN_INFO, &pdev->dev,
+		   "slots %u ports %d\n", (unsigned)MV_MAX_Q_DEPTH,
+		   host->n_ports);
+
+	return ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
+				 IRQF_SHARED, &mv6_sht);
+}
+
+/*
+ *
+ *      mv_platform_remove    -       unplug a platform interface
+ *      @pdev: platform device
+ *
+ *      A platform bus SATA device has been unplugged. Perform the needed
+ *      cleanup. Also called on module unload for any active devices.
+ */
+static int __devexit mv_platform_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *base = hpriv->base;
+
+	ata_host_detach(host);
+	iounmap(base);
+	return 0;
 }
 
+static struct platform_driver mv_platform_driver = {
+	.probe			= mv_platform_probe,
+	.remove			= __devexit_p(mv_platform_remove),
+	.driver			= {
+				   .name = DRV_NAME,
+				   .owner = THIS_MODULE,
+				  },
+};
+
+
 #ifdef CONFIG_PCI
-static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int mv_pci_init_one(struct pci_dev *pdev,
+			   const struct pci_device_id *ent);
+
 
 static struct pci_driver mv_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= mv_pci_tbl,
-	.probe			= mv_init_one,
+	.probe			= mv_pci_init_one,
 	.remove			= ata_pci_remove_one,
 };
 
@@ -2828,14 +3089,15 @@ static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
 }
 
 /**
- *      mv_init_one - handle a positive probe of a Marvell host
+ *      mv_pci_init_one - handle a positive probe of a PCI Marvell host
  *      @pdev: PCI device found
  *      @ent: PCI device ID entry for the matched host
  *
  *      LOCKING:
  *      Inherited from caller.
  */
-static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int mv_pci_init_one(struct pci_dev *pdev,
+			   const struct pci_device_id *ent)
 {
 	static int printed_version;
 	unsigned int board_idx = (unsigned int)ent->driver_data;
@@ -2855,6 +3117,7 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!host || !hpriv)
 		return -ENOMEM;
 	host->private_data = hpriv;
+	hpriv->n_ports = n_ports;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
@@ -2867,6 +3130,7 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 	host->iomap = pcim_iomap_table(pdev);
+	hpriv->base = host->iomap[MV_PRIMARY_BAR];
 
 	rc = pci_go_64(pdev);
 	if (rc)
@@ -2895,11 +3159,22 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 }
 #endif
 
+static int mv_platform_probe(struct platform_device *pdev);
+static int __devexit mv_platform_remove(struct platform_device *pdev);
+
 static int __init mv_init(void)
 {
 	int rc = -ENODEV;
 #ifdef CONFIG_PCI
 	rc = pci_register_driver(&mv_pci_driver);
+	if (rc < 0)
+		return rc;
+#endif
+	rc = platform_driver_register(&mv_platform_driver);
+
+#ifdef CONFIG_PCI
+	if (rc < 0)
+		pci_unregister_driver(&mv_pci_driver);
 #endif
 	return rc;
 }
@@ -2909,6 +3184,7 @@ static void __exit mv_exit(void)
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&mv_pci_driver);
 #endif
+	platform_driver_unregister(&mv_platform_driver);
 }
 
 MODULE_AUTHOR("Brett Russ");
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index bfe92a4..ed5473b 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -247,6 +247,7 @@ struct nv_adma_port_priv {
 	void __iomem		*ctl_block;
 	void __iomem		*gen_block;
 	void __iomem		*notifier_clear_block;
+	u64			adma_dma_mask;
 	u8			flags;
 	int			last_issue_ncq;
 };
@@ -715,9 +716,10 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct nv_adma_port_priv *pp = ap->private_data;
+	struct nv_adma_port_priv *port0, *port1;
+	struct scsi_device *sdev0, *sdev1;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u64 bounce_limit;
-	unsigned long segment_boundary;
+	unsigned long segment_boundary, flags;
 	unsigned short sg_tablesize;
 	int rc;
 	int adma_enable;
@@ -729,6 +731,8 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 		/* Not a proper libata device, ignore */
 		return rc;
 
+	spin_lock_irqsave(ap->lock, flags);
+
 	if (ap->link.device[sdev->id].class == ATA_DEV_ATAPI) {
 		/*
 		 * NVIDIA reports that ADMA mode does not support ATAPI commands.
@@ -737,7 +741,6 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 		 * Restrict DMA parameters as required by the legacy interface
 		 * when an ATAPI device is connected.
 		 */
-		bounce_limit = ATA_DMA_MASK;
 		segment_boundary = ATA_DMA_BOUNDARY;
 		/* Subtract 1 since an extra entry may be needed for padding, see
 		   libata-scsi.c */
@@ -748,7 +751,6 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 		adma_enable = 0;
 		nv_adma_register_mode(ap);
 	} else {
-		bounce_limit = *ap->dev->dma_mask;
 		segment_boundary = NV_ADMA_DMA_BOUNDARY;
 		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
 		adma_enable = 1;
@@ -774,12 +776,49 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 	if (current_reg != new_reg)
 		pci_write_config_dword(pdev, NV_MCP_SATA_CFG_20, new_reg);
 
-	blk_queue_bounce_limit(sdev->request_queue, bounce_limit);
+	port0 = ap->host->ports[0]->private_data;
+	port1 = ap->host->ports[1]->private_data;
+	sdev0 = ap->host->ports[0]->link.device[0].sdev;
+	sdev1 = ap->host->ports[1]->link.device[0].sdev;
+	if ((port0->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	    (port1->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+		/** We have to set the DMA mask to 32-bit if either port is in
+		    ATAPI mode, since they are on the same PCI device which is
+		    used for DMA mapping. If we set the mask we also need to set
+		    the bounce limit on both ports to ensure that the block
+		    layer doesn't feed addresses that cause DMA mapping to
+		    choke. If either SCSI device is not allocated yet, it's OK
+		    since that port will discover its correct setting when it
+		    does get allocated.
+		    Note: Setting 32-bit mask should not fail. */
+		if (sdev0)
+			blk_queue_bounce_limit(sdev0->request_queue,
+					       ATA_DMA_MASK);
+		if (sdev1)
+			blk_queue_bounce_limit(sdev1->request_queue,
+					       ATA_DMA_MASK);
+
+		pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	} else {
+		/** This shouldn't fail as it was set to this value before */
+		pci_set_dma_mask(pdev, pp->adma_dma_mask);
+		if (sdev0)
+			blk_queue_bounce_limit(sdev0->request_queue,
+					       pp->adma_dma_mask);
+		if (sdev1)
+			blk_queue_bounce_limit(sdev1->request_queue,
+					       pp->adma_dma_mask);
+	}
+
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
 	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
 	ata_port_printk(ap, KERN_INFO,
-		"bounce limit 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
-		(unsigned long long)bounce_limit, segment_boundary, sg_tablesize);
+		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
+		(unsigned long long)*ap->host->dev->dma_mask,
+		segment_boundary, sg_tablesize);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
 	return rc;
 }
 
@@ -1140,10 +1179,20 @@ static int nv_adma_port_start(struct ata_port *ap)
 	void *mem;
 	dma_addr_t mem_dma;
 	void __iomem *mmio;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 tmp;
 
 	VPRINTK("ENTER\n");
 
+	/* Ensure DMA mask is set to 32-bit before allocating legacy PRD and
+	   pad buffers */
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
+
 	rc = ata_port_start(ap);
 	if (rc)
 		return rc;
@@ -1159,6 +1208,15 @@ static int nv_adma_port_start(struct ata_port *ap)
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
 
+	/* Now that the legacy PRD and padding buffer are allocated we can
+	   safely raise the DMA mask to allocate the CPB/APRD table.
+	   These are allowed to fail since we store the value that ends up
+	   being used to set as the bounce limit in slave_config later if
+	   needed. */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	pp->adma_dma_mask = *dev->dma_mask;
+
 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
 				  &mem_dma, GFP_KERNEL);
 	if (!mem)
@@ -2417,12 +2475,6 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hpriv->type = type;
 	host->private_data = hpriv;
 
-	/* set 64bit dma masks, may fail */
-	if (type == ADMA) {
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
-			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	}
-
 	/* request and iomap NV_MMIO_BAR */
 	rc = pcim_iomap_regions(pdev, 1 << NV_MMIO_BAR, DRV_NAME);
 	if (rc)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 3ef072f..30caa03 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -30,8 +30,6 @@
  *  Hardware documentation available under NDA.
  *
  *
- *  To-do list:
- *  - VT6421 PATA support
  *
  */
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 26c82ce..688fcae 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -17,7 +17,7 @@
 #include <linux/ide.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
-#include <linux/pata_platform.h>
+#include <linux/ata_platform.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
new file mode 100644
index 0000000..b856a2a
--- /dev/null
+++ b/include/linux/ata_platform.h
@@ -0,0 +1,34 @@
+#ifndef __LINUX_ATA_PLATFORM_H
+#define __LINUX_ATA_PLATFORM_H
+
+struct pata_platform_info {
+	/*
+	 * I/O port shift, for platforms with ports that are
+	 * constantly spaced and need larger than the 1-byte
+	 * spacing used by ata_std_ports().
+	 */
+	unsigned int ioport_shift;
+	/* 
+	 * Indicate platform specific irq types and initial
+	 * IRQ flags when call request_irq()
+	 */
+	unsigned int irq_flags;
+};
+
+extern int __devinit __pata_platform_probe(struct device *dev,
+					   struct resource *io_res,
+					   struct resource *ctl_res,
+					   struct resource *irq_res,
+					   unsigned int ioport_shift,
+					   int __pio_mask);
+
+extern int __devexit __pata_platform_remove(struct device *dev);
+
+/*
+ * Marvell SATA private data
+ */
+struct mv_sata_platform_data {
+	int	n_ports; /* number of sata ports */
+};
+
+#endif /* __LINUX_ATA_PLATFORM_H */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4374c42..bc5a8d0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -457,7 +457,6 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
-	unsigned int		n_iter;
 	unsigned int		mapped_n_elem;
 
 	int			dma_dir;
@@ -1367,7 +1366,6 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->nbytes = qc->raw_nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
 	qc->mapped_n_elem = 0;
-	qc->n_iter = 0;
 	qc->err_mask = 0;
 	qc->pad_len = 0;
 	qc->last_sg = NULL;
diff --git a/include/linux/pata_platform.h b/include/linux/pata_platform.h
deleted file mode 100644
index 6a7a92d..0000000
--- a/include/linux/pata_platform.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef __LINUX_PATA_PLATFORM_H
-#define __LINUX_PATA_PLATFORM_H
-
-struct pata_platform_info {
-	/*
-	 * I/O port shift, for platforms with ports that are
-	 * constantly spaced and need larger than the 1-byte
-	 * spacing used by ata_std_ports().
-	 */
-	unsigned int ioport_shift;
-	/* 
-	 * Indicate platform specific irq types and initial
-	 * IRQ flags when call request_irq()
-	 */
-	unsigned int irq_flags;
-};
-
-extern int __devinit __pata_platform_probe(struct device *dev,
-					   struct resource *io_res,
-					   struct resource *ctl_res,
-					   struct resource *irq_res,
-					   unsigned int ioport_shift,
-					   int __pio_mask);
-
-extern int __devexit __pata_platform_remove(struct device *dev);
-
-#endif /* __LINUX_PATA_PLATFORM_H */
