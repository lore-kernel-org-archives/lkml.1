Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZHCLLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZHCLLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZHCLLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:11:24 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:63484 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZHCLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:11:23 -0400
Date: Mon, 3 Aug 2009 12:10:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090803111052.GA17501@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090722151744.fffd7bf5.akpm@linux-foundation.org> <20090728222334.0c543c47@mjolnir.ossman.eu> <20090731122623.254fd0f1@mjolnir.ossman.eu> <20090731105407.GA31900@console-pimps.org> <20090803123429.390a636f@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803123429.390a636f@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 12:34:29PM +0200, Pierre Ossman wrote:
> On Fri, 31 Jul 2009 11:54:07 +0100
> Matt Fleming <matt@console-pimps.org> wrote:
> 
> > On Fri, Jul 31, 2009 at 12:26:23PM +0200, Pierre Ossman wrote:
> > > 
> > > [PATCH 0/32] mmc and omap_hsmmc patches
> > > http://marc.info/?t=124722953900010&r=1&w=2
> > > 
> > > I haven't looked through these at all. The ones affecting the core
> > > probably need some thorough reviews.
> > > 
> > > I did notice the patch to say which cards a controller supports though,
> > > and I'm very sceptical about that one. The scanning process should work
> > > anyway, and the performance impact should be negligible as it is only
> > > on init. So that patch only adds complexity and confusion IMO.
> > > 
> > 
> > How much complexity does it really add? Surely it's better to give the
> > host controller driver writers the ability to not entertain supporting
> > some cards if they cannot be used? If they want to avoid the scanning
> > process for certain cards, why not let them?
> > 
> 
> Let's look at the pros and cons of this:
> 
> Con:
> 
>  - The scanning code gets less clear as you increase the number of
>    possible paths through it.
> 

Yes, it does but the function is only small. It's not that much more
complexity. And there's a trade off here between the added complexity
and the shorter initialisation time for cards. Running initialisation
functions on cards that don't need it just seems pointless.

>  - Different systems will have different init sequences, possibly
>    provoking bugs in the cards.
> 

Good. I'd like to know about bugs in the cards so that we can fix/work
around any issues. This seems like a pretty weak argument against the
change to me.

>  - Host driver writers now have more capability bits they have to
>    consider. And these might be less than obvious since SD/MMC/SDIO are
>    normally compatible so these bits seem useless.
> 

Yes, but they also have the flexibility to more clearly describe their
host controllers. Besides, any new host controller driver will likely
just copy one of the older drivers (which I updated) anyway.

>  - With the current logic (which was better in the first version),
>    "normal" drivers will have to explicitly state that they work as
>    intended by setting all bits.
> 

I thought that the way I wrote the patch was more natural (which was why
I rewrote Adrian's to begin with), but if you think the original was
clearer I've no issue with pushing that patch through instead.

> Pro:
> 
>  - A slightly reduced scanning time.
> 
> 
> I simply don't see it as being worth it. Linux patches generally need
> to provide the answer to "Why?", not just be able to avoid "Why not?".
> 

That's not at all what I said, I have provided the why (and so have you
by noting the Pro above). 


