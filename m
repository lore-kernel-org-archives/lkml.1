Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYAGTPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYAGTPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYAGTPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:15:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42273 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYAGTPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:15:32 -0500
Date: Mon, 7 Jan 2008 20:15:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sudhir kumar <imsudhirkumar@gmail.com>, linux-kernel@vger.kernel.org,
       Hendrik Sattler <post@hendrik-sattler.de>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [2.6.24-rc6-mm1] Build Failure on ppc64 with CONFIG_USB_GADGET not set.
Message-ID: <20080107191531.GA16710@uranus.ravnborg.org>
References: <3da2c0120801070323v39e6f95esd47cef6b860fbf06@mail.gmail.com> <20080107094955.720c3764.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107094955.720c3764.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:49:55AM -0800, Andrew Morton wrote:
> On Mon, 7 Jan 2008 16:53:58 +0530 "sudhir kumar" <imsudhirkumar@gmail.com> wrote:
> 
> > Hi Andrew!
> > 
> > Kernel build fails on my ppc64 machine. It seems to be  a dependency
> > problem with CONFIG_USB_GADGET not set.
> > Config file is attached.
> > 
> >  CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `oz99x_remove':
> > drivers/i2c/chips/oz99x.c:660: undefined reference to `.led_classdev_unregister'
> > drivers/built-in.o: In function `oz99x_configure_leds':
> > drivers/i2c/chips/oz99x.c:314: undefined reference to `.led_classdev_register'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> Strange.
> 
> oz99x-i2c-button-and-led-support-driver.patch has
> 
> +config OZ99X
> +	tristate "O2 Micro/ETC OZ990/OZ992 SMBus chip"
> +	depends on I2C
> +	select INPUT_POLLDEV
> +	select LEDS_CLASS
> 
> and your .config gives
> 
> box:/usr/src/25> grep LEDS .config
> # CONFIG_NEW_LEDS is not set
> CONFIG_LEDS_CLASS=y
> 
> so drivers/leds/led-class.o should be linked into your vmlinux.  But that
> obviously isn't happening.
Because CONFIG_NEW_LEDS is not set we do not visit drivers/leds due to:
obj-$(CONFIG_NEW_LEDS)          += leds/
in drivers/Makefile

This is evil select playing games (again).
We have LEDS_CLASS equal y but NEW_LEDS equal n

	Sam
