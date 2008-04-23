Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbYDWHCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbYDWHCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYDWHCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:02:34 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:63970 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbYDWHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fu1IWnhCnm2g+ur5hQSL/5/afNr/UcHhzLtutxkzxvuzcVYyQ2V3RgcXMy5QNKk9ARGzRMmTm39w8VGJrphKycHeDYDaIEJzPaX9DZECQgAYy4mxe32KrJHfmiic0ktQGALIDka2rdAZ0NwG6tcbZUPlVmrl/rwBxgWeD5A0Avw=
Message-ID: <38b2ab8a0804230002x4b626fa6p89fe940e8e0ff374@mail.gmail.com>
Date: Wed, 23 Apr 2008 09:02:33 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Disk geometry from /sys
Cc: "Seewer Philippe" <philippe.seewer@bfh.ch>, linux-kernel@vger.kernel.org
In-Reply-To: <480E6A35.4040108@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <480354C9.1050600@bfh.ch>
	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
	 <4805AF93.90209@bfh.ch>
	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca>
	 <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>
	 <480E6A35.4040108@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 12:44 AM, Mark Lord <lkml@rtr.ca> wrote:
> > On Fri, Apr 18, 2008 at 3:22 PM, Mark Lord <lkml@rtr.ca> wrote:
> >
> > >  That can sound a bit misleading.  The complete story, for ATA/SATA
> drives,
> > >  is that the disk has two geometries:  an internal physical one, with a
> > > fixed number of heads and cylinders, but variable sectors/track
> > >  (which normally varies by cylinder zone).
> > >
> > >  Software *never* sees or knows about that geometry, so ignore it.
> > >
> > >  The second geometry, is the one that the drive reports to software
> > >  as its "native" geometry.  This is what you see from "hdparm -I"
> > >  and friends, and this geometry is what has to be used by software
> > >  when using cylinder/head/sector (CHS) addressing for I/O operations.
> > >  The hardware interface has a limit of 4-bits for the head value,
> > >  so the maximum number of heads can never be more than 16.
> > >
> > >  Nobody uses CHS addressing for I/O operations, at least not on
> > >  any hardware newer than at least ten years old, so this geometry
> > >  is also unimportant for most uses.
> > >
> > >
> >
> > Is it because IDE drives support several IO operation modes ?
> >
>  ..
>
>  The earliest IDE drives for Compaq used only CHS sector addressing mode.
>
>  Within four years, though, all new drives had support for the more sensible
> linear block addressing (LBA) mode, as well.
>

My last question I promise ;)

If I'd like to take a look in the kernel code to see where the kernel
translates an offset
provided by sys_read into a LBA or CHS address, where should I go ?
drivers/block ?

Thanks !
-- 
Francis
