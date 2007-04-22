Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXDVIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXDVIB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXDVIB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:01:27 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46094 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbXDVIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:01:26 -0400
Subject: Re: [PATCH 3/8] Kconfig: unwanted config options for s390.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200704220115.01532.arnd@arndb.de>
References: <20070420113310.GD3738@skybase>
	 <200704220115.01532.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sun, 22 Apr 2007 10:01:41 +0200
Message-Id: <1177228901.8046.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 01:15 +0200, Arnd Bergmann wrote:
> > @@ -81,6 +82,7 @@ config VT_HW_CONSOLE_BINDING
> >  
> >  config SERIAL_NONSTANDARD
> >  	bool "Non-standard serial port support"
> > +	depends on !S390
> >  	---help---
> >  	  Say Y here if you have any non-standard serial boards -- boards
> >  	  which aren't supported using the standard "dumb" serial driver.
> 
> depends on MMIO

Depends on HAS_IOMEM.

> > @@ -822,7 +824,7 @@ config SGI_IP27_RTC
> >  
> >  config GEN_RTC
> >  	tristate "Generic /dev/rtc emulation"
> > -	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV
> > +	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV && !S390
> >  	---help---
> >  	  If you say Y here and create a character special file /dev/rtc with
> >  	  major number 10 and minor number 135 using mknod ("man mknod"), you
> 
> ok.
> 
> this one is bad in general and should probably be a select from the architecture,
> but that should not stop you from adding another architecture...

The disable extension would help here, but I never got anywhere with it.

> > @@ -878,6 +880,7 @@ config DTLK
> >  
> >  config R3964
> >  	tristate "Siemens R3964 line discipline"
> > +	depends on !S390
> >  	---help---
> >  	  This driver allows synchronous communication with devices using the
> >  	  Siemens R3964 packet protocol. Unless you are dealing with special
> 
> Does it build? I don't see a point disabling this one just because there are
> no users. Most architectures also don't have users for this one, but it
> doesn't hurt be able to build it using allyesconfig.

I'll try to build it.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


