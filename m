Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbYCAJIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbYCAJIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbYCAI7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:1512 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbYCAI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=bcT/aLQGQjuaPO5xOxrGhjADwhfUByGDgFiMEye81HyMg8GXlnQ/lJcsjOEn7Wj+eB1UIubo5yL5QG6fvNEEYgB/PlSchoZ8Flc+FNpRZkXHXN4cruFqZOpQRLNlhwpd6uCYSyJnArs3DpmOIC2Ww1K//+mYNZvRhAWwgSJ10B4=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 06/24] ide-tape: remove unused stage-parameter from idetape_copy_stage_to_user
Date: Sat,  1 Mar 2008 09:58:30 +0100
Message-Id: <1204361928-30229-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6bca29b..a54c1cb 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1717,7 +1717,7 @@ static int idetape_copy_stage_from_user(idetape_tape_t *tape,
 }
 
 static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
-		idetape_stage_t *stage, int n)
+				      int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -2576,8 +2576,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	if (tape->merge_stage_size) {
 		actually_read = min((unsigned int)(tape->merge_stage_size),
 				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       actually_read))
+		if (idetape_copy_stage_to_user(tape, buf, actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_size -= actually_read;
@@ -2587,8 +2586,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
-					       bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2599,8 +2597,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
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

