Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZD2JTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZD2JTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZD2JSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:18:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:56405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZD2JSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:18:32 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com,
       jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] ide-tape: don't initialize rq->sector for rw requests
Date: Wed, 29 Apr 2009 18:13:40 +0900
Message-Id: <1240996428-10159-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:14:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->sector is set to the tape->first_frame but it's never actually
used and not even in the correct unit (512 byte sectors).  Don't set
it.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
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

