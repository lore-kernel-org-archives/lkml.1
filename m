Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYHQRTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYHQRTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYHQRSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:18:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:30781 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYHQRSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oEjO61kxiiXRKBWfBtESr4nJ8icNBYjv18eRY8Jdi1yV6JEL3KG04hYS5gqHf7yNpi
         Z4HRfNFvXRvP6h5U7IRRUwfXxMRttOyoTNDjzfEAeJtappZUGsChlFHULf8USWmy6yTz
         on4PREPiKLf/XXdfyBgPDilcKC2nwjIdStGkc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:15:48 +0200
Message-Id: <20080817171548.27943.58522.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: remove superfluous ->dma field from ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c      |    2 --
 drivers/ide/pci/scc_pata.c |    2 --
 include/linux/ide.h        |    2 --
 3 files changed, 6 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -525,7 +525,6 @@ void ide_dma_start(ide_drive_t *drive)
 		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
 	}
 
-	hwif->dma = 1;
 	wmb();
 }
 
@@ -564,7 +563,6 @@ int __ide_dma_end (ide_drive_t *drive)
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
-	hwif->dma = 0;
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
 }
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -353,7 +353,6 @@ static void scc_dma_start(ide_drive_t *d
 
 	/* start DMA */
 	scc_ide_outb(dma_cmd | 1, hwif->dma_base);
-	hwif->dma = 1;
 	wmb();
 }
 
@@ -374,7 +373,6 @@ static int __scc_dma_end(ide_drive_t *dr
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
-	hwif->dma = 0;
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -745,8 +745,6 @@ typedef struct hwif_s {
 
 	void		*hwif_data;	/* extra hwif data */
 
-	unsigned dma;
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_hwif_link *acpidata;
 #endif
