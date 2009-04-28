Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZD1MU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZD1MU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZD1MUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:20:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbZD1MUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:20:17 -0400
Date: Tue, 28 Apr 2009 14:20:11 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the
	OpenCores SPI controller.
Message-ID: <20090428122011.GB6325@avionic-design.de>
References: <200904041227.54687.david-b@pacbell.net> <1240916464-4187-1-git-send-email-thierry.reding@avionic-design.de> <20090428111532.GA14422@avionic-design.de> <200904280458.23018.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200904280458.23018.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX18KHz5JeoKrpvQiMOyZyjEO5V7kwl1vTL4XD+t
 HoZJCUewOfIV5y+YndglT5PBQIzXM4TlDsIVBuNXAmZ7eUsI+R
 eMz0HYelmq3+hFiq0eJRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Brownell wrote:
> On Tuesday 28 April 2009, Thierry Reding wrote:
> > This second version is pretty much a rewrite.
> 
> That happens sometimes...
> 
> 
> > Some notes about the most 
> > important changes:
> > 
> >   * uses per-chip states to allow more slaves to use the controller
> >     concurrently
> >   * rejects invalid device configurations during setup
> >   * rejects invalid per-message and per-transfer options
> >   * queues messages so that they can be processed one after another
> >       - this also provides for a way to handle power-management
> >   * omits the spioc.h (and with it the platform data structure):
> >       - uses the platform_device.id for the bus number
> >       - always uses 8 chipselects because that's the maximum that the core
> >         supports
> 
> All that sounds good.
> 
>  
> > I couldn't really find a way to implement per-transfer overrides for the
> > word size because the controller simply has no concept of word sizes. Is it
> > in such cases still necessary to hardwire the word size to 8 bits?
> 
> Is this the http://www.opencores.org/?do=project&who=spi core?

Yes, it is.

> Its summary says "Variable length of transfer word up to 32 bits";
> does that mean "configurable when core is synthesized" instead of
> truly "variable"?

That summary seems out-dated. The variable length of transfer word is
actually the maximum length of a single transfer and is 128 bits in the
latest version. So you get 4 registers, each 32 bits wide into which you
program the data you want to transfer. Then you set the number of bits of
that transfer so the core knows which registers and what bits of those
registers to shift out serially.

I'm not sure whether this is supposed to be the same as the word size. If it
is it would mean that a single transfer can always only transfer one word.
Which is kind of inefficient, I would think.

Thierry

