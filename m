Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220Ab0ARRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0ARRPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125Ab0ARRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:15:43 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63659 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0ARRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ix5xyu6GZMp7b9jbTrdMgIqsDD+OBcTz3fh8qzdm3aMp1lEHvuFTUexfdrswUA/KqC
         MX68edNYDsBr58t/101kCkJTz7ccOj8OOfdKEARJnkRvRkrZx5nkZXTC+KscuL1qFbX7
         nqmVCxUglP39IiWvfcFVTTp2ODT5wA6fKAfwY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:27 +0100
Message-Id: <20100118171427.14623.34958.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 05/64] pata_atiixp: remove superfluous wrapper function
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: remove superfluous wrapper function

Fix documentation for ->set_[pio,dma]mode methods while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -72,22 +72,22 @@ static int atiixp_prereset(struct ata_li
 }
 
 /**
- *	atiixp_set_pio_timing	-	set initial PIO mode data
+ *	atiixp_set_piomode	-	set PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Called by both the pio and dma setup functions to set the controller
- *	timings for PIO transfers. We must load both the mode number and
- *	timing values into the controller.
+ *	Called to set the controller timings for PIO transfers.  We must
+ *	load both the mode number and timing values into the controller.
  */
 
-static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev, int pio)
+static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static u8 pio_timings[5] = { 0x5D, 0x47, 0x34, 0x22, 0x20 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int dn = 2 * ap->port_no + adev->devno;
 	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
+	int pio = adev->pio_mode - XFER_PIO_0;
 	u32 pio_timing_data;
 	u16 pio_mode_data;
 
@@ -103,26 +103,11 @@ static void atiixp_set_pio_timing(struct
 }
 
 /**
- *	atiixp_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the PIO mode setup. We use a shared helper for this
- *	as the DMA setup must also adjust the PIO timing information.
- */
-
-static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	atiixp_set_pio_timing(ap, adev, adev->pio_mode - XFER_PIO_0);
-}
-
-/**
- *	atiixp_set_dmamode	-	set initial DMA mode data
+ *	atiixp_set_dmamode	-	set DMA mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Called to do the DMA mode setup. We use timing tables for most
- *	modes but must tune an appropriate PIO mode to match.
+ *	Called to do the DMA mode setup.
  */
 
 static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
