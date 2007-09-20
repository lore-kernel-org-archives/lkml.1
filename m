Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXITUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXITUPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXITUPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:15:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52939 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXITUP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:15:28 -0400
Date: Thu, 20 Sep 2007 16:15:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070920201527.GA12136@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes from Alan, PCI IDs from ATI/AMD.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   10 ++++++----
 drivers/ata/libata-core.c |    4 ++++
 drivers/ata/libata-sff.c  |    5 ++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

Alan Cox (2):
      libata: Update the blacklist with a few more devices
      libata-sff: Fix documentation

henry su (1):
      [libata] ahci: add ATI SB800 PCI IDs

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 06f212f..c168203 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -418,10 +418,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 IDE */
-	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700 AHCI */
-	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700 nraid5 */
-	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700 raid5 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb600 }, /* ATI SB700/800 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c43de9a..772be09 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3778,6 +3778,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1BM0",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1B10",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
+	{ "Maxtor 7B300S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
 	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
 	 ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
@@ -3794,6 +3797,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
+	{ "ST3160812AS",	"3.AD",		ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1cce219..8023167 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -297,7 +297,7 @@ void ata_bmdma_start (struct ata_queued_cmd *qc)
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 
-	/* Strictly, one may wish to issue a readb() here, to
+	/* Strictly, one may wish to issue an ioread8() here, to
 	 * flush the mmio write.  However, control also passes
 	 * to the hardware at this point, and it will interrupt
 	 * us when we are to resume control.  So, in effect,
@@ -307,6 +307,9 @@ void ata_bmdma_start (struct ata_queued_cmd *qc)
 	 * is expected, so I think it is best to not add a readb()
 	 * without first all the MMIO ATA cards/mobos.
 	 * Or maybe I'm just being paranoid.
+	 *
+	 * FIXME: The posting of this write means I/O starts are
+	 * unneccessarily delayed for MMIO
 	 */
 }
 
