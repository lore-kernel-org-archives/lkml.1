Return-Path: <linux-kernel-owner+w=401wt.eu-S935130AbXHHBHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130AbXHHBHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762843AbXHHBHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:07:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54094 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbXHHBHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:07:34 -0400
Date: Tue, 7 Aug 2007 21:07:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070808010733.GA3849@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The only non-fix are two sata_mv PCI ID additions.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |    2 +-
 drivers/ata/pata_isapnp.c |    2 ++
 drivers/ata/sata_mv.c     |    3 +++
 3 files changed, 6 insertions(+), 1 deletions(-)

Alan Cox (1):
      sata_mv: PCI IDs for Hightpoint RocketRaid 1740/1742

Jeff Garzik (1):
      [libata] pata_isapnp: replace missing module device table

Tejun Heo (1):
      ata_piix: update map 10b for ich8m

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a78832e..c5b4509 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -436,7 +436,7 @@ static const struct piix_map_db ich8_map_db = {
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
 		{  RV,  RV,  RV,  RV },
-		{  IDE,  IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{  P0,  P2, IDE, IDE }, /* 10b (IDE mode) */
 		{  RV,  RV,  RV,  RV },
 	},
 };
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 5525518..91a396f 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -139,6 +139,8 @@ static struct pnp_device_id isapnp_devices[] = {
 	{.id = ""}
 };
 
+MODULE_DEVICE_TABLE(pnp, isapnp_devices);
+
 static struct pnp_driver isapnp_driver = {
 	.name		= DRV_NAME,
 	.id_table	= isapnp_devices,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8ec5208..3acf65e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -621,6 +621,9 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
 	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1740/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
