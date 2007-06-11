Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXFKX4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXFKX4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXFKX4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:56:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:45960 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbXFKX4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:56:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="255733032"
Date: Mon, 11 Jun 2007 16:52:08 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611235208.GC25022@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com> <20070611141449.bfbc4769.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611141449.bfbc4769.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 02:14:49PM -0700, Andrew Morton wrote:
> On Mon, 11 Jun 2007 13:44:42 -0700
> "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > In the first implementation of ours, we had used mempools api's to 
> > allocate memory and we were told that mempools with GFP_ATOMIC is
> > useless and hence in the second implementation we came up with
> > resource pools ( which is preallocate pools) and again as I understand
> > the argument is why create another when we have slab allocation which
> > is similar to this resource pools.
> 
> Odd.  mempool with GFP_ATOMIC is basically equivalent to your
> resource-pools, isn't it?: we'll try the slab allocator and if that failed,
> fall back to the reserves.

slab allocators don;t reserve the memory, in other words this memory 
can be consumed by VM under memory pressure which we don;t want in
IOMMU case.

Nope,they both are exactly opposite. 
mempool with GFP_ATOMIC, first tries to get memory from OS and
if that fails, it looks for the object in the pool and returns.

Where as resource pool is exactly opposite of mempool, where each 
time it looks for an object in the pool and if it exist then we 
return that object else we try to get the memory for OS while 
scheduling the work to grow the pool objects. In fact, the  work
is schedule to grow the pool when the low threshold point is hit.

Hence, I still feel resource pool implementation is best choice 
for IOMMU.

-Anil
