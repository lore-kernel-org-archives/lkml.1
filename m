Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYHFQoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYHFQoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYHFQnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:43:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbYHFQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=iBefCgJp9xn0ViBSw48ECn/sHjHyvipqOAlUF+agmjOWouZmgTx/gCGnNB1JIa71KX
         ZfotnE9jRsxuK32sGK+uUMElp22wSkEzmM0313MITPwBsNX0GPUcGnVgOMwxicgLzFwN
         mXkHK9hux4rOJYnlc4WKgpx4L4qgwFjOK4bW4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide-floppy: remove needless parens
Date: Wed, 6 Aug 2008 18:37:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808061837.21240.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -738,7 +738,7 @@ static int idefloppy_get_sfrp_bit(ide_dr
 		return 1;
 
 	floppy->srfp = pc.buf[8 + 2] & 0x40;
-	return (0);
+	return 0;
 }
 
 /*
@@ -866,16 +866,17 @@ static int ide_floppy_get_format_capacit
 	int __user *argp;
 
 	if (get_user(u_array_size, arg))
-		return (-EFAULT);
+		return -EFAULT;
 
 	if (u_array_size <= 0)
-		return (-EINVAL);
+		return -EINVAL;
 
 	idefloppy_create_read_capacity_cmd(&pc);
 	if (idefloppy_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-		return (-EIO);
+		return -EIO;
 	}
+
 	header_len = pc.buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
@@ -897,19 +898,22 @@ static int ide_floppy_get_format_capacit
 		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
-			return(-EFAULT);
+			return -EFAULT;
+
 		++argp;
 
 		if (put_user(length, argp))
-			return (-EFAULT);
+			return -EFAULT;
+
 		++argp;
 
 		++u_index;
 	}
 
 	if (put_user(u_index, arg))
-		return (-EFAULT);
-	return (0);
+		return -EFAULT;
+
+	return 0;
 }
 
 /*
@@ -931,7 +935,7 @@ static int idefloppy_get_format_progress
 	if (floppy->srfp) {
 		idefloppy_create_request_sense_cmd(&pc);
 		if (idefloppy_queue_pc_tail(drive, &pc))
-			return (-EIO);
+			return -EIO;
 
 		if (floppy->sense_key == 2 &&
 		    floppy->asc == 4 &&
@@ -950,10 +954,11 @@ static int idefloppy_get_format_progress
 
 		progress_indication = ((stat & ATA_DSC) == 0) ? 0 : 0x10000;
 	}
+
 	if (put_user(progress_indication, arg))
-		return (-EFAULT);
+		return -EFAULT;
 
-	return (0);
+	return 0;
 }
 
 static sector_t idefloppy_capacity(ide_drive_t *drive)
