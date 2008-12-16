Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYLPLFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYLPLFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYLPLFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:05:37 -0500
Received: from havoc.gtf.org ([69.61.125.42]:36746 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPLFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:05:36 -0500
Date: Tue, 16 Dec 2008 06:05:34 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081216110534.GA28592@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) More pata_hpt366 [major] fixes

2) Fix NCQ blacklist.  A better fix will shorten this list through

   smarter blacklist wildcard code, but that better fix is not
   appropriate for -rc.  This is actually the minimal -rc/stable fix.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   65 ++++++++++++++++++++++++++++++++++++++++----
 drivers/ata/pata_hpt366.c |   12 ++++++--
 2 files changed, 68 insertions(+), 9 deletions(-)

Tejun Heo (3):
      libata: fix Seagate NCQ+FLUSH blacklist
      pata_hpt366: fix cable detection,
      pata_hpt366: no ATAPI DMA

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5e2eb74..bc6695e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4050,17 +4050,70 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
 	/* Seagate NCQ + FLUSH CACHE firmware bug */
-	{ "ST31500341AS",	"9JU138",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD15",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"9FZ136",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD16",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"9FZ164",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD17",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"9FZ134",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD18",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"9FZ182",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD19",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"9FZ162",	ATA_HORKAGE_NONCQ |
+
+	{ "ST31000333AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3640623AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3640323AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3320813AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3320613AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD19",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index a098ba8..e0c4f05 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -183,7 +183,9 @@ static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
 			mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
 			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
-	}
+	} else if (adev->class == ATA_DEV_ATAPI)
+		mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
+
 	return ata_bmdma_mode_filter(adev, mask);
 }
 
@@ -211,11 +213,15 @@ static u32 hpt36x_find_mode(struct ata_port *ap, int speed)
 
 static int hpt36x_cable_detect(struct ata_port *ap)
 {
-	u8 ata66;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 ata66;
 
+	/*
+	 * Each channel of pata_hpt366 occupies separate PCI function
+	 * as the primary channel and bit1 indicates the cable type.
+	 */
 	pci_read_config_byte(pdev, 0x5A, &ata66);
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & 2)
 		return ATA_CBL_PATA40;
 	return ATA_CBL_PATA80;
 }
