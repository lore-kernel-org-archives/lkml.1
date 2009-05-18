Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZERIea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZERIea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:34:16 -0400
Received: from trinity.fluff.org ([89.16.178.74]:51270 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZERIeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:34:16 -0400
Date: Mon, 18 May 2009 09:34:12 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, kyungmin.park@samsung.com
Subject: Re: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with missing MISO pin
Message-ID: <20090518083412.GA28648@trinity.fluff.org>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBF8C@bssrvexch01.BS.local> <20090507123157.GU32548@trinity.fluff.org> <000501c9d792$f8feb950$eafc2bf0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c9d792$f8feb950$eafc2bf0$%szyprowski@samsung.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 10:30:55AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On Thursday, May 07, 2009 2:32 PM Ben Dooks wrote:
> 
> > On Thu, May 07, 2009 at 02:24:11PM +0200, Marek Szyprowski wrote:
> > > There are some boards that do not strictly follow SPI standard and
> > use only 3 wires (SCLK, MOSI, SS) for connecting some simple auxiliary
> > chips and controls them with GPIO based 'spi controller'. In this
> > configuration the MISO line is missing (it is not required if the chip
> > does not transfer any data back to host). The example of such board is
> > a NCP ARM S3C64XX based machine. This patch adds support for such non-
> > standard configuration in GPIO-based SPI controller.
> > [...]
> > > diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
> > > index 26bd03e..5b75601 100644
> > > --- a/drivers/spi/spi_gpio.c
> > > +++ b/drivers/spi/spi_gpio.c
> > > @@ -114,7 +114,10 @@ static inline void setmosi(const struct
> > spi_device *spi, int is_on)
> > >
> > >  static inline int getmiso(const struct spi_device *spi)
> > >  {
> > > -	return !!gpio_get_value(SPI_MISO_GPIO);
> > > +	if (SPI_MISO_GPIO)
> > > +		return !!gpio_get_value(SPI_MISO_GPIO);
> > > +	else
> > > +		return 0;
> > >  }
> > 
> > Is zero a good approximation for 'no gpio' ?
> 
> Now I found that zero might be a valid gpio pin number on some architectures
> (it just means GPIO0 pin). This is imho a bit strange behavior of gpiolib as
> there should be also a special values for INVALID or NOGPIO cases. Does 
> anyone have any ideas how such cases should be handled properly? 

I belive there is a gpio_is_valid() function to tell you precisely if the
given GPIO is valid.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

