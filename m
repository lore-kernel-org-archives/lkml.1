Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYERSmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYERSmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYERSin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbYERSim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kT2fVyAEvCILvVcQQGAQtBlMK0fGDBugifQ8fbhxqMMzY/pw6xTnnFzeL3nyDcidEbavDE+MxgZRQ5fDgSOM9mEL8QCpz/8Q4RFogt+fOYBRdOcgDSYHnT1RDFyNYigqbh1IV4m1uOSIqIs0BIUuY//Qh6+pdaB7L3Aa6YfemLM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:07 +0200
Message-Id: <20080518185607.5636.91889.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/40] ide-tape: remove unneeded CONFIG_BLK_DEV_IDEDMA ifdef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PC_FLAG_DMA_IN_PROGRESS flag is never set if DMA support is disabled.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -973,11 +973,11 @@ static ide_startstop_t idetape_transfer_
 	}
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
-#ifdef CONFIG_BLK_DEV_IDEDMA
+
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
 		hwif->dma_ops->dma_start(drive);
-#endif
+
 	/* Send the actual packet */
 	hwif->output_data(drive, NULL, pc->c, 12);
 
