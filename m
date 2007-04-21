Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbXDUXPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbXDUXPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXDUXPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:15:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXDUXPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:15:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/8] Kconfig: unwanted config options for s390.
Date: Sun, 22 Apr 2007 01:15:01 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070420113310.GD3738@skybase>
In-Reply-To: <20070420113310.GD3738@skybase>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220115.01532.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sMLTzcTU5BebTlxzC+2PhQcF4LGUCaznb+RB
 piioMvjFg6qTd6UMXQ0e5EpWihTp4vDriBqvvXMR2/rX4UbIrF
 wfqIWxIeoNGgUX/qXqtRg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007, Martin Schwidefsky wrote:

> diff -urpN linux-2.6/drivers/char/Kconfig linux-2.6-patched/drivers/char/Kconfig
> --- linux-2.6/drivers/char/Kconfig	2007-04-19 15:49:51.000000000 +0200
> +++ linux-2.6-patched/drivers/char/Kconfig	2007-04-19 15:50:50.000000000 +0200
> @@ -6,6 +6,7 @@ menu "Character devices"
>  
>  config VT
>  	bool "Virtual terminal" if EMBEDDED
> +	depends on !S390
>  	select INPUT
>  	default y if !VIOCONS
>  	---help---

ok

> @@ -81,6 +82,7 @@ config VT_HW_CONSOLE_BINDING
>  
>  config SERIAL_NONSTANDARD
>  	bool "Non-standard serial port support"
> +	depends on !S390
>  	---help---
>  	  Say Y here if you have any non-standard serial boards -- boards
>  	  which aren't supported using the standard "dumb" serial driver.

depends on MMIO

> @@ -774,7 +776,7 @@ config NVRAM
>  
>  config RTC
>  	tristate "Enhanced Real Time Clock Support"
> -	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH
> +	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH && !S390
>  	---help---
>  	  If you say Y here and create a character special file /dev/rtc with
>  	  major number 10 and minor number 135 using mknod ("man mknod"), you
> @@ -822,7 +824,7 @@ config SGI_IP27_RTC
>  
>  config GEN_RTC
>  	tristate "Generic /dev/rtc emulation"
> -	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV
> +	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV && !S390
>  	---help---
>  	  If you say Y here and create a character special file /dev/rtc with
>  	  major number 10 and minor number 135 using mknod ("man mknod"), you

ok.

this one is bad in general and should probably be a select from the architecture,
but that should not stop you from adding another architecture...

> @@ -878,6 +880,7 @@ config DTLK
>  
>  config R3964
>  	tristate "Siemens R3964 line discipline"
> +	depends on !S390
>  	---help---
>  	  This driver allows synchronous communication with devices using the
>  	  Siemens R3964 packet protocol. Unless you are dealing with special

Does it build? I don't see a point disabling this one just because there are
no users. Most architectures also don't have users for this one, but it
doesn't hurt be able to build it using allyesconfig.

	Arnd <><
