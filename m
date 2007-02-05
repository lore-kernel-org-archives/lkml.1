Return-Path: <linux-kernel-owner+w=401wt.eu-S965092AbXBEX2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbXBEX2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXBEX2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:28:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:7638 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbXBEX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=rsbTcCEF0x/yrU68NDmwrbxDcDDIuzUJaluY6JRu+qdwtvLpPqd8BpBzGyK9RGrO+aRKm9b6f12jukZzBcOncQwcvXAyJvXuYXUCHKwtMnlGjAPgLMIBqm7m20lZq4hAwn+grwVtWtxExlqotTeZtYt/uumuKajtx+994Ne99aQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][5/5] floppy.c: Fix device_create_file() warning
Date: Tue, 6 Feb 2007 00:30:33 +0100
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702060030.33671.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the warning 
  warning: ignoring return value of `device_create_file', declared with attribute warn_unused_result
in function `floppy_init'. It does this by checking the return value and 
printing a warning message in case of no success.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 floppy.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.20/drivers/block/floppy.c.patch4	2007-02-05 23:22:26.000000000 +0100
+++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:32:42.000000000 +0100
@@ -4302,7 +4302,12 @@
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



