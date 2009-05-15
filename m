Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbZEOFNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbZEOFNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZEOFLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:45 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:39763 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZEOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gkAP8R3zK7meaAimWk8Vk8mRBjdkD+nxvKOCpzRjtxuE5+ByBXoUTn63wKM1P/tugQ
         I2cN/GmevFsmpNzmH9UJe46Q6+T1IHSmhS2FAWhFv4MZpzIihfbBPQa8BjWt52EjCTPW
         I0R1gU45aS8U0QNnPh0DrPRlu0hL98alj6heY=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] ide-floppy/ide_floppy_get_sfrp_bit: use local buffer
Date: Fri, 15 May 2009 07:11:25 +0200
Message-Id: <1242364293-29223-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
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
1.6.3

