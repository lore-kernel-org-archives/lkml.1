Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGXWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGXWbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZGXWbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:31:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbZGXWba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:31:30 -0400
Date: Fri, 24 Jul 2009 15:29:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: ohad@bencohen.org, ian@mnementh.co.uk, pierre@ossman.eu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       nico@cam.org, nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com,
       tony@atomide.com, david-b@pacbell.net, manuel.lauss@gmail.com,
       mirq-linux@rere.qmqm.pl, ppisa@pikron.com, jarkko.lavinen@nokia.com,
       ben@fluff.org, saschasommer@freenet.de, avorontsov@ru.mvista.com,
       oakad@yahoo.com, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-Id: <20090724152944.51402e87.akpm@linux-foundation.org>
In-Reply-To: <20090723135209.GD6570@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
	<bd5b16740907222350w54ca7b21w6b47ed94c1d7d16e@mail.gmail.com>
	<20090723135209.GD6570@console-pimps.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 14:52:09 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Thu, Jul 23, 2009 at 09:50:03AM +0300, Ohad Ben-Cohen wrote:
> > Hi Andrew,
> > 
> > On Thu, Jul 23, 2009 at 9:22 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > > I actually already have a little pile of MMC things queued:
> > 
> > Please also consider queuing up the attached patch as well.
> > 
> > The patch is removing the current SDIO cards 1.8V limit, which is
> > needed for embedded
> > SDIO devices like TI 127x WLAN devices (with 1.8V MMC controllers like we
> > have on the ZOOM2 boards for example).
> > 
> > Thank you,
> > Ohad.
> 
> > From f9ba45b537dd12fc09443ee29c48860665f8ac82 Mon Sep 17 00:00:00 2001
> > From: Ohad Ben-Cohen <ohad@bencohen.org>
> > Date: Wed, 15 Jul 2009 09:21:41 +0300
> > Subject: [PATCH] sdio: do not ignore MMC_VDD_165_195
> > 
> > This is needed for 1.8V embedded SDIO devices and supporting host controllers
> > (e.g. TI 127x and ZOOM2 boards)
> > 
> > Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
> > ---
> >  drivers/mmc/core/sdio.c |    7 -------
> >  1 files changed, 0 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> > index fb99ccf..6f221dc 100644
> > --- a/drivers/mmc/core/sdio.c
> > +++ b/drivers/mmc/core/sdio.c
> > @@ -275,13 +275,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
> >  		ocr &= ~0x7F;
> >  	}
> >  
> > -	if (ocr & MMC_VDD_165_195) {
> > -		printk(KERN_WARNING "%s: SDIO card claims to support the "
> > -		       "incompletely defined 'low voltage range'. This "
> > -		       "will be ignored.\n", mmc_hostname(host));
> > -		ocr &= ~MMC_VDD_165_195;
> > -	}
> > -
> >  	host->ocr = mmc_select_voltage(host, ocr);
> >  
> >  	/*
> > -- 
> > 1.5.4.3
> > 
> 
> Looks OK to me, I'm unaware of a reason to not allow a card to use
> MMC_VDD_165_195 if that's what it wants.
> 

Yes, that code was there from day #1, via Pierre's original commit.  There
is no indication in either the code comments or the changelog why it was done
this way.

Other ways of finding out why this code is there include:

a) search the mailing list for review discussion.  I can't find it
   in my lkml archive.

b) ask Pierre :)
