Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbXKNV4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbXKNV4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbXKNVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:55:55 -0500
Received: from colo.lackof.org ([198.49.126.79]:43362 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbXKNVzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:55:55 -0500
Date: Wed, 14 Nov 2007 14:55:38 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       David Miller <davem@davemloft.net>, gregkh@suse.de, barak@neocleus.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       guy@neocleus.com
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071114215538.GA14588@colo.lackof.org>
References: <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de> <20071028.180807.165828961.davem@davemloft.net> <1194988653.28605.4.camel@pasglop> <20071114062157.GA30203@colo.lackof.org> <1195028178.28865.32.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195028178.28865.32.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 07:16:18PM +1100, Benjamin Herrenschmidt wrote:
> > We already have that "something": pci_enable_device().
> > The guest OS "Arch" code can then do the reassignment.
> > See "3.1 Enable the PCI device" in Documentation/pci.txt.
> 
> No, that can't be done there because that would mean the guest OS has
> the ability to reassign resources of PCI devices which is really not
> something you want. You really want the host OS to do that -before- it
> makes the device visible to the guest imho.

Agreed. I didn't explain well enough. The assignment doesn't need
to happen until that point. My assumption was the host OS (or Hypervisor)
would already know what it's supposed to be before then and just
set it up at that point.

> 
> > The Hypervisor could be responsible for making the right devices
> > visible to the appropriate partitions/guests by intercepting the
> > PCI bus walk and/or hotplug support. I don't think you
> > should need any dummy resource/drivers in the guest OS.
> 
> I'm not talking about a dummy resource/driver in the guest OS, but
> rather, in the host. When a PCI device, that is visible to the host, is
> to be "reflected" into a guest, it makes sense to have a proxy driver
> take over in the host from a resource management point of view, thus
> making this device effectively "used" and thus preventing another
> process or partition from trying to bind to it. That proxy driver can
> then be responsible for doing the appropriate resource tweaking before
> making the device effectively visible to the guest. It might make sense
> to provide a helper in the PCI layer to make that easier tho.

Ah ok.. I was assuming there was only a "Hypervisor" and all the "guests"
were equal. If one OS instance is "Host" and can see the device before hand,
then yeah, it makes sense to "hide" the device from the normal device drivers.

grant
"Host OS
> 
> Ben.
> 
