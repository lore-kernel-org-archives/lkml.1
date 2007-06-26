Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbXFZPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbXFZPJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbXFZPJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:09:47 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:10990 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXFZPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:09:46 -0400
Date: Tue, 26 Jun 2007 11:09:40 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626150940.GC8274@rhun.ibm.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <p73645a675q.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73645a675q.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 05:56:49PM +0200, Andi Kleen wrote:

> > > - The IOMMU can merge sg lists into a single virtual block. This could
> > > potentially speed up SG IO when the device is slow walking SG
> > > lists.  [I long ago benchmarked 5% on some block benchmark with
> > > an old MPT Fusion; but it probably depends a lot on the HBA]
> > 
> > But most devices are SG-capable.
> 
> Your point being?

That the fact that an IOMMU can do SG for non-SG-capble cards is not
interesting from a "reason for inclusion" POV.

> > How much? we have numbers (to be presented at OLS later this week)
> > that show that on bare-metal an IOMMU can cost as much as 15%-30%
> > more CPU utilization for an IO intensive workload (netperf). It
> > will be interesting to see comparable numbers for VT-d.
> 
> That is something that needs more work.

Yup. I'm working on it (mostly in the context of Calgary) but also
looking at improvements to the DMA-API interface and usage.

> We should probably have a switch to use the IOMMU only for specific
> devices (e.g. for the KVM case) r only when remapping is
> needed.

Calgary already does this internally (via calgary=disable=<BUSNUM>)
but that's pretty ugly. It would be better to do it in a generic
fashion when deciding which dma_ops to call (i.e., a dma_ops per bus
or device).

> Also the user interface for X server case needs more work.

Is anyone working on it?

Cheers,
Muli
