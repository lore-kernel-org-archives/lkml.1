Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbZE0Vjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbZE0Vjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760682AbZE0VjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:39:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34754 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbZE0VjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:39:06 -0400
Date: Wed, 27 May 2009 22:38:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Message-ID: <20090527213841.GB5591@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <20090527163223.GE1970@sirena.org.uk> <fa686aa40905271342v5bc51665tb9b5d92950a43b82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40905271342v5bc51665tb9b5d92950a43b82@mail.gmail.com>
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

On Wed, May 27, 2009 at 02:42:13PM -0600, Grant Likely wrote:
> On Wed, May 27, 2009 at 10:32 AM, Mark Brown

> > The handling of platform data is my main concern as someone working
> > primarily on platform independant drivers - function pointers are a
> > particular problem but the possibility of having to write code to
> > handle both OF and non-OF systems to cater for systems using both
> > approaches is also a concern for me.

> Having a hook function which generates a pdata structure from a device
> node on a per driver basis is a common approach.  Essentially, the
> hook becomes an addon to the driver which doesn't impact the driver as
> a whole.  i2c and SPI device tend to take this approach.

Yes, this is what I mean about doing it twice - you have to have the
regular platform data structure plus another function to map the
OpenFirmware data into it.  The fact that quite a few of the devices I
deal with want function pointers as platform data doesn't help here.

> > This worries me too, my experiences with OF device tree handling for
> > ASoC have been pretty negative - but then audio is one of the worst
> > cases for handling within the device tree.

> First steps are hard.  I2C and SPI work had similar groans and pains,
> and ASoC is considerably more complex.  In the end the stuff in
> drivers/of/* was added to handle the creation of i2c, spi and phy
> devices from data in the device tree.  It is a mechanism which seems
> to be working well.

Instantiating the devices is a solved problem - with the current code
you can load the drivers for all the various parts of the audio
subsystem via the standard device model with everything appearing on
whatever bus it normally should.  The only exception to that is AC97
(because it's a bit special and needs some general TLC).  Some more work
is needed on the core to fully take advantage of what this bought us but
as far as loading and initialising device drivers goes you should be
there already.

What's a really crippling problem for what people seem to want to do
with the device tree right now is expressing the clocking trees and
requirements for a non-trivial audio subsystem.  The current clock API
is quite a way off being able to cope with this at runtime and without
that the benefits of trying to put the data into device trees are
questionable - a plaform independant representation of this data most
likely needs us to be able to automatically configure the clock tree
based on a description of the interconnects and their constraints.
