Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0ARRTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0ARRTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971Ab0ARRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:50 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0ARRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wzg+fB3QrjvMdwl/Jl+LC588K9GJXkMZfqFJeAxezIUa2DCC9Wpbkmt4Fe6a80s4wz
         bP3b7+3MaTCFICc2z06SSfScnUwungyZCsqm5JM2bsxTHgbaJBPRePjD+1jNqwSBpde2
         2cM86+Rt9FhudFDBVqb5j4EcI6+DIJfXfgOGA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:29 +0100
Message-Id: <20100118171729.14623.46024.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 25/64] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timings.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -166,12 +166,13 @@ int ide_timing_compute(ide_drive_t *driv
 	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
 
-		if (speed <= XFER_PIO_2)
-			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
-		else if ((speed <= XFER_PIO_4) ||
-			 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
-			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
-		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
+			if (speed <= XFER_PIO_2)
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
+			else if ((speed <= XFER_PIO_4) ||
+				 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
+		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
 			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
 
 		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
