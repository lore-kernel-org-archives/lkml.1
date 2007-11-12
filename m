Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXKLXnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXKLXnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXKLXnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:43:43 -0500
Received: from colo.lackof.org ([198.49.126.79]:50274 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbXKLXnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:43:42 -0500
Date: Mon, 12 Nov 2007 16:43:26 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Greg KH <gregkh@suse.de>,
       Barak Fargoun <barak@neocleus.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Guy Zana <guy@neocleus.com>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
Message-ID: <20071112234326.GF30285@colo.lackof.org>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de> <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms> <20071028200336.GA14563@suse.de> <20071029055216.GB14763@colo.lackof.org> <20071108232400.GC4239@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108232400.GC4239@austin.ibm.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 05:24:00PM -0600, Linas Vepstas wrote:
...
> > E.g. 4 port Gige card could directly support the host and 3 guests with somewhat
> > lower risk of tromping on each other's MMIO space.
> > 
> > If Xen is cooperative, this seems a bit paranoid. I don't recall ever seeing a
> > driver bug where the driver accidentally poked MMIO space at the wrong device.
> 
> I presume the issue is not a driver bug per-se, but a
> spying/hacking-type security issue: Having root in one guest could in
> principle allow one to write a driver that snooped on data in other
> guests, and/or intentionally corrupted data on other guests.

If someone has root on a guest, they could modprobe a driver that
can map any unused virtual address to any physical address they want.
Unless the chipset somehow blocks/refuses to route IO for that guest,
then they can still poke at any other device once they figure out
where addresses are being routed (e.g. directly reading configuration
space or directly accessing chipset specific registers.)

> I envision some ISP renting out 1/3 of a machine with a 4-port card,
> and having some nosey college-kid wannabe hacker getting root on one of
> the guests and causing trouble.  But perhaps I'm waaaayyyyy off base
> here.

I agree this will make it slightly harder. Also makes it much more likely the
box will crash - taking down all the guests. And someone should notice that.

> (Just like occasional cigarette smoking is known to inevitably lead to
> full-fledged heroin addiction, I am pretty sure that the culture of
> "cheat codes" among 12-year-olds is going to lead to an epidemic of
> hackers in about 10 years. I am atuned to "wannabe hacker culture"). 

Ok - but I think there are more serious issues if someone can get
root on a remote box (ignore Virtualization). Several other possible
layers of security have already been "defeated" by then.

thanks,
grant
