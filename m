Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYERSoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYERSoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbYERSj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbYERSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DbPNBtCOBRz0xmXCPfkss8jVWKYhgzQbWTTxXBDXOuZXFh17uoTIxlzXb4RjWBvKIAtfSk/C+6PI9f17JoF2i6DfrYcHdCrSRgyuMuHLC4IN+sOG6PhpxesS/Obj+fqvvWFFYqn58bKHVfLICnwtNK2jbGW//MVVaOgDYIKevvk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:52 +0200
Message-Id: <20080518185652.5636.43332.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/40] ide-tape: make idetape_retry_pc() void
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idetape_retry_pc() always returns ide_stopped so make it void.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -696,7 +696,7 @@ static void idetape_queue_pc_head(ide_dr
  *	last packet command. We queue a request sense packet command in
  *	the head of the request list.
  */
-static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
+static void idetape_retry_pc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc;
@@ -708,7 +708,6 @@ static ide_startstop_t idetape_retry_pc 
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
-	return ide_stopped;
 }
 
 /*
@@ -784,7 +783,8 @@ static ide_startstop_t idetape_pc_intr(i
 					pc->c[0]);
 
 			/* Retry operation */
-			return idetape_retry_pc(drive);
+			idetape_retry_pc(drive);
+			return ide_stopped;
 		}
 		pc->error = 0;
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
@@ -1078,7 +1078,8 @@ static ide_startstop_t idetape_media_acc
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
-			return idetape_retry_pc(drive);
+			idetape_retry_pc(drive);
+			return ide_stopped;
 		}
 		pc->error = 0;
 		if (tape->failed_pc == pc)
