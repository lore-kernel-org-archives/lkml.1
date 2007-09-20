Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXITMxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXITMxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbXITMww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:52:52 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:44822 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbXITMwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:52:51 -0400
Date: Thu, 20 Sep 2007 13:52:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Antonino Daplas <adaplas@pol.net>, linux-fbdev-devel@lists.sourceforge.net,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/pmag-ba-fb.c: Improve diagnostics
In-Reply-To: <20070919172412.725508d0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0709201342160.30788@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709171736580.17606@blysk.ds.pg.gda.pl>
 <Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl>
 <20070919172412.725508d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Andrew Morton wrote:

> > patch-mips-2.6.23-rc5-20070904-pmag-ba-err-2
> > diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c
> > --- linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c	2007-02-21 05:56:47.000000000 +0000
> > +++ linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c	2007-09-18 10:56:51.000000000 +0000
> > @@ -147,16 +147,23 @@ static int __init pmagbafb_probe(struct 
> >  	resource_size_t start, len;
> >  	struct fb_info *info;
> >  	struct pmagbafb_par *par;
> > +	int err = 0;
> 
> This initialisation to zero is not good.
> 
> Because if some error-path code forgot to do `err = -EFOO' then probe()
> will return zero and the driver will leave things in half-initialised state
> and will then proceed as if things had succeeded.  It will crash.

 GCC used to complain: "`foo' might be used uninitialized..." and this is 
the usual cure; let me see if this not the case anymore (I have 4.1.2).

> So it's better to leave this local uninitialised, because we really want to
> get that compiler warning if someone forgot to set the return value.

 Yes of course, barring the issue mentioned.  Note the message above is 
not the same as: "`foo' is used uninitialized..." that would be reported 
in the case which you are concerned of.

> I made that change, but am too stupid to be able to work out how to create
> a config which will let me compile this thing.
> 
> akpm:/usr/src/25> grep PMAG arch/arm/configs/*
> akpm:/usr/src/25> 

 TURBOchannel is currently MIPS only:

$ grep PMAG arch/mips/configs/*
arch/mips/configs/decstation_defconfig:# CONFIG_FB_PMAG_AA is not set
arch/mips/configs/decstation_defconfig:CONFIG_FB_PMAG_BA=y
arch/mips/configs/decstation_defconfig:CONFIG_FB_PMAGB_B=y
$

 Thanks for your review.

  Maciej
