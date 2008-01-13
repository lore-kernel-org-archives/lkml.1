Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYAMUYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYAMUYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYAMUWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:19 -0500
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:26451 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753612AbYAMUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=hzt8YQQJ54K9r7y8i574M6RPTpkv9kO2ZC1ggHEuDgEixj5uNns6XV34Qmq4UXOc+D4j9YBm8pLEalmkPYWxTFAakGV1CDXBfhOR1xUNlty3k8lpENCQZ3A2Rm/kp1Hx1sxSAX+hbyuYacFLA1TM7iKhZ2mczv6/yx43GmXUBt8=  ;
X-YMail-OSG: LlfiN1gVM1nL51NaCuMyZfq.1ofU5wu51FxE2M1SbSxrj.VWJ19lqPTnivhk.iSDyU_xADeqqg--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 7/12] ide-floppy: remove IDEFLOPPY_DEBUG_BUGS macro
Date: Sun, 13 Jan 2008 21:18:20 +0100
Message-Id: <1200255505-31418-8-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-7-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-7-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b826ac5..e7cc9dd 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -52,7 +52,6 @@
  */
 #define IDEFLOPPY_DEBUG_LOG		0
 #define IDEFLOPPY_DEBUG_INFO		0
-#define IDEFLOPPY_DEBUG_BUGS		1
 
 /* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
 #define IDEFLOPPY_DEBUG( fmt, args... )
@@ -280,13 +279,11 @@ static void idefloppy_discard_data (ide_drive_t *drive, unsigned int bcount)
 		(void) HWIF(drive)->INB(IDE_DATA_REG);
 }
 
-#if IDEFLOPPY_DEBUG_BUGS
-static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
+static void idefloppy_write_zeros(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		HWIF(drive)->OUTB(0, IDE_DATA_REG);
 }
-#endif /* IDEFLOPPY_DEBUG_BUGS */
 
 
 /*
@@ -382,12 +379,10 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
 
 	idefloppy_do_end_request(drive, 1, done >> 9);
 
-#if IDEFLOPPY_DEBUG_BUGS
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers, bcount == %d\n", drive->name, bcount);
 		idefloppy_write_zeros(drive, bcount);
 	}
-#endif
 }
 
 static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
-- 
1.5.3.7

