Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYAKSVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYAKSVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760817AbYAKSVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:21:05 -0500
Received: from colo.lackof.org ([198.49.126.79]:40275 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761020AbYAKSVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:21:04 -0500
Date: Fri, 11 Jan 2008 11:20:45 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rdreier@cisco.com>, akepner@sgi.com,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_*
	routines
Message-ID: <20080111182045.GA9329@colo.lackof.org>
References: <20080108023222.GP23661@sgi.com> <1199809628.3534.34.camel@localhost.localdomain> <ada63y4kycs.fsf@cisco.com> <1199814853.3534.39.camel@localhost.localdomain> <adawsqkjipz.fsf@cisco.com> <1199816504.3534.59.camel@localhost.localdomain> <adaprwa7lzd.fsf@cisco.com> <1199914258.3493.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199914258.3493.53.camel@localhost.localdomain>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:30:58PM -0600, James Bottomley wrote:
...
> > Also, all of this is quite separate from the PCIe "loose ordering"
> > stuff.  In fact, it's quite conceivable that SGI could hook up a PCIe
> > 3.0 host bridge to the Altix NUMA interconnect, so that you could have
> > a PCI bus that supported loose ordering and also a system interconnect
> > that allowed a different type of reordering too.
> 
> Actually, no ... there'd just be an even weirder attribute, I suspect.
> The attributes will be set per *transaction* not per bus.  A transaction
> is an operation (DMA, PIO, config space, etc) from the actual bus to the
> CPU.  It doesn't matter how many physical bus segments this traverses
> and whether they're different bus types; all that matters for the
> attributes are the characteristics that are CPU visible.

James is right. Setting the PCI-e "Relaxed Ordering" bit in config space
allows the device to set the "Relaxed Order" in specific DMA transactions.
Upstream bridges may choose to ignore the bit or follow well defined
transaction flushing/ordering rules if they do implement "Relaxed Ordering".
Key thing here is the device decides when to set RO bit in each transaction.
This is completely different than the re-ordering which occurs in Altix
NUMA bus for _all_ (default config) transactions.

Given SGI/Altix only cares about a limited number of drivers and only a
subset of those support RDMA (or something like it), would it be reasonable
to add the new API to the RDMA code instead of the generic DMA API?

Please don't shoot me for suggesting that...just thinking "out loud" here.

thanks,
grant
