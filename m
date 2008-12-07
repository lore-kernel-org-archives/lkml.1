Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYLGRWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYLGRWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYLGRVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:21:22 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:63854 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYLGRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=xAmi1I3aeESBkOONrKPlcx9VT7ERJCqkJpUBfhx+Fmo7hs+tR4vAf7/Kliqw7Z45Ur
         YpZZ2yK+dCOIwqXJERQEBWzyREZ1FJBUR0Ou433YJY1zwbfU8zKmZxgXIp4es3bgNjre
         CFyOUcigzasAsNFvvdq+Nd4Y4V7jVcGLghXO8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/4] ide-atapi: remove ide-scsi remnants from ide_transfer_pc()
Date: Sun,  7 Dec 2008 18:21:09 +0100
Message-Id: <1228670471-3435-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index ff6b567..f5bf405 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -550,8 +550,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	ireason = ide_read_ireason(drive);
-	if (drive->media == ide_tape &&
-	    (drive->dev_flags & IDE_DFLAG_SCSI) == 0)
+	if (drive->media == ide_tape)
 		ireason = ide_wait_ireason(drive, ireason);
 
 	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
@@ -569,14 +568,9 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		timeout = drive->pc_delay;
 		expiry = &ide_delayed_transfer_pc;
 	} else {
-		if (drive->dev_flags & IDE_DFLAG_SCSI) {
-			timeout = ide_scsi_get_timeout(pc);
-			expiry = ide_scsi_expiry;
-		} else {
-			timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
-							       : WAIT_TAPE_CMD;
-			expiry = NULL;
-		}
+		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+						       : WAIT_TAPE_CMD;
+		expiry = NULL;
 	}
 
 	/* Set the interrupt routine */
-- 
1.6.0.4

