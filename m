Return-Path: <linux-kernel-owner+w=401wt.eu-S1030848AbXAZRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848AbXAZRC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030861AbXAZRC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:02:26 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:60440 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030848AbXAZRCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:02:24 -0500
Date: Fri, 26 Jan 2007 09:02:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <Pine.LNX.4.64.0701261629050.23091@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260855560.6966@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260812150.6141@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261629050.23091@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Mel Gorman wrote:

> > For arches that do not have HIGHMEM other zones would be okay too it
> > seems.
> It would, but it'd obscure the code to take advantage of that.

No MOVABLE memory for 64 bit platforms that do not have HIGHMEM right now?

> The anti-fragmentation code could potentially be used to have subzone groups
> that kept movable and unmovable allocations as far apart as possible and at
> opposite ends of a zone. That approach has been kicked a few times because of
> complexity.

Hmm... But his patch also introduces additional complexity plus its 
difficult to handle for the end user.

> > There are some NUMA architectures that are not that
> > symmetric.
> I know, it's why find_zone_movable_pfns_for_nodes() is as complex as it is.
> The mechanism spreads the unmovable memory evenly throughout all nodes. In the
> event some nodes are too small to hold their share, the remaining unmovable
> memory is divided between the nodes that are larger.

I would have expected a percentage of a node. If equal amounts of 
unmovable memory are assigned to all nodes at first then there will be 
large disparities in the amount of movable memories f.e. between a node 
with 8G memory compared to a node with 1GB memory.

How do you handle headless nodes? I.e. memory nodes with no processors? 
Those may be particularly large compared to the rest but these are mainly 
used for movable pages since unmovable things like device drivers buffers
have to be kept near the processors that take the interrupt.
