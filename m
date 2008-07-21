Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYGUVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYGUVXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYGUVW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:22:56 -0400
Received: from bu3sch.de ([62.75.166.246]:59291 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYGUVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:22:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Date: Mon, 21 Jul 2008 23:21:59 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Randy Dunlap <randy.dunlap@oracle.com>, gregkh <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807182201.33913.mb@bu3sch.de> <20080718151037.a54dec8a.randy.dunlap@oracle.com> <200807211341.35766.david-b@pacbell.net>
In-Reply-To: <200807211341.35766.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807212322.00025.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008 22:41:35 David Brownell wrote:
> So what this driver adds is mostly a userspace interface, yes?

Mostly. It also provides a simple platform device.

> If so, please refocus the descriptions a bit more on that;
> it's not actually a "GPIO based MMC/SD driver"; it's really
> a "Configfs creation interface for GPIO based MMC/SD".
> 
> 
> > > +	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u %u %u %u %u %u %u %u",
> 
> Kind of ugly, yes?  ;)

This is already gone.

> Please switch to the more conventional "MOSI" (Master Out, Slave In)
> and "MISO" (Master In, Slave Out).  That's unambiguous.  If you want
> to be a bit more clear you could say that MOSI goes to the MMC/SD
> card pin 2 (card data in), and MISO goes to MMC/SD card pin 7 (card
> data out).

Maybe.

> > > +	if (res < 8)
> > > +		pdata->p.no_spi_delay = 0; /* Default: Delay turned on */
> > > +	if (res < 7)
> > > +		pdata->p.max_bus_speed = 5000000; /* Default: 5Mhz */
> 

> So I'd default to leaving the delay off

How to?

> > > +	if (res < 6)
> > > +		pdata->p.mode = 0; /* Default: SPI mode 0 */
> 
> Don't need to do this.  The mmc_spi driver forces mode 0 in
> any case...

Where's that documented?

> > > +config GPIOMMC
> > > +	tristate "MMC/SD over GPIO-based SPI"
> 
> "Sysfs interface for ..."
> 
> Because we can already do MMC/SD over GPIO-SPI,
> without using this code.

This also adds a platform device interface for convenience
(as it also uses that internally).

> > > +config MMC_S3C
> > > +	tristate "Samsung S3C SD/MMC Card Interface support"
> > > +	depends on ARCH_S3C2410 && MMC
> 
> MMC_S3C doesn't belong in this patch...

Yeah that was a mismerge. You are commenting on an obsolete patch.

> > > + * @no_spi_delay: Do not use delays in the lowlevel SPI bitbanging code.
> > > + *                This is not standards compliant, but may be required for some
> > > + *                embedded machines to gain reasonable speed.
> 
> Rather than emphasize "not standards compliant", I'd instead emphasize that
> bitbanged SPI is so slow that you probably don't want to slow it down any
> more by additional delays between per-bit operations!

I'd say you cannot tell how fast the GPIOs are. They can be pretty fast
on a huge machine.

> Again, please don't promote a *SECOND* platform-device based mechanism

It is not a second mechanism, it is a mechanism on top of the first two
mechanisms.

> > > +Registering devices via platform-device
> > > +=======================================
> > > +
> > > +The platform-device interface is used for registering MMC/SD devices that are
> > > +part of the hardware platform. This is most useful only for embedded machines
> > > +with MMC/SD devices statically connected to the platform GPIO bus.
> 
> There is no "platform GPIO bus" ... 

hm??

> This is the interface I'd rather just not see exposed ...

People asked me to expose it. It was hidden in the first patch that
I submitted. I'm not going to change this just to see the next one
yelling "I want to see this interface in public" again.

> > > +Registering devices via sysfs
> > > +=============================
> 
> This is the interface I don't have any particular issues with.

Yeah, but it's gone. See updated patches.

-- 
Greetings Michael.
