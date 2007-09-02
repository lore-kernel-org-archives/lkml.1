Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXIBMM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXIBMM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964822AbXIBMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:12:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:32998 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbXIBMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:12:17 -0400
Date: Sun, 2 Sep 2007 08:12:16 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata critical fixes
Message-ID: <20070902121216.GA32010@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c |    5 ++++-
 drivers/ata/sata_via.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

Jeff Garzik (1):
      [libata] ata_piix: properly terminate DMI system list

Ondrej Zary (1):
      Fix sata_via write errors on PATA drive connected to VT6421

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e40c94f..3b8bf18 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -955,7 +955,8 @@ static int piix_broken_suspend(void)
 				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
 			},
 		},
-		{ }
+
+		{ }	/* terminate list */
 	};
 	static const char *oemstrs[] = {
 		"Tecra M3,",
@@ -1187,6 +1188,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
 			},
 		},
+
+		{ }	/* terminate list */
 	};
 	u32 iocfg;
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index a4e6317..57fd30d 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -371,7 +371,7 @@ static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
-	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->pio_mode - XFER_UDMA_0]);
+	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
 }
 
 static const unsigned int svia_bar_sizes[] = {
