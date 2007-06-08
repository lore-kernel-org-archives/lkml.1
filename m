Return-Path: <linux-kernel-owner+w=401wt.eu-S1032128AbXFHUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032128AbXFHUob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968104AbXFHUoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:44:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:2487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967489AbXFHUoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="254884063"
Date: Fri, 8 Jun 2007 13:40:33 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608204033.GS17143@linux-os.sc.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org> <20070608201200.GA641@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608201200.GA641@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:12:00PM -0700, Keshavamurthy, Anil S wrote:
> The resource pool indeed provide extra robustness, the initial pool size will
> be equal to min_count + grow_count. If the pool object count goes below
> min_count, then pool grows in the background while serving as emergency
> pool with min_count of objects in it. If we run out of emergency pool objects
> before the pool grow in the background, then we go to OS for allocation.
> 
> Similary, if the pool objects grows above the max threshold,
> the objects are freed to OS in the background thread maintaining
> the pool objects close to min_count + grow_count size.

slab already has this and it has additional functionalities like reaping
over time, when there is no activity...

> We need several objects of size say( 4 * sizeof(u64)) and reuse
> them in dma map/unmap api calls for managing io virtual allocation address that
> this driver has dished out. Hence having pool of objects where we put 
> the element in the linked list and and get it from the linked list is pretty
> fast compared to slab.

Not sure how is this fast compared to slab. Atleast slab is lockless in the
fast case..

> We had this kmem_cache_alloc() with mempool concept earlier and Andi suggest to 
> come up with something pre-allocated pool.  
> Andi, Can you chime in please.

In the initial patches, only for iova we were using slabs + mempool. But
for others like pgtable_mempool, we were using simple mempools.

Even slabs + mempool is not same as just usng slab.. slab is lockless
for the fast case.

thanks,
suresh
