Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZE0WYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZE0WYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZE0WYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:24:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59857 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZE0WYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:24:46 -0400
Date: Wed, 27 May 2009 23:24:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Message-ID: <20090527222420.GC5591@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <20090527163223.GE1970@sirena.org.uk> <9e4733910905271150q1d51538draa8d039c8b147c05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910905271150q1d51538draa8d039c8b147c05@mail.gmail.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:50:27PM -0400, Jon Smirl wrote:
> On Wed, May 27, 2009 at 12:32 PM, Mark Brown

> > This worries me too, my experiences with OF device tree handling for
> > ASoC have been pretty negative - but then audio is one of the worst
> > cases for handling within the device tree.

> ASoC is where I2C was a year ago. I2C had it's own module loading
> conventions. OF assumes the subsystem is going to follow the standard
> kernel module loading conventions. I2C has now been fixed to use the
> standard conventions and it happily works with OF now.

As I just said to Grant this is not the case any more, unless you are
using AC97.  You can instantiate all the component drivers for an ASoC
card via the normal device model methods, the overwhelming majority of
my ASoC work is done on systems that do exactly this.

> The fight with ASoC is that two different entities are trying to link
> the modules together - ASoC (machine drivers) and the device tree
> code. There should only be one system linking everything together.

That's not the fundamental problem that machine drivers solve, though
they do the basic tab A into slot B stuff too.  The biggest problem that
machine drivers solve is that they allow us to set up the clocks used in
the audio subsystem in a way that is appropriate for the system based on
how it's wired up and what it's supposed to do.  As I just said to Grant
any OS neutral expression of this configuration suitable for use in a
device tree would need to be able to provide some constraints and a wiring
diagram.  These would then be used together with constraints from the
current runtime configuration to calculate an actual clock configuration
for the system.

If we had a cross-platform clock framework which was capable of handling
this then producing a generic machine driver would be more tractable but
there's no visible prospect of that happening any time soon.

Please read back over the original soc-of-simple thread, it goes into
the problems in a bit more detail.

> But you want these ASoC machine drivers on ARM because ARM doesn't
> have device trees.

This is nothing to do with the device trees, as I believe I've mentioned
before the existing ARM equivalents of the device tree are exactly
equivalent to it for device loading as far as things outside arch/arm
are concerned.

> I2C had the same problem. I2C wanted everything loaded form machine
> drivers. The machine drivers are now optional. ASoC can be fixed in
> the same way.

It's very easy to say things like this but there's quite a way to go
before they can be delivered upon; if it were straightforward to handle
I'd expect that soc-of-simple would be able to cope with it.
