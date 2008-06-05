Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYFER1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYFER1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYFER1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:27:25 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24582 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753416AbYFER1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:27:25 -0400
Date: Thu, 5 Jun 2008 21:27:23 +0400
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
Message-ID: <20080605172723.GA14514@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080605161624.GA517@polina.dev.rtsoft.ru> <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 10:45:17AM -0600, Grant Likely wrote:
> On Thu, Jun 5, 2008 at 10:16 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > Here is v3. I'm out of ideas if you won't like it. :-)
> >
> > v3:
> > - Now these bindings are using bus notifiers chain, thus we adhere to the
> >  spi bus.
> >
> >  By the way, this scheme (IMO) looks good for I2C devices which needs
> >  platform_data extracted from the device tree too (Cc'ing Jochen).
> >
> > - Plus changed the OF bindings themselves, implemented voltage-range
> >  property. (Pierre, please take a look at vddrange_to_ocrmask(). I
> >  wonder if you would like this in the MMC core instead, with a kernel
> >  doc, of course.)
> >
> > v2:
> > - Bindings were adhered to the MMC_SPI driver. Withdrawn by Pierre Ossman.
> 
> Personally I think your v2 was better, and if I'm interpreting
> Pierre's comments correctly I think his main point is that instead of
> using the 'stock' probe/remove hooks for the spi mmc driver, the
> driver should be mildly reworked to provide a common block of code
> that can be used by both the OF and non-OF versions of the
> probe/remove routines.  I also think that is the way to go.

Well, I mentioned the usb_add_hcd()-alike approach for the mmc_spi
host... The absence of enthusiasm I equaled to "no".

Heh.

p.s.
Btw, you forgot another downside of v2 approach: struct spi_driver
duplication... Not sure if everyone will be happy about it.

Though, v2 is only version where we can make modular OF_MMC_SPI.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
