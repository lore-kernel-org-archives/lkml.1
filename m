Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYCQGm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYCQGm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYCQGle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:41:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:30015 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYCQGlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=nVRHTb3oqrwc4c7X2HU2qBhzga/lxVyhVv/bnLVrrhYiuIgPbAtvUNPT7CrsyBU/2GP3MHdmiShG7Ea2ooTNzvR4taDGqpXPFVc/jEf8mCxwm9z+lufXmtC+pNRnXFXESJE1yOXbZN3hKze5LTUVuFsN/4zmIj205qZZl2iUAW4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/17] ide-tape: remove unused parameter from idetape_copy_stage_from_user
Date: Mon, 17 Mar 2008 07:41:15 +0100
Message-Id: <1205736090-4435-3-git-send-email-petkovbb@gmail.com>
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
index b931547..241f596 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1587,7 +1587,7 @@ abort:
 }
 
 static int idetape_copy_stage_from_user(idetape_tape_t *tape,
-		idetape_stage_t *stage, const char __user *buf, int n)
+					const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -2588,8 +2588,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		actually_written = min((unsigned int)
 				(tape->stage_size - tape->merge_stage_size),
 				(unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 actually_written))
+		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_size += actually_written;
@@ -2605,8 +2604,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	while (count >= tape->stage_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, buf, tape->stage_size))
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
@@ -2617,8 +2615,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 count))
+		if (idetape_copy_stage_from_user(tape, buf, count))
 			ret = -EFAULT;
 		tape->merge_stage_size += count;
 	}
-- 
1.5.4.1

