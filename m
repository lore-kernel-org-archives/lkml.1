Return-Path: <linux-kernel-owner+w=401wt.eu-S965368AbXBFF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965368AbXBFF7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbXBFF7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:59:34 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:33471 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965368AbXBFF7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:59:33 -0500
Date: Tue, 06 Feb 2007 00:59:13 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [PATCH][5/5] floppy.c: Fix device_create_file() warning
In-reply-to: <200702060030.33671.jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <200702060059.18345.gene.heskett@verizon.net>
Organization: Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200702060030.33671.jesper.juhl@gmail.com>
User-Agent: KMail/1.9.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 18:30, Jesper Juhl wrote:

And this is almost OT for this, but I'd like to interject here that in 
recent history, it has been very very difficult to properly access LSN0 
of a floppy.  Some formats, such as those laid down by a WD-1773 floppy 
controller, do indeed use a sector marking of '0' (zero) on all tracks.

This is akin to an old basic program that had a 'base' statement with an 
argument of zero or one.  We need, for legacy machines where a floppy 
disk sneakernet is in use, to maintain this "base 0" functionality in an 
easy to access format.  Ditto for sector sizes of 256 and even 128 bytes.

>This fixes the warning
>  warning: ignoring return value of `device_create_file', declared with
> attribute warn_unused_result in function `floppy_init'. It does this by
> checking the return value and printing a warning message in case of no
> success.
>
>
>Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>---
>
> floppy.c |    7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>--- linux-2.6.20/drivers/block/floppy.c.patch4	2007-02-05
> 23:22:26.000000000 +0100 +++
> linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:32:42.000000000 +0100
> @@ -4302,7 +4302,12 @@
> 		if (err)
> 			goto out_flush_work;
>
>-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
>+		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
>+		if (err)
>+			printk(KERN_WARNING "Unable to create sysfs attribute "
>+				"file for floppy device: %s\n",
>+				floppy_device[drive].name);
>+
> 		/* to be cleaned up... */
> 		disks[drive]->private_data = (void *)(long)drive;
> 		disks[drive]->queue = floppy_queue;
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Yahoo.com and AOL/TW attorneys please note, additions to the above
message by Gene Heskett are:
Copyright 2007 by Maurice Eugene Heskett, all rights reserved.
