Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774Ab0AVVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0AVVv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707Ab0AVVvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:51:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46875 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab0AVVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:51:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vT8P5vGm0HCs1uEd+mYS9n6A1tLHu6Dpgr7lbdFurnG3/GUd5l64+MzPC7QjBApSvI
         /8TmcIh7/a7VgCZLNz4DKuRgpuLSAbym6wgGRjMMK+75TRPs2YOXRiV3Q0NRLJ+6Ftd+
         Z+w55M0F4Sa0ieSRd9uM0dms8GD9Q5d6y1+84=
Subject: Re: [PATCH 3/4] MTD: blkdevs: make hotplug work
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264175974.4494.4.camel@localhost>
References: <1264174316.24012.17.camel@maxim-laptop>
	 <1264174506.24012.21.camel@maxim-laptop>
	 <1264175974.4494.4.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 23:51:17 +0200
Message-ID: <1264197077.2824.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 17:59 +0200, Artem Bityutskiy wrote: 
> On Fri, 2010-01-22 at 17:35 +0200, Maxim Levitsky wrote:
> > >From 368127067f4d39ba89096e4a5cb3be2dee361bad Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 22 Jan 2010 15:00:55 +0200
> > Subject: [PATCH 3/4] MTD: blkdevs: make hotplug work
> > 
> > This changes the blkdev common module for translation layers
> > to survive when underlying mtd device disappears.
> > 
> > To do so the following conceptual changes were made:
> > 
> > * disk queue and thread are now one per mtd device
> >  This was it is easy to flush and destroy the queue
> > 
> > * the struct mtd_blktrans_dev will now be freed automaticly when last user
> >  of the device quits.
> >  All existing translation layers are adjusted
> > 
> > * ->open and release function of the translation layer will never be called
> >  twise or more in the row.
> >  This makes code simplier.
> >  Also the ->release will be called just before mtd device disappears
> >  This and above is the only visable changes on the outside.
> > 
> > Tested with mtdblock, ssfdc and my own sm_ftl on top of physicly hotplugable
> > nand card.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> I'll try to find some time to review this later - I'm really busy
> lately. But please, split this huge patch on smaller pieces - this will
> help the reviewers a lot.
> 
Sure, but I afraid this won't be easy. To split the patch I will need
effectively to redo all the work from the beginning.
Isn't it possible just to review the mtd_blkdevs.c and blktrans.h as
if it was new driver?

This patch does touch all ftl drivers, but only removes the final free
of structure that holds or embeds the 'struct mtd_blktrans_dev'

Change in drivers/mtd/mtdcore.c is my mistake, this slipped from
previous patch, sorry.

Do you think its real to merge my work into 2.6.34 ?
What else should I do besides splitting this patch?

Best regards,
Maxim Levitsky






