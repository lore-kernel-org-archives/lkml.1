Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbXJ2Fwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbXJ2Fwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXJ2Fwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:52:34 -0400
Received: from colo.lackof.org ([198.49.126.79]:45935 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXJ2Fwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:52:33 -0400
Date: Sun, 28 Oct 2007 23:52:16 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Greg KH <gregkh@suse.de>
Cc: Barak Fargoun <barak@neocleus.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Guy Zana <guy@neocleus.com>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071029055216.GB14763@colo.lackof.org>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028200336.GA14563@suse.de>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 01:03:36PM -0700, Greg KH wrote:
> On Sun, Oct 28, 2007 at 03:53:20PM -0400, Barak Fargoun wrote:
...
> > About your question: today, some of the hypervisors are using linux
> > kernel as their domain-0 (e.g. Xen). In order to implement direct
> > hardware access for these native domains (e.g.  running windows in a
> > virtual machine above Xen), the PCI memory regions should be aligned
> > at-least at the page-level (so, a virtual machine - can't see data of
> > other devices which may not be assigned to it). So, for that reason,
> > we wanted a boot parameter to let us force the kernel to align PCI
> > memory regions at-least at a PAGE_SIZE alignment. It is very useful
> > for hypervisors which are developed at Linux environment (e.g.: Xen).
...
> And if not, why would we not do this for all devices not just for
> virtual machines, if it is such a benefit?

It's a benefit IFF multiple devices are spread across more than one guest
_and_ we don't trust every particating guest to play nicely with IO.  That way
the Hypervisor can assign one device to a specific guest OS for direct access.
E.g. 4 port Gige card could directly support the host and 3 guests with somewhat
lower risk of tromping on each other's MMIO space.

If Xen is cooperative, this seems a bit paranoid. I don't recall ever seeing a
driver bug where the driver accidentally poked MMIO space at the wrong device.
That's much more common for IO Port space. The only exception was xfree86 where it
poked around in random places to deal with buggy HW quirks.

The use of an IOMMU will provide much more useful protection.

grant
