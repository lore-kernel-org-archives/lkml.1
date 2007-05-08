Return-Path: <linux-kernel-owner+w=401wt.eu-S967945AbXEHFYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967945AbXEHFYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967923AbXEHFYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:24:15 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:45040 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967911AbXEHFYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JyiCmUl3HiHJHH21Ulv1z8lW0poS7rkS9GwZUpO50mE/rVr6oCgbquA+KRXF2xZWbGlKl7sKBNXQzLOSEK3vaedDHe6P95VvKa2cPqFyCwh+pY+H+ItVX4XxcB8gbd9QkQBmolzkua2gNT2tjm+pBUgEfPeBHMeBv+U4yTbHV2s=
Message-ID: <8bd0f97a0705072224j1cc356ecn60184a232880bf8d@mail.gmail.com>
Date: Tue, 8 May 2007 01:24:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] adding bits_per_word to struct spi_board_info to mirror struct spi_device
Cc: spi-devel-general@lists.sourceforge.net, "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705072153.46411.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
	 <200704250813.30999.david-b@pacbell.net>
	 <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
	 <200705072153.46411.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, David Brownell <david-b@pacbell.net> wrote:
> On Monday 07 May 2007, Mike Frysinger wrote:
> > On 4/25/07, David Brownell <david-b@pacbell.net> wrote:
> > > On Wednesday 25 April 2007, Mike Frysinger wrote:
> > > > is there something obvious i'm missing ?  seems to me that if the
> > > > generic spi framework respects bits_per_word on a per-spi device
> > > > basis, then it should be exposed in the generic info structure so that
> > > > the setting can be tracked in the boards file ...
> > >
> > > The initial driver set didn't need it, that's all.  ISTR someone
> > > else pointed out this quirk, but never provided a patch to resolve
> > > the issue.
> >
> > so which direction should it be ?  or should it be both ? :)
>
> Add bits_per_word to spi_board_info, and have the device creation
> logic copy it into spi_device as it's created.

OK

> > Blackfin at the moment is doing DMA/bits_per_word setup in the boards
> > ... we could move these to the drivers and have each one just call
> > spi_setup() at init, or i could post a patch for the common framework
> > if you think that's an OK direction to [also] go ...
>
> I don't see what you're getting at here.  The SPI core doesn't
> do anything with DMA, beyond passing DMA addresses through when
> necessary.  (Needed to handle messages derived from scatterlists,
> since I don't want lower layers to know scatterlists, but otherwise
> uncommon.)

sorry, i didnt mean to confuse things ... i was referring to the only
things that we are configuring at the moment on a per-spi device basis
in Blackfin is bits_per_word and DMA status ... when i said posting a
patch for common framework, i was referring to just bits_per_word
-mike
