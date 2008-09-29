Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYI2Gam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYI2Gam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYI2GaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:30:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYI2GaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Uy9MOVF6AHKG3YtbZciY3AIiMLbs3E/Ogi/HkJowZpnC5u5vB+mE+FQRKCi4ft7UsD
         7+j6raIxijMC3kI/7+f3UKupV9ecgUO+nmN3VGp8YYXYSUQuCD5/T6yxPQfo01iIdS/w
         dPZ5qo1Cge/Sio6CvW8JBAo3l8AfDyEizv+wQ=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/3] ide-cd: shorten ide_cd_request_sense_fixup's param list
Date: Mon, 29 Sep 2008 08:29:59 +0200
Message-Id: <1222669799-6565-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... since HWGROUP(drive)->rq points to the same rq as in the irq handler. While
at it, remove stale comment.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e41b94d..bf92cd6 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -843,12 +843,11 @@ static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 	rq->q->prep_rq_fn(rq->q, rq);
 }
 
-/*
- * All other packet commands.
- */
-static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive)
 {
 
+	struct request *rq = HWGROUP(drive)->rq;
+
 	ide_debug_log(IDE_DBG_FUNC, "Call %s, rq->cmd[0]: 0x%x\n",
 		      __func__, rq->cmd[0]);
 
@@ -1021,7 +1020,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			cdrom_end_request(drive, uptodate);
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
-			ide_cd_request_sense_fixup(drive, rq);
+			ide_cd_request_sense_fixup(drive);
 			/* complain if we still have data left to transfer */
 			uptodate = rq->data_len ? 0 : 1;
 		}
-- 
1.5.5.4

