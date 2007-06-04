Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbXFDNa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbXFDNa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXFDNaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:30:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51676 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753733AbXFDNaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:30:17 -0400
Date: Mon, 4 Jun 2007 14:30:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070604143005.1b0e3c66@the-village.bc.nu>
In-Reply-To: <20070603.174010.41894721.davem@davemloft.net>
References: <Pine.SOC.4.64.0706032314590.20033@math>
	<20070603.174010.41894721.davem@davemloft.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > CONFIG_PCI=n
> > CONFIG_ATA=m
> > 
> > This seems to be a valid configuration since libata can drive non-PCI 
> > devices too?

Yep.

> It really makes no sense to allow this on Sparc, there are no
> non-PCI Sparc ATA controllers.

There are PCMCIA controllers and PCI/PCMCIA/Cardbus adapters for the
Sparc platform I thought ?

> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a8d60..7d893a6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -8,6 +8,7 @@ menuconfig ATA
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN
>  	depends on !SUN4 || BROKEN
> +	depends on !(SPARC64 && !PCI)


NAK - this is the wrong approach. PCI=n ATA=m should compile. Sparc is
not the only problem case. The DMA handling bits of libata are fairly
nicely split out but they are stuck in the same file and unconditionally
compiled in.

I'll have a poke at this when I get a bit of time if Jeff doesn't.

Alan
