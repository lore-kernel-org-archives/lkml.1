Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXF0DSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXF0DSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXF0DSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:18:12 -0400
Received: from waste.org ([66.93.16.53]:59135 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbXF0DSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:18:12 -0400
Date: Tue, 26 Jun 2007 22:18:00 -0500
From: Matt Mackall <mpm@selenic.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070627031800.GJ11115@waste.org>
References: <200706241555.22957.mb@bu3sch.de> <200706261612.27184.mb@bu3sch.de> <20070626143237.GF11115@waste.org> <200706261645.24360.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706261645.24360.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:45:24PM +0200, Michael Buesch wrote:
> On Tuesday 26 June 2007 16:32:37 Matt Mackall wrote:
> > > No wait. You are missing the whole point of this
> > > quality category.
> > > The whole point of it is to prevent defaulting to a bad RNG, if
> > > there's a bad and a good one in a machine.
> > > Well, what's bad.
> > > It's easy. HWRNGs like the one in bcm43xx are bad.
> > > It's proprietary and nobody knows what it does (I guess
> > > it gathers the entropy from the network or something
> > > and hashes that in hardware).
> > > So such a device would be QUAL_LOW.
> > 
> > If it's gathering its entropy from the network, it is not a QUAL_LOW
> > RNG because it is not a hardware random number generator at all!
> > 
> > Such a device is QUAL_PSEUDO or QUAL_UNKNOWN. If it's known or
> > suspected to be bogus, it should be so marked. 
> 
> No, it should not be marked pseudo. It _is_ a RNG in hardware.

Again, if it's not using an underlying physical process that's
unpredictable, it does not deserve to be called a real HWRNG. It's no
better than the software PRNG in the kernel at that point.

If you have a reasonable suspicion that this is the case with the BCM
part, then you should so mark it.

> Where it gets its entropy from is unknown. (I'm just guessing
> around).
> PSEUDO is for example for entropy gathered from hardware sensors.

Not sure what this means. Some hardware sensors are quite good sources
of noise. What gets you into trouble is when the sources are either
predictable (ie heavily correlated with fixed-frequency crosstalk),
observable (ie wireless traffic), or controllable (ie wireless traffic).

> > Once you've merged your LOW class with PSEUDO, you're left with a
> > meaningless, unquantifiable distinction between NORMAL and HIGH.
> 
> No, that's not true. I explained the difference to you and it's even
> explained in the kdoc help text. Re-read it, please.
> HIGH is for seperate dedicated extension devices that you buy and
> stick into your machine. So it would default to that, as you want
> to use that by default (why would you otherwise stick it in).

I do not believe there exist devices that deserve to be classified as
"HIGH". Any device that makes this claim probably instead deserves to
be classified as "SNAKE OIL". Making a high-quality HWRNG is easy, and
cheap (>$.05), and very hard to improve on except by upping the
bandwidth. Anyone who tells you that their HWRNG is significantly or
even measurably better than the one in, say, VIA Padlock, in any
dimension except for speed, they are almost certainly LYING.

Given that, I'd really rather not create an opportunity for such snake
oil salesmen to claim to be "the only Linux-supported RNG to use
QUAL_HIGH" or some such bullshit.

> To say it again: It all is _just_ for defining a sane _default_
> policy. That's all.
> Currently the policy is: "Select whatever comes first", which is
> random. So it could select crap (bcm43xx) over not-so-crap (in-CPU-RNG).

That's perfectly reasonable. And all I'm saying is please have only
two levels: CRAP and NOTCRAP. Anything else just muddies the waters.

-- 
Mathematics is the supreme nostalgia of our time.
