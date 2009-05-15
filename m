Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbZEOFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbZEOFQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZEOFMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:12:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61099 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbZEOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iE+XMB4qhnGLaqAE/R0hoPdFqpQX1OyEgG9BCe0LvBUGDZJJVl+4PIOhGmMI6vaZZC
         xy823aByZcjNeOEhR/J8TIgkFpLMI5et33jXCsdwWzyZFEus0S99BIcp25g7oNigXZOh
         20V6H24vlb366lqnM3d3SsQ2l3qE7FtCqQ1ao=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] ide-tape/ide_tape_get_bsize_from_bdesc: use local buffer
Date: Fri, 15 May 2009 07:11:29 +0200
Message-Id: <1242364293-29223-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ef5f342..1a8c940 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1456,9 +1456,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
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
@@ -1467,10 +1468,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
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
1.6.3

