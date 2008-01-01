Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYAASXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYAASXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYAASWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:22:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:3001 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYAASWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ctLRJwA35lCDYABp0WjGqGvvZPMbT8MP+Lja3L8KhDrX0+LINgTJTQvGDkej4XoazQz4vESWKi3ldVSHECmIFaVIXIH709lA9HIie5cHGNLnSnlWP9+ZuaqJTDQkxgoVm4YKhVTuFLwwtKWDn0Cb8ZvwGl/WpY7ZKPZ9wlLkTyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
Date: Tue, 1 Jan 2008 19:33:43 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801011840.38757.bzolnier@gmail.com> <20080101175333.GA27566@does.not.exist>
In-Reply-To: <20080101175333.GA27566@does.not.exist>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801011933.43930.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 January 2008, Adrian Bunk wrote:
> On Tue, Jan 01, 2008 at 06:40:38PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > * Replace driver versions in comments by DRV_VERSION define.
> > 
> > * Add MODULE_VERSION(DRV_VERSION) to drivers defining DRV_VERSION.
> >...
> 
> Could you limit this to actively maintained version numbers and also 
> remove the others from .version, printk's,...?
> 
> An example:
> 
> > --- a/drivers/ide/legacy/umc8672.c
> > +++ b/drivers/ide/legacy/umc8672.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - *  linux/drivers/ide/legacy/umc8672.c		Version 0.05	Jul 31, 1996
> > + *  linux/drivers/ide/legacy/umc8672.c
> >   *
> >   *  Copyright (C) 1995-1996  Linus Torvalds & author (see below)
> >   */
> > @@ -53,6 +53,8 @@
> >  
> >  #include <asm/io.h>
> >  
> > +#define DRV_VERSION	"0.05"
> > +
> >  /*
> >   * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
> >   */
> > @@ -185,3 +187,4 @@ module_init(umc8672_init);
> >  MODULE_AUTHOR("Wolfram Podien");
> >  MODULE_DESCRIPTION("Support for UMC 8672 IDE chipset");
> >  MODULE_LICENSE("GPL");
> > +MODULE_VERSION(DRV_VERSION);
> >...
> 
> I do not see any value in printing a version number from 1996 (sic),
> and the driver has for sure changed without any update of the 
> version number.
> 
> For actively maintained version numbers (and even more when 
> distributions backport more recent versions of a driver) printing a 
> (maintained) driver version number makes sense, but otherwise the kernel 
> version contains more information and a stale version number only gives 
> the false impression the driver hadn't changed.

Good point.

On the second thought: maybe we will be better off with limiting
MODULE_VERSION() to the device drivers and the IDE core module for now,
and just removing all these private version numbers from host drivers
(with one or two exceptions they are not printed or exported currently,
moreover exceptions are the cases like stale version numbers from 199x)?

Bart
