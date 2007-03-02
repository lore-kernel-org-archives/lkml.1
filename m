Return-Path: <linux-kernel-owner+w=401wt.eu-S2992675AbXCBRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992675AbXCBRsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992679AbXCBRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:48:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53138 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992675AbXCBRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:48:20 -0500
Date: Fri, 2 Mar 2007 09:48:17 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302172818.GA15730@skynet.ie>
Message-ID: <Pine.LNX.4.64.0703020942550.17017@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <20070302163206.GA1555@skynet.ie> <Pine.LNX.4.64.0703020916330.16719@schroedinger.engr.sgi.com>
 <20070302172818.GA15730@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Mel Gorman wrote:

> > I still think that the list based approach is sufficient for memory 
> > hotplug if one restricts  the location of the unmovable MAX_ORDER chunks 
> > to not overlap the memory area where we would like to be able to remove 
> > memory.
> 
> Yes, true. In the part where I bias placements of unmovable pages at
> lower PFNs, additional steps would need to be taken. Specifically, the
> lowest block MAX_ORDER_NR_PAGES used for movable pages would need to be
> reclaimed for unmovable allocations.

I think sparsemem can provide some memory maps that show where there are 
section of memory that are hot pluggable. So the MAX_ORDER blocks need
to be categorized as to whether they are in such a section or not. If you 
need another MAX_ORDER block for an unmovable type of allocation then make 
sure that it is not marked as hotpluggable by sparsemem. If we are in an 
emergency situation were we must use a MAX_ORDER block that is currently 
hotpluggable for unmovable allocations then we need to trigger something 
in sparsmem that disabled hotplug for that memory section.

> It's simply more complex. I believe it's doable. The main plus going for
> the zone is that it is a clearly understood concept and it gives hard
> guarantees.

And it gives the sysadmin headaches and increases management VM management 
overhead because we now have more bits in the page struct that tell us 
about the zone that the page belongs to. Another distinction to worry 
about in the VM. If the limit is set too high then we have memory that is 
actually movable but since its on the wrong side of the limit we cannot 
use it. If the limit is set too low then the systewm will crash.


