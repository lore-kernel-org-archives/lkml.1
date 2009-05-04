Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZEDIPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZEDIPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZEDILX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:11:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:41059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZEDILV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:11:21 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] ide-tape: don't initialize rq->sector for rw requests
Date: Mon,  4 May 2009 16:58:38 +0900
Message-Id: <1241423927-11871-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 07:59:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->sector is set to the tape->first_frame but it's never actually
used and not even in the correct unit (512 byte sectors).  Don't set
it.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 8dfc688..7149224 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -892,7 +892,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
-	rq->sector = tape->first_frame;
 
 	if (size) {
 		ret = blk_rq_map_kern(drive->queue, rq, tape->buf, size,
-- 
1.6.0.2

