Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYLPHia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYLPHia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYLPHg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:26 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33358 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYLPHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=uMs+vLru98URl3K4EiLgxd5UWQFStUbttgs7YzBsJzXW5bBeKq4Rwd9kIPIElz7CEy
         JjlbQDKVO7vsk9L4PZ3DM3olrb5PdTZ4YWAj77651gw8PWmcUT+ecSpKXUQMzIFs5LQj
         3pNHo3iIORVoY2WCNVFGsZ+sjujGQqlnkEfts=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 7/9] ide-atapi: use rq pointer directly instead of pc->rq deref
Date: Tue, 16 Dec 2008 08:36:07 +0100
Message-Id: <1229412969-3552-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 89ce8f0..e514b47 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -332,7 +332,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		    (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
 				printk(KERN_ERR "%s: DMA %s error\n",
-					drive->name, rq_data_dir(pc->rq)
+					drive->name, rq_data_dir(rq)
 						     ? "write" : "read");
 			drive->pc_flags |= PC_FLAG_DMA_ERROR;
 		} else {
@@ -361,7 +361,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			debug_log("%s: I/O error\n", drive->name);
 
 			if (drive->media != ide_tape)
-				pc->rq->errors++;
+				rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "%s: I/O error in request sense"
-- 
1.6.0.4

