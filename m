Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYJaBYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYJaBYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJaBX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:23:58 -0400
Received: from ozlabs.org ([203.10.76.45]:40332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYJaBX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:23:57 -0400
Date: Fri, 31 Oct 2008 10:24:52 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH 1/3] powerpc: Add mmc-spi-slot bindings
Message-ID: <20081030232452.GA15089@yookeroo.seuss>
Mail-Followup-To: Anton Vorontsov <avorontsov@ru.mvista.com>,
	Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
	David Brownell <dbrownell@users.sourceforge.net>,
	linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru> <20081030195630.GA13640@oksana.dev.rtsoft.ru> <fa686aa40810301337p21ac8785gb74b12904bbd08e7@mail.gmail.com> <20081030230253.GA11765@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030230253.GA11765@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 02:02:53AM +0300, Anton Vorontsov wrote:
> On Thu, Oct 30, 2008 at 02:37:31PM -0600, Grant Likely wrote:
> [...]
> > > +- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
> > > +  Write-Protect GPIO.
> > 
> > I wonder if we're following the example of irq mappings too closely
> > for the gpios property.  I like the layout of the property
> > (<controller> <specifier>), but I think the 'gpios' name is getting
> > too overloaded.  In this case a single property 'gpios' is being used
> > to encode 2 unrelated bits of information; the write protect pin and
> > the card detect pins.
> > 
> > In this particular case I think it is better to use 2 properties in
> > this case; something like 'spi-writeprotect-gpio' and
> > 'spi-carddetect-gpio' using the same specifier format.  Doing so adds
> > a bit more clarity to the purpose of the properties.
> > 
> > I my mind I differentiate this from other examples (for instance a
> > series of CS pins) based on how closely related the pin functions are.
> >  So I would say for the following examples...
> > 1) GPIO data bus (SPI, MDIO and I2C are great examples); all pins must
> > be present - single gpio property
> > 2) This MMC case (pins are optional and unrelated); separate gpio properties
> > 3) LCD with backlight and contrast control pins; one gpio property for
> > backlight pins, one for constrast pins.
> > 
> > Thoughts?
> 
> It's pretty trivial to implement (of_get_named_gpio() -- could be just
> factored out of of_get_gpio()).
> 
> Though,
> 
> 1. The idea is quite extreme. It needs discussion, and furthermore,
>    we need to define when do we use gpios = <> and when something-gpio =
>    <>; We need to be consistent, and to be consistent, the rules should
>    be clear and written.
> 
> 2. We should think about it very very carefully. Do we want to lose the
>    track of gpios? For example, there are quite defined rules when (and
>    in what properties) you may encounter memory addresses, when and
>    where you can encounter interrupt specifiers. We do the same for
>    gpios, and so far it works great. We need to think about any possible
>    drawbacks of the scheme you purpose (we would never know where to
>    expect gpios - it isn't a problem per se, but maybe it could lead
>    to some problem in future? I don't know.)
> 
> Quite honestly I don't like the idea... maybe I just used to
> interrupts = <>, reg = <>, ranges = <>, interrupt-map = <> and so
> forth, and now my subconsciousness tells me "it's wrong to do
> something-interrupt = <> stuff." ;-)

Fwiw, I agree.  The current scheme works, adding new places to look
for gpio specifiers will just complexify things.  Long lists of gpios
may be somewhat awkward to work with, but I don't think it's
sufficiently bad to warrant another scheme.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
