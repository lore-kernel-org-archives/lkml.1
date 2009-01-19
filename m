Return-Path: <linux-kernel-owner+w=401wt.eu-S1761113AbZASNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113AbZASNER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbZASNDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:03:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:62304 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760780AbZASNDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CN6mknnb78hzpaFkoPs+2DU9Cjpuww0iRysIQUqyWrnZMG7BK1nuzqW6ExdHXyNQEJ
         7FaLIQgYs4bBiqnqGt94o2farGrc3khVnmrfloass0YiIdwjRdJI27EvO5fRcM74wfmL
         NwHW7h59dQBlm9omRPgA0DkxOSuK0PuT1u44w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:29 +0100
Message-Id: <20090119130329.24745.71440.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] ide: fix printk() levels in [atapi_]reset_pollfunc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix printk() levels in [atapi_]reset_pollfunc()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -549,7 +549,7 @@ static ide_startstop_t atapi_reset_pollf
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
-		printk("%s: ATAPI reset complete\n", drive->name);
+		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
@@ -558,8 +558,8 @@ static ide_startstop_t atapi_reset_pollf
 		}
 		/* end of polling */
 		hwif->polling = 0;
-		printk("%s: ATAPI reset timed-out, status=0x%02x\n",
-				drive->name, stat);
+		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
+			drive->name, stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
@@ -618,7 +618,8 @@ static ide_startstop_t reset_pollfunc (i
 			/* continue polling */
 			return ide_started;
 		}
-		printk("%s: reset timed-out, status=0x%02x\n", hwif->name, tmp);
+		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
+			hwif->name, tmp);
 		drive->failures++;
 		err = -EIO;
 	} else  {
