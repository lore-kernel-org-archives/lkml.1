Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZEIHsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZEIHsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZEIHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:54 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:62202 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZEIHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ALxrEOD8SQ633euSrvQXYlex5MS+QZOm5nylBpwzJzoc8Z8AlXWtN4dwuatJ4L4r5X
         JIG0nTLb4hlPWrCSLRGBr4O4ubzI7MsjL0XO6ONyn+01EmvLubyZuUIWRO1yOjAKNWrS
         qZ3tchkrDGnoT+lTpQi4hzCwPFd+lDeKZxD1M=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] ide-tape/ide_tape_get_bsize_from_bdesc: use local buffer
Date: Sat,  9 May 2009 09:45:31 +0200
Message-Id: <1241855134-4984-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index dc69c5d..7f70926 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1451,9 +1451,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
+	u8 buf[12];
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.buf, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -1462,10 +1463,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 		}
 		return;
 	}
-	tape->blk_size = (pc.buf[4 + 5] << 16) +
-				(pc.buf[4 + 6] << 8)  +
-				 pc.buf[4 + 7];
-	tape->drv_write_prot = (pc.buf[2] & 0x80) >> 7;
+	tape->blk_size = (buf[4 + 5] << 16) +
+				(buf[4 + 6] << 8)  +
+				 buf[4 + 7];
+	tape->drv_write_prot = (buf[2] & 0x80) >> 7;
 }
 
 static int idetape_chrdev_open(struct inode *inode, struct file *filp)
-- 
1.6.2.4

