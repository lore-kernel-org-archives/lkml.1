Return-Path: <linux-kernel-owner+w=401wt.eu-S968669AbXG3UMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968669AbXG3UMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967953AbXG3UMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:12:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54170 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967863AbXG3UMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:12:07 -0400
Date: Mon, 30 Jul 2007 22:11:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Bernhard Kaindl <bk@suse.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Alois =?utf-8?Q?Ne=C5=A1por?= <alois.nespor@gmail.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Ok, lets kill the 'PCI hidden behind bridge' message (was:
	pci=assign-busses)
Message-ID: <20070730201143.GA3972@stusta.de>
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com> <20070730115331.GO16817@stusta.de> <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 08:35:13PM +0200, Bernhard Kaindl wrote:
>...
> --- linux-2.6.22/drivers/pci/probe.c
> +++ linux-2.6.22/drivers/pci/probe.c
> @@ -643,23 +643,24 @@ int pci_scan_bridge(struct pci_bus *bus,
>
>  	sprintf(child->name, (is_cardbus ? "PCI CardBus #%02x" : "PCI Bus 
> #%02x"), child->number);
>
> +#ifdef DEBUG /* Has only triggered on CardBus, fixup is in yenta_socket */
>  	while (bus->parent) {
>  		if ((child->subordinate > bus->subordinate) ||
>  		    (child->number > bus->subordinate) ||
>  		    (child->number < bus->number) ||
>  		    (child->subordinate < bus->number)) {
> -			printk(KERN_WARNING "PCI: Bus #%02x (-#%02x) is "
> -			       "hidden behind%s bridge #%02x (-#%02x)%s\n",
> +		      pr_debug("PCI: Bus #%02x (-#%02x) is %s"
> +			       "hidden behind%s bridge #%02x (-#%02x)\n",
>  			       child->number, child->subordinate,
> +			       (bus->number > child->subordinate &&
> +			        bus->subordinate < child->number) ?
> +					"wholly " : " partially",
>  			       bus->self->transparent ? " transparent" : " ",
> -			       bus->number, bus->subordinate,
> -			       pcibios_assign_all_busses() ? " " :
> -			       " (try 'pci=assign-busses')");
> -			printk(KERN_WARNING "Please report the result to "
> -			       "linux-kernel to fix this permanently\n");
> +			       bus->number, bus->subordinate);
>  		}
>  		bus = bus->parent;
>  	}
> +#endif
>
>  out:
>  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);

"#ifdef DEBUG" plus pr_debug() is twoce the same.

You don't need the #ifdef.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

