Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbXKNGWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbXKNGWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbXKNGWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:22:16 -0500
Received: from colo.lackof.org ([198.49.126.79]:55266 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbXKNGWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:22:15 -0500
Date: Tue, 13 Nov 2007 23:21:57 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, gregkh@suse.de, barak@neocleus.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       guy@neocleus.com
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071114062157.GA30203@colo.lackof.org>
References: <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de> <20071028.180807.165828961.davem@davemloft.net> <1194988653.28605.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194988653.28605.4.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 08:17:33AM +1100, Benjamin Herrenschmidt wrote:
...
> Though he's trying to fix a real issue, his patch is not the right
> approach imho.
> 
> A better approach would be to have a mechanism to be triggered by the
> hypervisor administration tools that will attempt to reassign -that-
> specific device if it happens to share pages with another.
> 
> The remapping would thus only happen for that single device, after it's
> been put in control of the hypervisor (no host driver is bound, maybe
> just an HV specific "bridging" driver is), and only when the action of
> assigning it to the partition is performed, so that if the machine
> crashes as a result, at least you know why :-)
> 
> So something like your hypervisor binds a special driver to a device
> that is to be reflected to a partition, at which point we are sure no
> other driver is using it, then that driver can call something in the pci
> layer that attempts to re-assign the device resources to keep it in a
> separate page.

We already have that "something": pci_enable_device().
The guest OS "Arch" code can then do the reassignment.
See "3.1 Enable the PCI device" in Documentation/pci.txt.


> A patch implementing such a helper, and maybe reserving the rest of the
> MMIO page via some dummy resource to make sure nobody else gets in, that
> would make more sense.

The Hypervisor could be responsible for making the right devices
visible to the appropriate partitions/guests by intercepting the
PCI bus walk and/or hotplug support. I don't think you
should need any dummy resource/drivers in the guest OS.

hth,
grant
