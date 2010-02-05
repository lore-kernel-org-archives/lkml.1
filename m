Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0BEN3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:29:49 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57674 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab0BEN3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:29:46 -0500
Date: Fri, 5 Feb 2010 14:29:59 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Jeff Garzik <jgarzik@pobox.com>, Erik Inge Bols?? <knan-lkml@anduin.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] non-existant config in kernel source (CONFIG_AHCI)
Message-ID: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	While there's one place that is checking for CONFIG_AHCI, this
config being referenced from printed books and people pointing to this
config item I can't find it anywhere in the kernel kconfig
infrastruture and it doesn't seem to ever have been there (since
git). Is this maybe a typo for CONFIG_SATA_AHCI? reading the
information for the affected piece of source it would actually make
sense.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 60136f94d9c97f9a788738e30731e25bd794322b Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:26:33 +0100
Subject: [PATCH] CONFIG_AHCI is really CONFIG_SATA_AHCI

The marvell driver comtains a fallback to ahci for the sata ports
which is incorrectly checked as CONFIG_AHCI while the only AHCI config
item is actually called SATA_AHCI (which also sounds sensible
considering it's a fallback for the sata ports).

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/ata/pata_marvell.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 950da39..eabd138 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -147,7 +147,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	if (pdev->device == 0x6101)
 		ppi[1] = &ata_dummy_port_info;
 
-#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
+#if defined(CONFIG_SATA_AHCI) || defined(SATA_CONFIG_AHCI_MODULE)
 	if (!marvell_pata_active(pdev)) {
 		printk(KERN_INFO DRV_NAME ": PATA port not active, deferring to AHCI driver.\n");
 		return -ENODEV;
-- 
1.6.3.3


