Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZERI5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZERI5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZERI5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:57:14 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:45358 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZERI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:57:13 -0400
Date: Mon, 18 May 2009 10:57:10 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, kyungmin.park@samsung.com
Subject: Re: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers
	with missing MISO pin
Message-ID: <20090518085710.GE14595@buzzloop.caiaq.de>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBF8C@bssrvexch01.BS.local> <20090507123157.GU32548@trinity.fluff.org> <000501c9d792$f8feb950$eafc2bf0$%szyprowski@samsung.com> <20090518083412.GA28648@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518083412.GA28648@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 09:34:12AM +0100, Ben Dooks wrote:
> > > >  static inline int getmiso(const struct spi_device *spi)
> > > >  {
> > > > -	return !!gpio_get_value(SPI_MISO_GPIO);
> > > > +	if (SPI_MISO_GPIO)
> > > > +		return !!gpio_get_value(SPI_MISO_GPIO);
> > > > +	else
> > > > +		return 0;
> > > >  }
> > > 
> > > Is zero a good approximation for 'no gpio' ?
> > 
> > Now I found that zero might be a valid gpio pin number on some architectures
> > (it just means GPIO0 pin). This is imho a bit strange behavior of gpiolib as
> > there should be also a special values for INVALID or NOGPIO cases. Does 
> > anyone have any ideas how such cases should be handled properly? 
> 
> I belive there is a gpio_is_valid() function to tell you precisely if the
> given GPIO is valid.

And then -1 can be passed in from the platform data which will fail the
gpio_is_valid() test.

Daniel

