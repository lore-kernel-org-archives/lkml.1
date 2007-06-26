Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbXFZOc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbXFZOc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXFZOct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:32:49 -0400
Received: from waste.org ([66.93.16.53]:35513 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbXFZOcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:32:48 -0400
Date: Tue, 26 Jun 2007 09:32:37 -0500
From: Matt Mackall <mpm@selenic.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070626143237.GF11115@waste.org>
References: <200706241555.22957.mb@bu3sch.de> <20070626031340.GQ11166@waste.org> <200706261612.27184.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706261612.27184.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:12:26PM +0200, Michael Buesch wrote:
> On Tuesday 26 June 2007 05:13:41 Matt Mackall wrote:
> > On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> > > This adds quality categories for hardware random number generators.
> > > 
> > ...
> > > +
> > > +/**
> > > + * enum hwrng_quality - Quality identifier for RNG hardware
> > > + * @HWRNG_QUAL_HIGH:	High quality RNG. Higher quality than
> > > + * 			what is found on the usual PC mainboards.
> > > + * 			Use that for special dedicated RNG
> > > + * 			extension boards.
> > > + * @HWRNG_QUAL_NORMAL:	PC-onboard-RNG devices.
> > > + * @HWRNG_QUAL_LOW:	Low quality RNG devices. Use this for
> > > + * 			devices which gather the entropy from possibly
> > > + * 			bad sources, like the network.
> > > + * @HWRNG_QUAL_PSEUDO:	Pseudo RNG device. Use this for devices
> > > + * 			which are not RNG devices by definition, but
> > > + * 			could be used as such. For example various
> > > + * 			hardware sensors, like a motion sensor.
> > > + */
> > 
> > I don't think these definitions are very useful.
> ...
> 
> No wait. You are missing the whole point of this
> quality category.
> The whole point of it is to prevent defaulting to a bad RNG, if
> there's a bad and a good one in a machine.
> Well, what's bad.
> It's easy. HWRNGs like the one in bcm43xx are bad.
> It's proprietary and nobody knows what it does (I guess
> it gathers the entropy from the network or something
> and hashes that in hardware).
> So such a device would be QUAL_LOW.

If it's gathering its entropy from the network, it is not a QUAL_LOW
RNG because it is not a hardware random number generator at all!

Such a device is QUAL_PSEUDO or QUAL_UNKNOWN. If it's known or
suspected to be bogus, it should be so marked. 

Once you've merged your LOW class with PSEUDO, you're left with a
meaningless, unquantifiable distinction between NORMAL and HIGH.

So we're down to one bit distinguishing real RNGs from pseudo RNGs.

-- 
Mathematics is the supreme nostalgia of our time.
