Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXDVIJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXDVIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXDVIJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:09:57 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56812 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXDVIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:09:53 -0400
Subject: Re: [PATCH 2/8] Kconfig: unwanted menus for s390.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200704220110.54587.arnd@arndb.de>
References: <20070420113248.GC3738@skybase>
	 <200704220110.54587.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sun, 22 Apr 2007 10:10:08 +0200
Message-Id: <1177229408.8046.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 01:10 +0200, Arnd Bergmann wrote:
> > --- linux-2.6/drivers/dma/Kconfig	2007-04-19 15:24:33.000000000 +0200
> > +++ linux-2.6-patched/drivers/dma/Kconfig	2007-04-19 15:49:55.000000000 +0200
> > @@ -3,6 +3,7 @@
> >  #
> >  
> >  menu "DMA Engine support"
> > +	depends on !S390
> >  
> >  config DMA_ENGINE
> >  	bool "Support for DMA engines"
> 
> I'd leave the menu enabled. If the DMA engine infrastructure becomes more widely
> used, you may want to add an implementation for s390 using milicoded instructions
> like xor-string or copy-page.

If we ever add an implementation for s390 we can rmeove the depends line
again. The current situation is that we don't support it.

> > diff -urpN linux-2.6/drivers/input/Kconfig linux-2.6-patched/drivers/input/Kconfig
> > --- linux-2.6/drivers/input/Kconfig	2007-02-04 19:44:54.000000000 +0100
> > +++ linux-2.6-patched/drivers/input/Kconfig	2007-04-19 15:49:55.000000000 +0200
> > @@ -3,6 +3,7 @@
> >  #
> >  
> >  menu "Input device support"
> > +	depends on !S390
> >  
> >  config INPUT
> >  	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED
> 
> Probably leave this as !S390. One could imagine channel-attached input devices
> or the idea of intepreting a terminal as an input device, but no driver currently
> does and probably never will.

We don't have support and it is VERY unlikely we will get it. I would
prefer to hide the menu.

> > diff -urpN linux-2.6/drivers/isdn/Kconfig linux-2.6-patched/drivers/isdn/Kconfig
> > --- linux-2.6/drivers/isdn/Kconfig	2007-02-04 19:44:54.000000000 +0100
> > +++ linux-2.6-patched/drivers/isdn/Kconfig	2007-04-19 15:49:55.000000000 +0200
> > @@ -3,6 +3,7 @@
> >  #
> >  
> >  menu "ISDN subsystem"
> > +	depends on !S390
> >  
> >  config ISDN
> >  	tristate "ISDN support"
> 
> Same here, actually there was an IBM 2216 ISDN adapter with channel attachment,
> but I don't think anybody wants to add a driver for that one.

Without a driver is it mute to have the menu.

> > diff -urpN linux-2.6/drivers/misc/Kconfig linux-2.6-patched/drivers/misc/Kconfig
> > --- linux-2.6/drivers/misc/Kconfig	2007-04-19 15:24:35.000000000 +0200
> > +++ linux-2.6-patched/drivers/misc/Kconfig	2007-04-19 15:49:55.000000000 +0200
> > @@ -3,6 +3,7 @@
> >  #
> >  
> >  menu "Misc devices"
> > +	depends on !S390
> >  
> >  config IBM_ASM
> >  	tristate "Device driver for IBM RSA service processor"
> 
> Maybe just leave the menu open, all drivers in it are already depending on PCI
> or similar and someone might add a driver that does work on s390 here.

This is a border-case. Someone might add a driver that actually works.
Currently it is an empty menu. 

> > diff -urpN linux-2.6/drivers/rtc/Kconfig linux-2.6-patched/drivers/rtc/Kconfig
> > --- linux-2.6/drivers/rtc/Kconfig	2007-04-19 15:24:39.000000000 +0200
> > +++ linux-2.6-patched/drivers/rtc/Kconfig	2007-04-19 15:49:55.000000000 +0200
> > @@ -3,6 +3,7 @@
> >  #
> >  
> >  menu "Real Time Clock"
> > +	depends on !S390
> >  
> >  config RTC_LIB
> >  	tristate
> 
> Applications might actually want to use the RTC interface to access the system time
> or get accurate timers, but the rtc drivers are all very dependant on either MMIO
> or I2C. Not sure what would be best here.

If we ever come up with an implementation for RTC we can remove the
depends statement again. Until we do it is another empty menu.

Thanks Arnd for the review.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


