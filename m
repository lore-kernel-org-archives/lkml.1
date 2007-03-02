Return-Path: <linux-kernel-owner+w=401wt.eu-S2992659AbXCBR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659AbXCBR2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992662AbXCBR2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:28:23 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:34268 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992659AbXCBR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:28:22 -0500
Date: Fri, 2 Mar 2007 17:28:18 +0000
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302172818.GA15730@skynet.ie>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <20070302163206.GA1555@skynet.ie> <Pine.LNX.4.64.0703020916330.16719@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703020916330.16719@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/03/07 09:19), Christoph Lameter didst pronounce:
> On Fri, 2 Mar 2007, Mel Gorman wrote:
> 
> > However, if that is objectionable, I'd at least like to see zone-based patches
> > go into -mm on the expectation that the memory hot-remove patches will be
> > able to use the infrastructure. It's not ideal for hugepages and it is not my
> > first preference, but it's a step in the right direction. Is this reasonable?
> 
> I still think that the list based approach is sufficient for memory 
> hotplug if one restricts  the location of the unmovable MAX_ORDER chunks 
> to not overlap the memory area where we would like to be able to remove 
> memory.

Yes, true. In the part where I bias placements of unmovable pages at
lower PFNs, additional steps would need to be taken. Specifically, the
lowest block MAX_ORDER_NR_PAGES used for movable pages would need to be
reclaimed for unmovable allocations.

> In very pressing memory situations where we have too much 
> unmovable memory we could dynamically disable  memory hotplug. There 
> would be no need for this partitioning and additional zones.
> 

It's simply more complex. I believe it's doable. The main plus going for
the zone is that it is a clearly understood concept and it gives hard
guarantees.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
