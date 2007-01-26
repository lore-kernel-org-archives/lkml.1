Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXAZUor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXAZUor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161246AbXAZUon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:44:43 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:44379 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbXAZUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:44:42 -0500
Date: Fri, 26 Jan 2007 20:44:40 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Chris Friesen <cfriesen@nortel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <45BA49F2.2000804@nortel.com>
Message-ID: <Pine.LNX.4.64.0701262038120.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261720120.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260921310.7301@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261727400.23091@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260944270.7457@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261747290.23091@skynet.skynet.ie> <45BA49F2.2000804@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Chris Friesen wrote:

> Mel Gorman wrote:
>
>> Worse, the problem is to have high order contiguous blocks free at the time 
>> of allocation without reclaim or migration. If the allocations were not 
>> atomic, anti-fragmentation as it is today would be enough.
>
> Has anyone looked at marking the buffers as "needs refilling" then kick off a 
> kernel thread or something to do the allocations under GFP_KERNEL?

I haven't seen it being discussed although it's probably doable as an 
addition to the existing mempool mechanism. Anti-fragmentation would mean 
that the non-atomic GFP_KERNEL allocation had a chance of succeeding.

> That way we avoid having to allocate the buffers with GFP_ATOMIC.
>

Unless the load was so high that the pool was getting depleted and memory 
under so much pressure that reclaim could not keep up. But yes, it's 
possible that GFP_ATOMIC allocations could be avoided the majority of 
times.

> I seem to recall that the tulip driver used to do this.  Is it just too 
> complicated from a race condition standpoint?
>

It shouldn't be that complicated.

> We currently see this issue on our systems, as we have older e1000 hardware 
> with 9KB jumbo frames.  After a while we just fail to allocate buffers and 
> the system goes belly-up.
>

Can you describe a reliable way of triggering this problem? At best, I 
hear "on our undescribed workload, we sometimes see this problem" but not 
much in the way of details.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
