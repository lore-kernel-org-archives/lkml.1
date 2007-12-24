Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbXLXOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbXLXOFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLXOFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:05:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:5483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXLXOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uq+valUs8ITOmYYq1tCQI0SMApF8A86ycN0CeSdJWaS/6iZ+lMnqQbL0sFk610mceSV3L70ThiA8Q6wJRFlpzeagnEZ0PODQAgXNn0rHBbMEfPyQrwpRUmu1y++usBuWh+BesVfCVS01MwHlBZ0IgUhCAUZxSwjQsrICVMhZ6ew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] cmd64x: fix hwif->chipset setup
Date: Mon, 24 Dec 2007 15:15:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712241515.31340.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 528a572daea90aa41db92683e5a8756acef514c4 ("ide: add ->chipset field
to ide_pci_device_t") broke hwif->chipset setup (it is now set to ide_cmd646
for CMD648 instead of CMD646).  It seems that the breakage happend while
I was moving patches around (cmd64x_chipsets[] entries for CMD646 and CMD648
are identical except for 'name' field).  Fix it and bump driver version.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd64x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cmd64x.c		Version 1.51	Nov 8, 2007
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.52	Dec 24, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Due to massive hardware bugs, UltraDMA is only supported
@@ -564,6 +564,7 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
+		.chipset	= ide_cmd646,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -573,7 +574,6 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
-		.chipset	= ide_cmd646,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
