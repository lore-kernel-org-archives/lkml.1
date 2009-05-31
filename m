Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZEaKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZEaKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZEaKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:53:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48473 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbZEaKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:53:48 -0400
Date: Sun, 31 May 2009 11:52:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090531105242.GE18650@n2100.arm.linux.org.uk>
References: <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com> <20090528124307.GN22742@pengutronix.de> <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain> <20090528150409.GO22742@pengutronix.de> <1243558274.17903.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243558274.17903.21.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 10:51:14AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-05-28 at 17:04 +0200, Sascha Hauer wrote:
> > 
> > We normally hide these subtle details behind a baseboard= kernel
> > parameter. I agree with you that it's far better to have a
> > standardized
> > way to specify this. For my taste the oftree is too bloated for this
> > purpose.
> 
> Define "bloated" ?
> 
> We got a lot of push back on powerpc initially with this exact same
> argument "too bloated" but that was never backed up with facts and
> numbers, and I would mostly say that nobody makes it anymore now
> that it's there and people use it.

It really depends how you look at it.

If you look at the amount of supporting code required for one platform
on ARM, it's typically fairly small - mostly just declaration of data
structures (platform devices, platform device data), and possibly a few
small functions to handle the quirkyness of the platform.  That's of the
order of a few K of data and code combined - that's on average about 4K.
Add in the SoC platform device declaration code, and maybe add another
10K.

So, about 14K of code and data.

The OF support code in drivers/of is about 3K.  The code posted at the
start of this thread I suspect will be about 4K or so, which gives us a
running total of maybe 7K.

What's now missing is conversion of drivers and the like to be DT
compatible, or creation of the platform devices to translate DT into
platform devices and their associated platform device data.  Plus
some way to handle the platforms quirks, which as discussed would be
hard to represent in DT.

So I suspect it's actually marginal whether DT turns out to be larger
than our current approach.  So I agree with BenH - I don't think there's
an argument to be made about 'bloat' here.

What /does/ concern me is what I percieve as the need to separate the
platform quirks from the description of the platform - so rather than
having a single file describing the entire platform (eg,
arch/arm/mach-pxa/lubbock.c) we would need:

- a file to create the DT information
- a separate .c file in the kernel containing code to handle the
  platforms quirks, or a bunch of new DT drivers to do the same
- ensure both DT and quirks are properly in-sync.

But... we need to see how Grant gets on with his PXA trial before we
can properly assess this.
