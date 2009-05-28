Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbZE1DGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbZE1DGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZE1DFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:05:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39474 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZE1DFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:05:46 -0400
Date: Thu, 28 May 2009 12:52:58 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jon Smirl <jonsmirl@gmail.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528025258.GB1464@yookeroo.seuss>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Janboe Ye <yuan-bo.ye@motorola.com>,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090527192116.GA31110@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:21:16PM +0100, Russell King - ARM Linux wrote:
> On Wed, May 27, 2009 at 03:13:55PM -0400, Jon Smirl wrote:
> > On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
> > > I'm not talking about platform specific code, I'm talking about code to
> > > retrieve information about a device from the device tree.  There would not
> > > be separate instances of this for "platforms X, Y and Z", just one
> > > of_platform binding in each driver.  It's no different than having a
> > > platform bus binding, except in the data structures used.
> > >
> > > But to restate, having external glue to create platform devices from the
> > > device tree is fine if that's what you want to do.  We used to do that, but
> > > it was a pain compared to keeping everything in one place.  Your experience
> > > may differ.
> > 
> > Could 'struct platform_device' and 'struct of_platform_device" be
> > unified into a single structure? It's personal preference whether the
> > internal representation of the hardware is done via a device tree or
> > snippets of platform code, but do we need to have to different device
> > types?
> 
> That's a damned good question - platform devices have been around since
> the dawn of the device model, so the real question which needs to be
> asked is: what was the reason that of_platform_device created rather
> than unifying it with the already provided platform_device ?
> 
> BTW, I can find no such struct "of_platform_device" in include/linux.
> Is it specific to each and every OF implementation?

They should be unified.  I believe the problem was at the time
of_platform devices came into existence there was no arch-specific
field in the device structure that could be used to hold a reference
to the devtree node.

Since then, the fiddliness of doing the conversion has always just
outweighed the impetus to do so.  The of_platform bus model is
conceptually completely broken, but in practice only slightly broken
for all common cases.

I've been meaning at several times to replace the of_platform bus
infrastructure with a system to traverse the OF tree and construct
platform devices (or other un-probeable bus devices, e.g. i2c) based
on a table of constructor functions.  It's just always been edged out
by other work.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
