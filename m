Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbZE3J5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbZE3J5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZE3J5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:57:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:34672 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbZE3J5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:57:17 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, timur@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, scottwood@freescale.com,
       yuan-bo.ye@motorola.com, David Miller <davem@davemloft.net>,
       rmk@arm.linux.org.uk
In-Reply-To: <20090529123411.GB14650@rakim.wolfsonmicro.main>
References: <20090527234801.GP6805@pengutronix.de>
	 <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de>
	 <20090527.171525.204909140.davem@davemloft.net>
	 <20090528103745.GA19523@sirena.org.uk>
	 <fa686aa40905281532l76996593ocdc36760eb468e04@mail.gmail.com>
	 <20090529123411.GB14650@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Sat, 30 May 2009 19:52:46 +1000
Message-Id: <1243677166.440.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sure.  My only big concern with it is that it compeltely sidesteps
> clocking decisions so there's a lot of codecs it's not going to be
> immediately useful with and I don't have a clear idea how it could be
> extended to be so.  Most other things look like they can be added on
> fairly easily when required.

Regarding clocks ...

Paulus and I had a discussion the other day and he mentioned a very good
idea to represent the clock net in the device-tree.

Basically, do it just like the interrupts.

IE. A device would have a "clocks" property that contain a certain
amount of cells representing a clock source in a clock provider, itself
identified by a "clock-parent" property (default to the actual node
parent). Clock providers would have a #clock-cells to provide the number
of cells a in the "clocks" property for each clock source.

Actually, we could be a little bit smarter since clocks are more messy
than interrupts, and define "clocks" to be a serie of clock-parent
phandle and clock id within that parent. The clock id size is still
represented by the #clock-cells of the clock parent, but we avoid the
pitfall of the interrupt routing that makes it hard to connect to
multiple different PICs.

That would provide the routing, without actual values or capabilities of
each clock, that's orthogonal. But that would allow driver to easily
find their clock "provider" and we could thus provide some simple
infrastructure to register drivers or handlers to perform actions on
those clocks, such as refcounting users, etc...

It may also be useful to define properties in the clock controllers
themselves mapping clock IDs to actual frequencies or things like that
but I'm only half convinced here. IE. Let's start by defining the
-wiring- and leave the -values- (on,off, slewing, freq adjustement,
spreading) to an API between drivers and clock providers for now.

Maybe later with experience with can find good ways to extend the
device-tree representiation to provide actual clock settings and/or
tables.

Cheers,
Ben.


