Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbXKHX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbXKHX0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXKHX0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:26:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49802 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbXKHX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:26:03 -0500
Date: Thu, 8 Nov 2007 17:24:00 -0600
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <gregkh@suse.de>, Barak Fargoun <barak@neocleus.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Guy Zana <guy@neocleus.com>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071108232400.GC4239@austin.ibm.com>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de> <20071029055216.GB14763@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029055216.GB14763@colo.lackof.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 11:52:16PM -0600, Grant Grundler wrote:
> > On Sun, Oct 28, 2007 at 03:53:20PM -0400, Barak Fargoun wrote:
> ...
> > > About your question: today, some of the hypervisors are using linux
> > > kernel as their domain-0 (e.g. Xen). In order to implement direct
> > > hardware access for these native domains (e.g.  running windows in a
> > > virtual machine above Xen), the PCI memory regions should be aligned
> > > at-least at the page-level (so, a virtual machine - can't see data of
> > > other devices which may not be assigned to it). So, for that reason,
> > > we wanted a boot parameter to let us force the kernel to align PCI
> > > memory regions at-least at a PAGE_SIZE alignment. It is very useful
> > > for hypervisors which are developed at Linux environment (e.g.: Xen).
> 
> It's a benefit IFF multiple devices are spread across more than one guest
> _and_ we don't trust every particating guest to play nicely with IO.  That way
> the Hypervisor can assign one device to a specific guest OS for direct access.
> E.g. 4 port Gige card could directly support the host and 3 guests with somewhat
> lower risk of tromping on each other's MMIO space.
> 
> If Xen is cooperative, this seems a bit paranoid. I don't recall ever seeing a
> driver bug where the driver accidentally poked MMIO space at the wrong device.

I presume the issue is not a driver bug per-se, but a
spying/hacking-type security issue: Having root in one guest could in
principle allow one to write a driver that snooped on data in other
guests, and/or intentionally corrupted data on other guests.

I envision some ISP renting out 1/3 of a machine with a 4-port card,
and having some nosey college-kid wannabe hacker getting root on one of
the guests and causing trouble.  But perhaps I'm waaaayyyyy off base
here.

(Just like occasional cigarette smoking is known to inevitably lead to
full-fledged heroin addiction, I am pretty sure that the culture of
"cheat codes" among 12-year-olds is going to lead to an epidemic of
hackers in about 10 years. I am atuned to "wannabe hacker culture"). 

--linas
