Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXFZPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXFZPBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXFZPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:01:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:53439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbXFZPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:01:10 -0400
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070625234550.058635cb.akpm@linux-foundation.org>
	<200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 26 Jun 2007 17:56:49 +0200
In-Reply-To: <20070626111324.GB4320@rhun.ibm.com>
Message-ID: <p73645a675q.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda <muli@il.ibm.com> writes:

> On Tue, Jun 26, 2007 at 09:12:45AM +0200, Andi Kleen wrote:
> 
> > There are some potential performance benefits too:
> > - When you have a device that cannot address the complete address range
> > an IOMMU can remap its memory instead of bounce buffering. Remapping
> > is likely cheaper than copying. 
> 
> But those devices aren't likely to be found on modern systems.

Not true. I don't see anybody designing DAC capable USB or firewire
or sound or TV cards. And there are plenty of non AHCI SATA interfaces too
(often the BIOS defaults are this way because XP doesn't deal
well with AHCI). And video cards generally don't support it 
(although they don't like IOMMUs either). Just these devices all might 
not be performance relevant (except for the video cards) 

> > - The IOMMU can merge sg lists into a single virtual block. This could
> > potentially speed up SG IO when the device is slow walking SG lists.
> > [I long ago benchmarked 5% on some block benchmark with an old
> > MPT Fusion; but it probably depends a lot on the HBA]
> 
> But most devices are SG-capable.

Your point being? It depends on if the SG hardware is slow
enough that it makes a difference. I found one case where that
was true, but it's unknown how common that is.

Only benchmarks can tell.

Also my results were on a pretty slow IOMMU implementation
so with a fast one it might be different too.

> How much? we have numbers (to be presented at OLS later this week)
> that show that on bare-metal an IOMMU can cost as much as 15%-30% more
> CPU utilization for an IO intensive workload (netperf). It will be
> interesting to see comparable numbers for VT-d.

That is something that needs more work.

We should probably have a switch to use the IOMMU only for specific
devices (e.g. for the KVM case) r only when remapping is needed. Only
boot options for this is probably not good enough. But that is something
that can be worked on once everything is in tree.

Also the user interface for X server case needs more work.

-Andi
