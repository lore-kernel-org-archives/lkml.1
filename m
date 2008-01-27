Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYA0Iml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYA0Iml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYA0Im1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:42:27 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:48367 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750951AbYA0Im0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:42:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=1HaFRbuM1qVJAvfmWvRWMeSqIqvB1WthNGoAfODVXKLElixc+gImS4Fl1E+qiym6PvyCA+ER8YVJAOYEj3Q18enzMIYC2ly08VQkluJIF2QBFRTUV3Vslc78tKIR8tc09OqtVTyMsR5rvlBb/uYenuQMTcGiQXo9Lf22HQ6UHMM=  ;
X-YMail-OSG: LnEzX_8VM1nSnlTXvQWESWDq0HJ4uZuucHx7Qa6ZgmXnZ96HifRS_Phg7YpWRO182TvhE4rjnA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 2/32] ide-tape: remove dead code
Date: Sun, 27 Jan 2008 09:41:22 +0100
Message-Id: <1201423312-2460-3-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 552cfed..3bedeb8 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -784,21 +784,6 @@ typedef struct {
 	__u8	medium_type;		/* Medium Type */
 	__u8	dsp;			/* Device Specific Parameter */
 	__u8	bdl;			/* Block Descriptor Length */
-#if 0
-	/* data transfer page */
-	__u8	page_code	:6;
-	__u8	reserved0_6	:1;
-	__u8	ps		:1;	/* parameters saveable */
-	__u8	page_length;		/* page Length == 0x02 */
-	__u8	reserved2;
-	__u8	read32k		:1;	/* 32k blk size (data only) */
-	__u8	read32k5	:1;	/* 32.5k blk size (data&AUX) */
-	__u8	reserved3_23	:2;
-	__u8	write32k	:1;	/* 32k blk size (data only) */
-	__u8	write32k5	:1;	/* 32.5k blk size (data&AUX) */
-	__u8	reserved3_6	:1;
-	__u8	streaming	:1;	/* streaming mode enable */
-#endif
 } idetape_mode_parameter_header_t;
 
 /*
@@ -2006,12 +1991,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	u8 stat;
 
 #if IDETAPE_DEBUG_LOG
-#if 0
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape:  %d, "
-			"dev: %s, cmd: %ld, errors: %d\n",
-			 rq->rq_disk->disk_name, rq->cmd[0], rq->errors);
-#endif
 	if (tape->debug_level >= 2)
 		printk(KERN_INFO "ide-tape: sector: %ld, "
 			"nr_sectors: %ld, current_nr_sectors: %d\n",
@@ -2723,19 +2702,6 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-#if 0
-static void idetape_create_mode_select_cmd (idetape_pc_t *pc, int length)
-{
-	idetape_init_pc(pc);
-	set_bit(PC_WRITING, &pc->flags);
-	pc->c[0] = IDETAPE_MODE_SELECT_CMD;
-	pc->c[1] = 0x10;
-	put_unaligned(htons(length), (unsigned short *) &pc->c[3]);
-	pc->request_transfer = 255;
-	pc->callback = &idetape_pc_callback;
-}
-#endif
-
 static void idetape_create_erase_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-- 
1.5.3.7

