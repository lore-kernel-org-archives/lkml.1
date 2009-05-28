Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZE1Kh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZE1Kh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZE1Khv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:37:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46974 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZE1Khv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:37:51 -0400
Date: Thu, 28 May 2009 11:37:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Miller <davem@davemloft.net>
Cc: r.schwebel@pengutronix.de, scottwood@freescale.com,
       grant.likely@secretlab.ca, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com, timur@freescale.com, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528103745.GA19523@sirena.org.uk>
References: <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de> <20090527.171525.204909140.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.171525.204909140.davem@davemloft.net>
X-Cookie: Vitamin C deficiency is apauling.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:15:25PM -0700, David Miller wrote:
> From: Robert Schwebel <r.schwebel@pengutronix.de>

> > It works badly for corner cases, and embedded land is full
> > of it. The effort to get the oftree stuff right is often more than a
> > magnitude of order higher than the effort for the actual functionality.
> > That should be an alarm sign that something is wrong.

> And here you speak about the negatives purely in generalities that
> cannot be discussed concretely.

> And, sadly, I think this is on purpose.

A concrete example that was mentioned elsewhere in the thread is audio
subsystems.  The audio subsystem for an embedded system will contain
multiple chips - a mobile phone could have the CPU, an audio CODEC,
bluetooth and GSM for example.  These will be interconnected by a
combination of analogue and digital links.  The digital links consist of
six wires (data, sync clock and bit clock for each of transmit and
recieve), some of which may be tied together in hardware.  Some of these
links may be shared either with switches or using TDM.  The devices will
also have master clocks from various sources and will often have PLLs or
FLLs able to generate clocks if the inputs aren't directly usable.  Each
clock domain within the audio subsystem will need some level of
synchronisation of the clocks and there may be multiple clock domains
within the system.

In principle we could describe the links between the devices, provide
some additional use case based constraints then take this information
and figure out a suitable runtime configuration automatically; this is
probably the only viable OS neutral way of doing things.  In practice
we're nowhere near having a clock framework which is able to support
implementing this.

The current approach is to write custom code that knows a suitable way
to set things up in a given system (which is a much more tractable
problem).  The PowerPC people have mostly accepted using this approach
but they're really not happy with it and it's been difficult to get the
general community understanding that it's hard to cope with this in the
device tree.
