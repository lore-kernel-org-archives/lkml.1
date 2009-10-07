Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZJGVwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZJGVwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZJGVwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:52:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58300 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZJGVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:52:02 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18jvfrVjgbVG7xBzmGH4odj
Date: Wed, 7 Oct 2009 14:51:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Govindraj.R" <govindraj.raja@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
Message-ID: <20091007215116.GB29320@atomide.com>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Govindraj.R <govindraj.raja@ti.com> [090924 03:29]:
> From: Govindraj R <govindraj.raja@ti.com>
> 
> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
> 
> Signed-off-by:	Govindraj R <govindraj.raja@ti.com>
> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Reviewed-by: Tony Lindgren <tony@atomide.com>

You should only add Reviewed-by if Alan or me have replied with it.

So far I've only replied with some comments that have not yet
been fixed, so we're few more steps from being Reviewd-by.

<snip>

> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 6553833..67a7129 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1359,6 +1359,53 @@ config SERIAL_OF_PLATFORM
>  	  Currently, only 8250 compatible ports are supported, but
>  	  others can easily be added.
> 
> +config SERIAL_OMAP
> +	bool "OMAP serial port support"
> +	depends on ARM && ARCH_OMAP
> +	select SERIAL_CORE
> +	help
> +	If you have a machine based on an Texas Instruments OMAP CPU you
> +	can enable its onboard serial ports by enabling this option.
> +
> +config SERIAL_OMAP_CONSOLE
> +	bool "Console on OMAP serial port"
> +	depends on SERIAL_OMAP
> +	select SERIAL_CORE_CONSOLE
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can make it the console by answering Y to this option.
> +
> +	Even if you say Y here, the currently visible virtual console
> +	(/dev/tty0) will still be used as the system console by default, but
> +	you can alter that using a kernel command line option such as
> +	"console=ttyS0". (Try "man bootparam" or see the documentation of
> +	your boot loader (lilo or loadlin) about how to pass options to the
> +	kernel at boot time.)
> +
> +config SERIAL_OMAP_DMA_UART1
> +	bool "UART1 DMA support"
> +	depends on SERIAL_OMAP
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can enable the DMA transfer on UART 1 by answering
> +	to this option.
> +
> +config SERIAL_OMAP_DMA_UART2
> +	bool "UART2 DMA support"
> +	depends on SERIAL_OMAP
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can enable the DMA transfer on UART 2 by answering
> +	to this option.
> +
> +config SERIAL_OMAP_DMA_UART3
> +	bool "UART3 DMA support"
> +	depends on SERIAL_OMAP
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can enable the DMA transfer on UART 3 by answering
> +	to this option.
> +
>  config SERIAL_OF_PLATFORM_NWPSERIAL
>  	tristate "NWP serial port driver"
>  	depends on PPC_OF && PPC_DCR

There's absolutely no need for having Kconfig options for the DMA
support. Please pass that in platform_data from the board-*.c files.

This is the third time I'm commenting on the same issue!

What's the point of posting these patches for review if the issues
don't get solved?

Regards,

Tony
