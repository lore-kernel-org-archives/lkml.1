Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZEIHsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZEIHsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZEIHp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64707 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZEIHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jjebis+J1ypZ3ABumqmJHlJ50hrYpq7zK7tmh+AGKKaWbliQZT1KoC9YRY2GVZXxYj
         9fyhloD3FIYwf4JgaQ6T8A2O4CQe8PvfKEy/ef9HWcDwSNS6py9Pjp5q5MvFFhAVvlWD
         hODj9qtXkXrIo4GgR3sjUDt0JNF9bCmAFKSEk=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] ide-floppy/ide_floppy_get_sfrp_bit: use local buffer
Date: Sat,  9 May 2009 09:45:27 +0200
Message-Id: <1241855134-4984-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy_ioctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 9c2518d..0d2c9f0 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -117,16 +117,17 @@ static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
 static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 buf[20];
 
 	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf, pc->req_xfer))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, buf, pc->req_xfer))
 		return 1;
 
-	if (pc->buf[8 + 2] & 0x40)
+	if (buf[8 + 2] & 0x40)
 		drive->atapi_flags |= IDE_AFLAG_SRFP;
 
 	return 0;
-- 
1.6.2.4

