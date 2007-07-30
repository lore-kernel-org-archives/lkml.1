Return-Path: <linux-kernel-owner+w=401wt.eu-S939366AbXG3UOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939366AbXG3UOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935774AbXG3UOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:14:43 -0400
Received: from ns.suse.de ([195.135.220.2]:32799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761648AbXG3UOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:14:42 -0400
Date: Mon, 30 Jul 2007 13:14:11 -0700
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Bernhard Kaindl <bk@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       Alois Ne??por <alois.nespor@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Ok, lets kill the 'PCI hidden behind bridge' message (was:
	pci=assign-busses)
Message-ID: <20070730201411.GA822@suse.de>
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com> <20070730115331.GO16817@stusta.de> <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr> <20070730201143.GA3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730201143.GA3972@stusta.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:11:43PM +0200, Adrian Bunk wrote:
> On Mon, Jul 30, 2007 at 08:35:13PM +0200, Bernhard Kaindl wrote:
> >...
> > --- linux-2.6.22/drivers/pci/probe.c
> > +++ linux-2.6.22/drivers/pci/probe.c
> > @@ -643,23 +643,24 @@ int pci_scan_bridge(struct pci_bus *bus,
> >
> >  	sprintf(child->name, (is_cardbus ? "PCI CardBus #%02x" : "PCI Bus 
> > #%02x"), child->number);
> >
> > +#ifdef DEBUG /* Has only triggered on CardBus, fixup is in yenta_socket */
> >  	while (bus->parent) {
> >  		if ((child->subordinate > bus->subordinate) ||
> >  		    (child->number > bus->subordinate) ||
> >  		    (child->number < bus->number) ||
> >  		    (child->subordinate < bus->number)) {
> > -			printk(KERN_WARNING "PCI: Bus #%02x (-#%02x) is "
> > -			       "hidden behind%s bridge #%02x (-#%02x)%s\n",
> > +		      pr_debug("PCI: Bus #%02x (-#%02x) is %s"
> > +			       "hidden behind%s bridge #%02x (-#%02x)\n",
> >  			       child->number, child->subordinate,
> > +			       (bus->number > child->subordinate &&
> > +			        bus->subordinate < child->number) ?
> > +					"wholly " : " partially",
> >  			       bus->self->transparent ? " transparent" : " ",
> > -			       bus->number, bus->subordinate,
> > -			       pcibios_assign_all_busses() ? " " :
> > -			       " (try 'pci=assign-busses')");
> > -			printk(KERN_WARNING "Please report the result to "
> > -			       "linux-kernel to fix this permanently\n");
> > +			       bus->number, bus->subordinate);
> >  		}
> >  		bus = bus->parent;
> >  	}
> > +#endif
> >
> >  out:
> >  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
> 
> "#ifdef DEBUG" plus pr_debug() is twoce the same.
> 
> You don't need the #ifdef.

I took it out in the version I applied, and cleaned up the whitespace a
little bit too :)

thanks,

greg k-h
