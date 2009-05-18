Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZERIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZERIdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERIcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:32:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35492 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZERIcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:32:52 -0400
Date: Mon, 18 May 2009 10:30:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with
 missing MISO pin
In-reply-to: <20090507123157.GU32548@trinity.fluff.org>
To: "'Ben Dooks'" <ben-linux@fluff.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, kyungmin.park@samsung.com,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000501c9d792$f8feb950$eafc2bf0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnPD93VQbYYKZc9TqiFiCFVFw3hIwIghKOA
References: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBF8C@bssrvexch01.BS.local>
 <20090507123157.GU32548@trinity.fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, May 07, 2009 2:32 PM Ben Dooks wrote:

> On Thu, May 07, 2009 at 02:24:11PM +0200, Marek Szyprowski wrote:
> > There are some boards that do not strictly follow SPI standard and
> use only 3 wires (SCLK, MOSI, SS) for connecting some simple auxiliary
> chips and controls them with GPIO based 'spi controller'. In this
> configuration the MISO line is missing (it is not required if the chip
> does not transfer any data back to host). The example of such board is
> a NCP ARM S3C64XX based machine. This patch adds support for such non-
> standard configuration in GPIO-based SPI controller.
> [...]
> > diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
> > index 26bd03e..5b75601 100644
> > --- a/drivers/spi/spi_gpio.c
> > +++ b/drivers/spi/spi_gpio.c
> > @@ -114,7 +114,10 @@ static inline void setmosi(const struct
> spi_device *spi, int is_on)
> >
> >  static inline int getmiso(const struct spi_device *spi)
> >  {
> > -	return !!gpio_get_value(SPI_MISO_GPIO);
> > +	if (SPI_MISO_GPIO)
> > +		return !!gpio_get_value(SPI_MISO_GPIO);
> > +	else
> > +		return 0;
> >  }
> 
> Is zero a good approximation for 'no gpio' ?

Now I found that zero might be a valid gpio pin number on some architectures
(it just means GPIO0 pin). This is imho a bit strange behavior of gpiolib as
there should be also a special values for INVALID or NOGPIO cases. Does 
anyone have any ideas how such cases should be handled properly? 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



