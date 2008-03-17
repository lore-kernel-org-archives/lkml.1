Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYCQGlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYCQGlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYCQGld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:41:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:30085 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYCQGlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=dFaXiZL0KfCK8rZqlNRJjFYUoz0veeDm3ugCwgdak1cpMINUVuzSC0KDI2zIMxDsiP2Gmiz23eIQTL+4WnA7u4J6ZJZGuKWcUKfaS6H0j6QLBomjEx2y1Qn2ZbLbprv46IQcgfQgUXgnev0ep33hajdwnl4StJMpHy5PANROZto=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 01/17] ide-tape: remove unused parameter from idetape_copy_stage_to_user
Date: Mon, 17 Mar 2008 07:41:14 +0100
Message-Id: <1205736090-4435-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 86be926..b931547 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1619,7 +1619,7 @@ static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 }
 
 static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
-		idetape_stage_t *stage, int n)
+				      int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -2493,8 +2493,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	if (tape->merge_stage_size) {
 		actually_read = min((unsigned int)(tape->merge_stage_size),
 				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       actually_read))
+		if (idetape_copy_stage_to_user(tape, buf, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_size -= actually_read;
@@ -2504,8 +2503,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2516,8 +2514,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       temp))
+		if (idetape_copy_stage_to_user(tape, buf, temp))
 			ret = -EFAULT;
 		actually_read += temp;
 		tape->merge_stage_size = bytes_read-temp;
-- 
1.5.4.1

