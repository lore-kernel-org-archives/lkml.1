Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYGFUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYGFUCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYGFUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:02:24 -0400
Received: from bu3sch.de ([62.75.166.246]:52037 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYGFUCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:02:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH v2] gpiolib: Allow user-selection
Date: Sun, 6 Jul 2008 22:01:24 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
References: <200807031233.04229.mb@bu3sch.de> <20080706195212.GF21669@cs181140183.pp.htv.fi>
In-Reply-To: <20080706195212.GF21669@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807062201.25194.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 July 2008 21:52:12 Adrian Bunk wrote:
> > +menuconfig GPIOLIB
> > +	bool "GPIO Support"
> > +	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
> > +	select GENERIC_GPIO
> > +	help
> > +	  This enables GPIO support through the generic GPIO library.
> > +	  You only need to enable this, if you also want to enable
> > +	  one or more of the GPIO expansion card drivers below.
> > +
> > +	  If unsure, say N.
> >...
> 
> The implementation of ARCH_REQUIRE_GPIOLIB does not match the description.
> 
> Matching the description would be:
> 
> menuconfig GPIOLIB
>         bool "GPIO Support" if !ARCH_REQUIRE_GPIOLIB
>         depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
>         default ARCH_REQUIRE_GPIOLIB
>         select GENERIC_GPIO
>         help
>           ...

So well. I'm not sure what you're talking about. Care to make
a better helptext?

> > --- linux-next.orig/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:31:05.000000000 +0200
> > +++ linux-next/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:36:14.000000000 +0200
> > @@ -668,7 +668,7 @@
> >  #
> >  # CONFIG_SPI is not set
> >  # CONFIG_SPI_MASTER is not set
> > -CONFIG_HAVE_GPIO_LIB=y
> > +CONFIG_ARCH_REQUIRE_GPIOLIB=y
> >...
> 
> Please don't do this kind of defconfig updates - it doesn't bring any
> advantage but can create tons of patch conflicts.
> 
> The next time a defconfig gets updated it will anyway automatically be
> fixed, and for defconfigs that aren't updated it doesn't create any
> problems to keep them as they are today until they might one day get
> updated.

So will the auto-regenerated defconfig result in CONFIG_ARCH_REQUIRE_GPIOLIB=y
or CONFIG_ARCH_REQUIRE_GPIOLIB=n? I thought it would result in =n, as the
option defaults to n. So I changed all defconfigs.

(I think these (sub)archs should "select" the option in their Kconfig, but I
didn't want to go down that way).

-- 
Greetings Michael.
