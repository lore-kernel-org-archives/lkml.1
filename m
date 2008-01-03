Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYACNZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYACNZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYACNX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:28 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:24653 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752853AbYACNXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=YqpOALXzTiNxR0CEvnid22r6QuhUgk4UU+LGRDwq2xjeVRqj/8r518P6w9efggw8ezxqwz3uX6U75wiBLUsAHxOScLaXE2tokBRruZ70uWu1UX4jMUnfwUbPCCMx6cfXgbjN0goiZyEiADai3uy5jakbypI/SdTDPUK4596/Ero=  ;
X-YMail-OSG: qfaiv5AVM1kTT9srP95nskzhN0CaLz_Qi8J48K.gqHUOCUF00dKnIjw8sQfSO9xdTID4wRmzYg--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 07/10] ide-floppy: remove unnecessary ->handler != NULL check
Date: Thu,  3 Jan 2008 14:20:06 +0100
Message-Id: <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This BUG_ON is unneeded since the ->handler != NULL check is performed in
ide_set_handler().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5d0fd1f..2c139e7 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -421,7 +421,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 					"to send us more data than expected "
 					"- discarding data\n");
 				idefloppy_discard_data(drive,bcount.all);
-				BUG_ON(HWGROUP(drive)->handler != NULL);
+
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
 						IDEFLOPPY_WAIT_CMD,
@@ -453,8 +453,6 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	pc->actually_transferred += bcount.all;
 	pc->current_position += bcount.all;
 
-	BUG_ON(HWGROUP(drive)->handler != NULL);
-
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	return ide_started;
@@ -482,7 +480,7 @@ static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 				"issuing a packet command\n");
 		return ide_do_reset(drive);
 	}
-	BUG_ON(HWGROUP(drive)->handler != NULL);
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	/* Send the actual packet */
@@ -537,7 +535,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
-	BUG_ON(HWGROUP(drive)->handler != NULL);
+
 	ide_set_handler(drive,
 	  &idefloppy_pc_intr,		/* service routine for packet command */
 	  floppy->ticks,		/* wait this long before "failing" */
-- 
1.5.3.7

