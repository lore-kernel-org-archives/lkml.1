Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYKIQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYKIQZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYKIQYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:24:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYKIQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=METFoxMKNtToeppf/6bc98Dlk/Q5Rh/Mm8GC5/MWNrF+FojvmLcsX9RX2byhPYLPaB
         RsQy8FFb0Ov+8ZXVxnuYnO5YNaSg3Yn8/j3HiQuNPBzIwA6Aocbq/52ZPl4mn/5oqudn
         ChsJkqrHWfsOsONmHpvcy0TsoLaLVc1vuhj84=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:22:19 +0100
Message-Id: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/11] ide: respect current DMA setting during resume
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: respect current DMA setting during resume

Respect current DMA setting during resume, otherwise PIO timings
may get destroyed if host uses shared PIO/MWDMA timings.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -192,10 +192,8 @@ static ide_startstop_t ide_start_power_s
 		 */
 		if (drive->hwif->dma_ops == NULL)
 			break;
-		/*
-		 * TODO: respect IDE_DFLAG_USING_DMA
-		 */
-		ide_set_dma(drive);
+		if (drive->dev_flags & IDE_DFLAG_USING_DMA)
+			ide_set_dma(drive);
 		break;
 	}
 
