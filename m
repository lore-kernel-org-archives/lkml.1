Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYBDNou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYBDNou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYBDNmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:27420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbYBDNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=hQrQcDXVDMK2tMc31T5Yfg5dA4aQA/ZFdVUKgBBE0lEzdXHhLDIfyLJR2y5lkCwkAEwxQhu8uwUno6ODhZ3ZMBEWl/c68pmLIVRUtbAsrt1JBwP2Aa+zv3kV2H26xnh0gbHdSOz/Gb/R5fmLNXw6XDlLLtjDrjF5nwK/r8Ps4k8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 15/22] ide-tape: remove unused "length" arg from idetape_create_read_buffer_cmd()
Date: Mon,  4 Feb 2008 14:40:33 +0100
Message-Id: <1202132440-26648-16-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a80f8d9..342ec50 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1468,7 +1468,8 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
-static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
+		idetape_pc_t *pc, struct idetape_bh *bh)
 {
 	int size = 32768;
 	struct idetape_bh *p = bh;
@@ -1486,7 +1487,8 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 		atomic_set(&p->b_count, 0);
 		p = p->b_reqnext;
 	}
-	pc->request_transfer = pc->buffer_size = size;
+	pc->request_transfer = size;
+	pc->buffer_size = size;
 }
 
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
@@ -1607,7 +1609,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		if (!pc)
 			goto err;
 
-		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors,
+		idetape_create_read_buffer_cmd(tape, pc,
 				(struct idetape_bh *)rq->special);
 		goto out;
 	}
-- 
1.5.3.7

