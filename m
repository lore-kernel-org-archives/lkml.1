Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYESRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYESRJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYESRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:09:09 -0400
Received: from mout1.freenet.de ([195.4.92.91]:41429 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbYESRJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:09:07 -0400
Date: Mon, 19 May 2008 19:09:00 +0200
From: Gary Jennejohn <garyj@denx.de>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       fabrizio.garetto@gmail.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Message-ID: <20080519190900.01ec3b2a@peedub.jennejohn.org>
In-Reply-To: <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	<20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	<Pine.LNX.4.64.0805191446530.27140@axis700.grange>
	<fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
Reply-To: gary.jennejohn@freenet.de
Organization: DENX Softwre Engineering GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.14; amd64-portbld-freebsd8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 09:57:21 -0600
"Grant Likely" <grant.likely@secretlab.ca> wrote:

> On Mon, May 19, 2008 at 7:17 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 16 May 2008, Grant Likely wrote:
> >
> >> +    However, the binding does not attempt to define the specific method for
> >> +    assigning chip select numbers.  Since SPI chip select configuration is
> >> +    flexible and non-standardized, it is left out of this binding with the
> >> +    assumption that board specific platform code will be used to manage
> >> +    chip selects.  Individual drivers can define additional properties to
> >> +    support describing the chip select layout.
> >
> > Yes, this looks like a problem to me. This means, SPI devices will need
> > two bindings - OF and platform?... Maybe define an spi_chipselect
> > OF-binding?
> 
> Actually, spi devices have *neither*.  :-)  They bind to the SPI bus.
> Not the platform bus or of_platform bus.  But that is Linux internal
> details; this discussion is about device tree bindings.
> 
> Note that I did say that drivers can define additional properties for
> supporting chip select changes as needed.  I'm just not attempting to
> encode them into the formal binding.  There is simply just too many
> different ways to manipulate chip select signals and so I don't feel
> confident trying to define a *common* binding at this moment in time.
> At some point in the future when we have a number of examples to
> choose from then we can extend this binding with chip select related
> properties.
> 
> As for the Linux internals, the 5200 SPI bus driver that I posted
> exports a function that allows another driver to call in and
> manipulated the CS lines before the transfer.  It isn't the prettiest
> solution, but I'm not locked into the approach and that gives some
> time to consider cleaner interfaces.
> 

I sort of hesitate to hijack this thread, but since we're discussing SPI
and chip selects...

I have a driver for the SPI controller in the 440EPx.  This controller
is very simple and does not have any internal support for a chip select.
The controller seems to also be in the 440GR and 440EP, and may be in
other AMCC CPUs too.

All chip selects must be done using GPIO.  In fact, the board for which
I developed this driver, a modified sequoia, actually uses 2 chip selects.

My problem was, and is, that there's no generic GPIO support for powerpc.
At least, not that I'm aware of.  Please tell me if I'm wrong.

So the driver has great gobs of GPIO code in it, most of which I took
from u-boot.  The code is pretty generic, but some 440EPx-specific
stuff may have crept in without my being aware of it.

My real question is - should this code be in a platform-specific file
such as sequoia.c, which could result in lots of duplicated code, or is
it better to leave it in the driver for now until some day we hopefully
get generic GPIO support for powerpc?

I want to get this driver upstream ASAP.

---
Gary Jennejohn
*********************************************************************
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
*********************************************************************
