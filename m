Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYLGRVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYLGRVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYLGRVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:21:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:22737 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYLGRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ELni7xMlPJD7VB0Z7Pyi2fM4W5rYOyCz8zCmS1Rli0Er16a+DvXFjfKGNNl4PIWsU8
         jw7SbHwLMAfJFzPccflt3wokkMA4dJZCDG9gi8OGUS11kIw9o010s1PPBXrZsWMt1az0
         aLFHhmIV3OSaE/+XiGA8hxuMRYQs++E6sNVdc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/4] ide-atapi: remove ide-scsi remnants from ide_issue_pc
Date: Sun,  7 Dec 2008 18:21:08 +0100
Message-Id: <1228670471-3435-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index c110329..ff6b567 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -602,7 +602,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 	ide_expiry_t *expiry = NULL;
 	u32 tf_flags;
 	u16 bcount;
-	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
 	/* We haven't transferred any data yet */
 	pc->xferred = 0;
@@ -612,10 +611,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
 		expiry = ide_cd_expiry;
-	} else if (scsi) {
-		tf_flags = 0;
-		bcount = min(pc->req_xfer, 63 * 1024);
-		expiry = ide_scsi_expiry;
 	} else {
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
@@ -630,13 +625,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 
 	if (((pc->flags & PC_FLAG_DMA_OK) &&
 		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
-	    drive->dma) {
-		if (scsi)
-			hwif->sg_mapped = 1;
+	    drive->dma)
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
-		if (scsi)
-			hwif->sg_mapped = 0;
-	}
 
 	if (!drive->dma)
 		pc->flags &= ~PC_FLAG_DMA_OK;
-- 
1.6.0.4

