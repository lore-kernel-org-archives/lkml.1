Return-Path: <linux-kernel-owner+w=401wt.eu-S1422713AbXCBBx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422713AbXCBBx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXCBBx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:53:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:39102 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965099AbXCBBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:53:26 -0500
Date: Thu, 1 Mar 2007 17:52:35 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Mel Gorman <mel@skynet.ie>
Cc: akpm@linux-foundation.org, npiggin@suse.de, clameter@engr.sgi.com,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@osdl.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302015235.GG10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Mel Gorman <mel@skynet.ie>, akpm@linux-foundation.org,
	npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
	jschopp@austin.ibm.com, arjan@infradead.org, torvalds@osdl.org,
	mbligh@mbligh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20070301101249.GA29351@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301101249.GA29351@skynet.ie>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:12:50AM +0000, Mel Gorman wrote:
> These are figures based on kernels patches with Andy Whitcrofts reclaim
> patches. You will see that the zone-based kernel is getting success rates
> closer to 40% as one would expect although there is still something amiss.

Yes, combining the two should do at least as well as either in
isolation. Are there videos of each of the two in isolation? Maybe that
would give someone insight into what's happening.


On Thu, Mar 01, 2007 at 10:12:50AM +0000, Mel Gorman wrote:
> Kernbench Total CPU Time        

Oh dear. How do the other benchmarks look?


On Thu, Mar 01, 2007 at 10:12:50AM +0000, Mel Gorman wrote:
> The patches go a long way to making sure that high-order allocations work
> and particularly that the hugepage pool can be resized once the system has
> been running. With the clustering of high-order atomic allocations, I have
> some confidence that allocating contiguous jumbo frames will work even with
> loads performing lots of IO. I think the videos show how the patches actually
> work in the clearest possible manner.
> I am of the opinion that both approaches have their advantages and
> disadvantages. Given a choice between the two, I prefer list-based
> because of it's flexibility and it should also help high-order kernel
> allocations. However, by applying both, the disadvantages of list-based are
> covered and there still appears to be no performance loss as a result. Hence,
> I'd like to see both merged.  Any opinion on merging these patches into -mm
> for wider testing?

Exhibiting a workload where the list patch breaks down and the zone
patch rescues it might help if it's felt that the combination isn't as
good as lists in isolation. I'm sure one can be dredged up somewhere.
Either that or someone will eventually spot why the combination doesn't
get as many available maximally contiguous regions as the list patch.
By and large I'm happy to see anything go in that inches hugetlbfs
closer to a backward compatibility wrapper over ramfs.


-- wli
