Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXFZLNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXFZLNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXFZLNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:13:35 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:34037 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXFZLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:13:33 -0400
Date: Tue, 26 Jun 2007 07:13:24 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626111324.GB4320@rhun.ibm.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706260912.45838.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 09:12:45AM +0200, Andi Kleen wrote:

> There are some potential performance benefits too:
> - When you have a device that cannot address the complete address range
> an IOMMU can remap its memory instead of bounce buffering. Remapping
> is likely cheaper than copying. 

But those devices aren't likely to be found on modern systems.

> - The IOMMU can merge sg lists into a single virtual block. This could
> potentially speed up SG IO when the device is slow walking SG lists.
> [I long ago benchmarked 5% on some block benchmark with an old
> MPT Fusion; but it probably depends a lot on the HBA]

But most devices are SG-capable.

> And you get better driver debugging because unexpected memory
> accesses from the devices will cause an trapable event.

That and direct-access for KVM the big ones, IMHO, and definitely
justify merging.

> > Does it slow anything down?
> 
> It adds more overhead to each IO so yes.

How much? we have numbers (to be presented at OLS later this week)
that show that on bare-metal an IOMMU can cost as much as 15%-30% more
CPU utilization for an IO intensive workload (netperf). It will be
interesting to see comparable numbers for VT-d.

Cheers,
Muli
