Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0ARR2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0ARR2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697Ab0ARR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:28:51 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56844 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab0ARRT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=H133s0k0ImA/ZVV5QouzE5FOT8I+1USCJlAQSvAh6JZrVVFJxpOG4EM9XsSCB9CSyh
         4jwuuLGAb4UwpUGUk8ErxzRpkKpoeoEfdAx4069037nW27AKiWr9DiiYk9quZp0d80cR
         b/6sUCa1haDiESpRIs4VMbs+j0Rj5/j8Rbvdk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:38 +0100
Message-Id: <20100118171838.14623.62499.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 32/64] cmd64x: remove superfluous checks from cmd64x_set_dma_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd64x: remove superfluous checks from cmd64x_set_dma_mode()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd64x.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -172,10 +172,8 @@ static void cmd64x_set_dma_mode(ide_driv
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
 
-	if (speed >= XFER_SW_DMA_0) {
-		(void) pci_read_config_byte(dev, pciU, &regU);
-		regU &= ~(unit ? 0xCA : 0x35);
-	}
+	pci_read_config_byte(dev, pciU, &regU);
+	regU &= ~(unit ? 0xCA : 0x35);
 
 	switch(speed) {
 	case XFER_UDMA_5:
@@ -207,8 +205,7 @@ static void cmd64x_set_dma_mode(ide_driv
 		break;
 	}
 
-	if (speed >= XFER_SW_DMA_0)
-		(void) pci_write_config_byte(dev, pciU, regU);
+	pci_write_config_byte(dev, pciU, regU);
 }
 
 static void cmd648_clear_irq(ide_drive_t *drive)
