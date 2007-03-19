Return-Path: <linux-kernel-owner+w=401wt.eu-S965858AbXCSPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858AbXCSPLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965861AbXCSPLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:11:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:39115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965858AbXCSPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=rOKk7EAIsn6MOMGPrq8N+g78x0dRFCJ5kA3q6nM8eYom9NLYAzwLb2UmcVqNW2SG33teS7g/B58Qa7l+Q7KRj/VTk0N6TI+AHluWI9KaNN/yJY79Tfi1Vss2DLSFORSnHaWR9kCIulJ03CjvJdrGvcXzgLwJObc4gYY/BwpCdSU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Date: Mon, 19 Mar 2007 16:11:13 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703191611.13849.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    This fixes the warning
      warning: ignoring return value of `device_create_file', declared with attribute warn_unused_result in function `floppy_init'.
    It does this by checking the return value and printing a warning message in case of no success.
    
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 577c621..9d543f3 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
+		if (err)
+			printk(KERN_WARNING "Unable to create sysfs attribute "
+				"file for floppy device: %s\n", 
+				floppy_device[drive].name);
+
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->queue = floppy_queue;
