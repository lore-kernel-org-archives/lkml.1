Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXFLB5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXFLB5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXFLB5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:57:23 -0400
Received: from mga07.intel.com ([143.182.124.22]:2045 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756912AbXFLB5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="238050201"
Message-ID: <466DFD22.5080303@linux.intel.com>
Date: Mon, 11 Jun 2007 18:55:46 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>	<200706090056.49279.ak@suse.de>	<Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>	<200706091147.24705.ak@suse.de>	<20070611204442.GA4074@linux-os.sc.intel.com>	<20070611141449.bfbc4769.akpm@linux-foundation.org>	<20070611235208.GC25022@linux-os.sc.intel.com>	<20070611173001.e0355af3.akpm@linux-foundation.org>	<466DF290.2040503@linux.intel.com> <20070611183555.fe763fe4.akpm@linux-foundation.org>
In-Reply-To: <20070611183555.fe763fe4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 11 Jun 2007 18:10:40 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> Andrew Morton wrote:
>>>> Where as resource pool is exactly opposite of mempool, where each 
>>>> time it looks for an object in the pool and if it exist then we 
>>>> return that object else we try to get the memory for OS while 
>>>> scheduling the work to grow the pool objects. In fact, the  work
>>>> is schedule to grow the pool when the low threshold point is hit.
>>> I realise all that.  But I'd have thought that the mempool approach is
>>> actually better: use the page allocator and only deplete your reserve pool
>>> when the page allocator fails.
>> the problem with that is that if anything downstream from the iommu 
>> layer ALSO needs memory, we've now eaten up the last free page and 
>> things go splat.
> 
> If that happens, we still have the mempool reserve to fall back to.

we do, except that we just ate the memory the downstream code would 
use and get ... so THAT can't get any.
