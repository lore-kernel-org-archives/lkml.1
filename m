Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYCVVw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYCVVw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbYCVVvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:51:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:19402 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbYCVVvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ssd5WgUJnoF5YMzCNNG4AVFk/yFOzWf0iVWoKA+644rTLbiGoFbk0JkRuzQugdK0tqfz55DFp+xGVQRXYL8wbSDB3vl8Chqw/g8xRwIkcmcSbiI5ouXdif6hWVk9WQ1MJMznI6gcjdppJ+7VqX8uDUnvdGk6r6Ilhox/LdY9t74=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:06:39 +0100
Message-Id: <20080322220639.17636.80893.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/8] ide: remove IDE_HFLAG_NO_AUTOTUNE host flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Don't set IDE_HFLAG_NO_AUTOTUNE host flag in sgiioc4 and icside
  host drivers - there is no need for it as they don't implement
  ->set_pio_mode method.

* Remove no longer needed IDE_HFLAG_NO_AUTOTUNE host flag.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c  |    3 +--
 drivers/ide/ide-probe.c   |    3 +--
 drivers/ide/pci/sgiioc4.c |    1 -
 include/linux/ide.h       |    2 --
 4 files changed, 2 insertions(+), 7 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -480,8 +480,7 @@ static const struct ide_port_info icside
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE |
-				  IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_SERIALIZE,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
 };
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1324,8 +1324,7 @@ static void ide_port_init_devices(ide_hw
 			drive->unmask = 1;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
 			drive->no_unmask = 1;
-		if ((hwif->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0)
-			drive->autotune = 1;
+		drive->autotune = 1;
 	}
 
 	if (port_ops && port_ops->port_init_devs)
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -573,7 +573,6 @@ static const struct ide_port_info sgiioc
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
-	.host_flags		= IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1062,8 +1062,6 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
-	/* don't autotune PIO */
-	IDE_HFLAG_NO_AUTOTUNE		= (1 << 16),
 	/* host is CS5510/CS5520 */
 	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
