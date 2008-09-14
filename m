Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYINLir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYINLir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYINLgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYINLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=fOvnwf/In92D4Myu7hkgW35C6lsHFaU59vWXzz6oxo5jJkcucAulP1nHItX7ViEgpF
         zKESQz269skvFSuSZer/TwlrAQnGGRzq+5Z+/vuaFpHQ9WcCVdg6f3TwW9KB83eznvHB
         FJoApbXE15d3M3BIo4loqM1n8UHzS3BtvsKm0=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 06/10] ide-atapi: add a DEV_IS_IDECD macro
Date: Sun, 14 Sep 2008 13:35:54 +0200
Message-Id: <1221392158-3848-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a short-term-use one and will be removed later - it is added to solely
improve readability.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7045d34..e1fa52d 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -477,6 +477,9 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 	return WAIT_FLOPPY_CMD;
 }
 
+#define DEV_IS_IDECD(drive)	\
+		(drive->media == ide_cdrom || drive->media == ide_optical)
+
 static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
@@ -487,7 +490,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if ((drive->media == ide_cdrom || drive->media == ide_optical) &&
+	if (DEV_IS_IDECD(drive) &&
 	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)) {
 		if (drive->dma)
 			drive->waiting_for_dma = 1;
@@ -561,7 +564,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	/* Request to transfer the entire buffer at once */
 	if (drive->media == ide_tape && scsi == 0)
 		bcount = pc->req_xfer;
-	else if (drive->media == ide_cdrom || drive->media == ide_optical)
+	else if (DEV_IS_IDECD(drive))
 		bcount = xferlen;
 	else
 		bcount = min(pc->req_xfer, 63 * 1024);
@@ -573,8 +576,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 
 	if (((pc->flags & PC_FLAG_DMA_OK) &&
 		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
-	    ((drive->media == ide_cdrom || drive->media == ide_optical) &&
-	         drive->dma)) {
+	    (DEV_IS_IDECD(drive) && drive->dma)) {
 		if (scsi)
 			hwif->sg_mapped = 1;
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
@@ -587,7 +589,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 
 	if (scsi)
 		tf_flags = 0;
-	else if (drive->media == ide_cdrom || drive->media == ide_optical)
+	else if (DEV_IS_IDECD(drive))
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 	else
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
-- 
1.5.5.1

