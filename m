Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYACNY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYACNY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYACNX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:26 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:35631 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752816AbYACNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=HthyRpD2ufOMZYf31X0R2nhnDCflsCuyNxQ9hj9h2JPY50Z5Xomu8HpbqKJtX+EuwXC+5QqyzRKRKP9dl3PdhtsHoiQ6GNu7qZmNcVjsDS1UFFTJe4IiKi9M7GWnxPr/DrbNTMhQzo9PClurZ0s6msGujpL0Prm7ur/7kB9EyLE=  ;
X-YMail-OSG: G_gJ9rMVM1k4SUryRAPY9z9VYZL4NlEGjiCX4aGoPdFgX5lzlsOW1TxdOPrTqO6uojbFda3nEA--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 08/10] ide-floppy: mv idefloppy_{should_,}report_error
Date: Thu,  3 Jan 2008 14:20:07 +0100
Message-Id: <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2c139e7..fd5fe7b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -544,7 +544,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 }
 
 /* Supresses error messages resulting from Medium not present */
-static inline int idefloppy_should_report_error(idefloppy_t *floppy)
+static inline int idefloppy_report_error(idefloppy_t *floppy)
 {
 	if (floppy->sense_key == 0x02 &&
 	    floppy->asc       == 0x3a &&
@@ -587,7 +587,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
 		 */
 		if (!test_bit(PC_ABORT, &pc->flags)) {
 			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags)) {
-				if (idefloppy_should_report_error(floppy))
+				if (idefloppy_report_error(floppy))
 					printk(KERN_ERR "ide-floppy: %s: I/O error, "
 					       "pc = %2x, key = %2x, "
 					       "asc = %2x, ascq = %2x\n",
@@ -809,7 +809,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc != NULL) {
-			if (idefloppy_should_report_error(floppy))
+			if (idefloppy_report_error(floppy))
 				printk(KERN_ERR "ide-floppy: %s: I/O error,"
 					" pc = %2x, key = %2x, asc = %2x,"
 					" ascq = %2x\n",
-- 
1.5.3.7

