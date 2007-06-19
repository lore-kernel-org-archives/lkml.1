Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXFSHtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXFSHtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXFSHs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:48:58 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64150 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452AbXFSHs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:48:58 -0400
Date: Tue, 19 Jun 2007 09:47:52 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] atmel_lcdfb: Fix STN LCD support
Message-ID: <20070619094752.1b7ba108@dhcp-255-175.norway.atmel.com>
In-Reply-To: <467252C4.50203@rfo.atmel.com>
References: <467252C4.50203@rfo.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 10:50:12 +0200
Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:

> From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> 
> Fixes STN LCD support for the atmel_lcdfb framebuffer driver.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>

Looks correct to me. Although...

> Index: b/drivers/video/Kconfig
> ===================================================================
> --- a/drivers/video/Kconfig	2007-05-14 11:02:16.000000000 +0200
> +++ b/drivers/video/Kconfig	2007-06-13 11:04:10.000000000 +0200
> @@ -701,6 +701,16 @@
>  	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
>  	  to let frame buffer in external SDRAM.
>  
> +config FB_ATMEL_STN
> +	bool "Use a STN display with AT91/AT32 LCD Controller"
> +	depends on FB_ATMEL && ARCH_AT91SAM9261
> +	default n
> +	help
> +	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
> +	  Controller. Say N if you want to connect a TFT.
> +
> +	  If unsure, say N.
> +

I don't think it's appropriate to include chip-specific options here.
This option will not affect the driver at all, it will only affect the
board-specific setup code, so IMO it should be under Platform-specific
options or something like that.

Also, the text says AT91/AT32 but it depends on one particular AT91
chip.

I haven't had a chance to test it since I don't have any STN displays
around, but I'll try forwarding it to someone who has.

Haavard
