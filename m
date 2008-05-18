Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYERSnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYERSnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757000AbYERSiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbYERSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=R0WGPL+VbTZoU+XXg522nprlgL2VGShLOxqDqm+daS3vQGIinMg1IF5qft+JBLER8qtutIrTKWPhcbBrXFzHzhrCIVMhnb/jfm0InnlYyPKcpSTV4pOqVdUEY45Eks7YFo4Sq6h7Y2FxvYgIy6wnE4qSpZdnQwFT3QapV90acMg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:16 +0200
Message-Id: <20080518185616.5636.22797.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/40] ide-tape: remove stale comments from idetape_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   21 ---------------------
 1 file changed, 21 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -758,27 +758,6 @@ static ide_startstop_t idetape_pc_intr(i
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) || (stat & ERR_STAT)) {
-			/*
-			 * A DMA error is sometimes expected. For example,
-			 * if the tape is crossing a filemark during a
-			 * READ command, it will issue an irq and position
-			 * itself before the filemark, so that only a partial
-			 * data transfer will occur (which causes the DMA
-			 * error). In that case, we will later ask the tape
-			 * how much bytes of the original request were
-			 * actually transferred (we can't receive that
-			 * information from the DMA engine on most chipsets).
-			 */
-
-			/*
-			 * On the contrary, a DMA error is never expected;
-			 * it usually indicates a hardware error or abort.
-			 * If the tape crosses a filemark during a READ
-			 * command, it will issue an irq and position itself
-			 * after the filemark (not before). Only a partial
-			 * data transfer will occur, but no DMA error.
-			 * (AS, 19 Apr 2001)
-			 */
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
