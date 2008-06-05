Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbYFESb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbYFESb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYFESbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:31:49 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24772 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755612AbYFESbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:31:48 -0400
Date: Thu, 5 Jun 2008 22:31:46 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi
	driver
Message-ID: <20080605183146.GA29092@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080605161624.GA517@polina.dev.rtsoft.ru> <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com> <20080605172723.GA14514@polina.dev.rtsoft.ru> <fa686aa40806051036x22cd6a2bkc58650f5e69960fe@mail.gmail.com> <20080605180058.GA21429@polina.dev.rtsoft.ru> <fa686aa40806051118y39cbf14fye5268c819d4bbbfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40806051118y39cbf14fye5268c819d4bbbfc@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 12:18:56PM -0600, Grant Likely wrote:
> On Thu, Jun 5, 2008 at 12:00 PM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > On Thu, Jun 05, 2008 at 11:36:09AM -0600, Grant Likely wrote:
> >> On Thu, Jun 5, 2008 at 11:27 AM, Anton Vorontsov
> >> <avorontsov@ru.mvista.com> wrote:
> >> > Well, I mentioned the usb_add_hcd()-alike approach for the mmc_spi
> >> > host... The absence of enthusiasm I equaled to "no".
> >> >
> >> > Heh.
> >>
> >> I'm allergic to USB HCD code; I was probably having convulsions under my desk.
> >
> > :-)
> >
> > Ok, I also mentioned drivers/ata/pata_of_platform.c (OF version is using
> > common code from drivers/ata/pata_platform.c).
> >
> > Please look there, and tell me if this is what you have in mind. (ignore
> > _probe in the __pata_platform_probe name. Imagine
> > pata_platform_add_controller or something).
> 
> Yes, I like that.  I've done something very similar for drivers with
> both of and non-of bindings.  For another example, this time all
> contained within a single .c file, see drivers/video/xilinxfb.c

Ok, great. As I said previously, this is quite easy to do.

> >> > p.s.
> >> > Btw, you forgot another downside of v2 approach: struct spi_driver
> >> > duplication... Not sure if everyone will be happy about it.
> >> >
> >> > Though, v2 is only version where we can make modular OF_MMC_SPI.
> >>
> >> I think we've got our wires crossed.  I'm not referring to the option
> >> of an of_mmc_spi driver registering an mmc_spi device (which can then
> >> be probed by the mmc_spi_driver).
> >
> > I'm not refrering to this option either.
> 
> Okay, I'm confused then.  Where is the duplication of struct spi_driver?

Here it is http://lkml.org/lkml/2008/5/23/299
+ static struct spi_driver of_mmc_spi_driver = {

And here http://lkml.org/lkml/2008/5/24/153 David Brownell says:
> The only thing that looks odd to me about this is that the wrapper
> is a spi_device rather than an of_device.  To me it makes more sense
> to just have an of_device setting up the right spi_device.  (Though
> maybe I missed some discussion about why that can't work.)

^^^ That reminds me v1.

Here http://lkml.org/lkml/2008/5/25/5 you answered though, but there
was no bottom line.

I hope the bottom line is that we're now all happy to create another
spi_driver to handle "OF MMC-o-SPI" devices..?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
