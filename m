Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYFESBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYFESBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYFESBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:01:17 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24691 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754163AbYFESBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:01:02 -0400
Date: Thu, 5 Jun 2008 22:00:58 +0400
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
Message-ID: <20080605180058.GA21429@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080605161624.GA517@polina.dev.rtsoft.ru> <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com> <20080605172723.GA14514@polina.dev.rtsoft.ru> <fa686aa40806051036x22cd6a2bkc58650f5e69960fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40806051036x22cd6a2bkc58650f5e69960fe@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 11:36:09AM -0600, Grant Likely wrote:
> On Thu, Jun 5, 2008 at 11:27 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > On Thu, Jun 05, 2008 at 10:45:17AM -0600, Grant Likely wrote:
> >> On Thu, Jun 5, 2008 at 10:16 AM, Anton Vorontsov
> >> <avorontsov@ru.mvista.com> wrote:
> >> > Here is v3. I'm out of ideas if you won't like it. :-)
> >> >
> >> > v3:
> >> > - Now these bindings are using bus notifiers chain, thus we adhere to the
> >> >  spi bus.
> >> >
> >> >  By the way, this scheme (IMO) looks good for I2C devices which needs
> >> >  platform_data extracted from the device tree too (Cc'ing Jochen).
> >> >
> >> > - Plus changed the OF bindings themselves, implemented voltage-range
> >> >  property. (Pierre, please take a look at vddrange_to_ocrmask(). I
> >> >  wonder if you would like this in the MMC core instead, with a kernel
> >> >  doc, of course.)
> >> >
> >> > v2:
> >> > - Bindings were adhered to the MMC_SPI driver. Withdrawn by Pierre Ossman.
> >>
> >> Personally I think your v2 was better, and if I'm interpreting
> >> Pierre's comments correctly I think his main point is that instead of
> >> using the 'stock' probe/remove hooks for the spi mmc driver, the
> >> driver should be mildly reworked to provide a common block of code
> >> that can be used by both the OF and non-OF versions of the
> >> probe/remove routines.  I also think that is the way to go.
> >
> > Well, I mentioned the usb_add_hcd()-alike approach for the mmc_spi
> > host... The absence of enthusiasm I equaled to "no".
> >
> > Heh.
> 
> I'm allergic to USB HCD code; I was probably having convulsions under my desk.

:-)

Ok, I also mentioned drivers/ata/pata_of_platform.c (OF version is using
common code from drivers/ata/pata_platform.c).

Please look there, and tell me if this is what you have in mind. (ignore
_probe in the __pata_platform_probe name. Imagine
pata_platform_add_controller or something).

> > p.s.
> > Btw, you forgot another downside of v2 approach: struct spi_driver
> > duplication... Not sure if everyone will be happy about it.
> >
> > Though, v2 is only version where we can make modular OF_MMC_SPI.
> 
> I think we've got our wires crossed.  I'm not referring to the option
> of an of_mmc_spi driver registering an mmc_spi device (which can then
> be probed by the mmc_spi_driver).

I'm not refrering to this option either.

> I'm referring to refactoring the
> probe/remove code so that common stuff is callable by both the mmc_spi
> and of_mmc_spi drivers without the oddity of the of_mmc_spi probe hook
> calling the mmc_spi probe hook.

I understand this.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
