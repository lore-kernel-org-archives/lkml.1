Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbXJXQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbXJXQTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXJXQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:19:31 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:63567 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbXJXQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:19:30 -0400
X-Belgacom-Dynamic: yes
Date: Wed, 24 Oct 2007 18:25:40 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: thomas.mingarelli@hp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Message-ID: <20071024162540.GD6015@infomag.infomag.iguana.be>
References: <20071022180711.5246.49013.sendpatchset@tmingo.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022180711.5246.49013.sendpatchset@tmingo.cca.cpqcorp.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> --- linux-2.6.23.1/drivers/char/watchdog/Makefile.orig	2007-10-12 11:43:44.000000000 -0500
> +++ linux-2.6.23.1/drivers/char/watchdog/Makefile	2007-10-15 07:56:31.000000000 -0500
> @@ -118,3 +118,10 @@
>  
>  # Architecture Independant
>  obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
> +
> +#
> +# Makefile for the hp WatchDog driver.
> +#
> +CFLAGS_hpwdt.o += -O
> +obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
> +
> --- linux-2.6.23.1/drivers/char/watchdog/Kconfig.orig	2007-10-12 11:43:44.000000000 -0500
> +++ linux-2.6.23.1/drivers/char/watchdog/Kconfig	2007-10-15 07:57:27.000000000 -0500
> @@ -55,6 +55,19 @@
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called softdog.
>  
> +config HP_WATCHDOG
> +        tristate "Hewlett-Packard watchdog"
> +        depends on WATCHDOG && X86
> +        help
> +          A software monitoring watchdog and NMI sourcing driver. This driver
> +          will detect lockups and provide stack trace. Also, when an NMI
> +          occurs this driver will make the necessary BIOS calls to log
> +          the cause of the NMI. This is a driver that will only load on a
> +          HP ProLiant system with a minimum of iLO2 support.
> +          To compile this driver as a module, choose M here: the
> +          module will be called hpwdt.
> +
> +
>  # ALPHA Architecture
>  
>  # ARM Architecture

Before reviewing the rest of your driver: can you please put your "X86 Architecture related"
driver in the X86 related parts of Kconfig and Makefile ? Also the depend on WATCHDOG is not
needed since we allready have a general dependency for all the drivers in Kconfig.

Please also note that we just shifted the watchdog drivers from drivers/char/watchdog to
drivers/watchdog -> so your driver will appear in the drivers/watchdog directory when it
will be included.

Greetings,
Wim.

