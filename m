Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZERJrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZERJrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZERJag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:30:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41052 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbZERJae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:30:34 -0400
Date: Mon, 18 May 2009 11:27:59 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers with
 missing MISO pin
In-reply-to: <20090518085710.GE14595@buzzloop.caiaq.de>
To: "'Daniel Mack'" <daniel@caiaq.de>, "'Ben Dooks'" <ben-linux@fluff.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, kyungmin.park@samsung.com
Message-id: <000901c9d79a$f36a86b0$da3f9410$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcnXlqWXANGyQY9ETqm3OPViz2FqrAAAinLw
References: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBF8C@bssrvexch01.BS.local>
 <20090507123157.GU32548@trinity.fluff.org>
 <000501c9d792$f8feb950$eafc2bf0$%szyprowski@samsung.com>
 <20090518083412.GA28648@trinity.fluff.org>
 <20090518085710.GE14595@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, May 18, 2009 10:57 AM Daniel Mack wrote:

> On Mon, May 18, 2009 at 09:34:12AM +0100, Ben Dooks wrote:
> > > > >  static inline int getmiso(const struct spi_device *spi)
> > > > >  {
> > > > > -	return !!gpio_get_value(SPI_MISO_GPIO);
> > > > > +	if (SPI_MISO_GPIO)
> > > > > +		return !!gpio_get_value(SPI_MISO_GPIO);
> > > > > +	else
> > > > > +		return 0;
> > > > >  }
> > > >
> > > > Is zero a good approximation for 'no gpio' ?
> > >
> > > Now I found that zero might be a valid gpio pin number on some
> architectures
> > > (it just means GPIO0 pin). This is imho a bit strange behavior of
> gpiolib as
> > > there should be also a special values for INVALID or NOGPIO cases.
> Does
> > > anyone have any ideas how such cases should be handled properly?
> >
> > I belive there is a gpio_is_valid() function to tell you precisely if
> > the given GPIO is valid.
> 
> And then -1 can be passed in from the platform data which will fail the
> gpio_is_valid() test.

Ok. I will update my patch. Thank you for the idea.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


