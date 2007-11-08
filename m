Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbXKHUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbXKHUK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbXKHUKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:10:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38543 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013AbXKHUKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:10:49 -0500
Date: Thu, 8 Nov 2007 20:10:47 +0000
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
Message-ID: <20071108201047.GE23882@skynet.ie>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com> <20071108145044.GB2591@skynet.ie> <Pine.LNX.4.64.0711081053250.8954@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711081053250.8954@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/11/07 10:56), Christoph Lameter didst pronounce:
> On Thu, 8 Nov 2007, Mel Gorman wrote:
> 
> > On (06/11/07 17:11), Christoph Lameter didst pronounce:
> > > We need the defrag ratio for the non NUMA situation now. The NUMA defrag works
> > > by allocating objects from partial slabs on remote nodes. Rename it to
> > > 
> > > 	remote_node_defrag_ratio
> > > 
> > 
> > I'm not too keen on the defrag name here largely because I cannot tell what
> > it has to do with defragmention or ratios. It's really about working out
> > when it is better to pack objects into a remote slab than reclaim objects
> > from a local slab, right? It's also not clear what it is a ratio of what to
> > what. I thought it might be clock cycles but that isn't very clear either.
> > If we are renaming this can it be something like remote_packing_cost_limit ?
> 
> In a NUMA situation we have a choice between 
> 
> 1. Allocating a page from the local node (which consumes more memory and 
> is advantageous performance wise.
> 
> 2. Not allocating from the local node but see if any other node has 
>    available partially allocated slabs. If we allocate from them then
>    we save memory and reduce the amount of partial slabs on the remote 
>    node. Thus the fragmentation ratio is reduced.
>  

Ok, I get the logic somewhat now, thanks.

> > How about
> > 
> > /*
> >  * When packing objects into slabs, it may become necessary to
> >  * reclaim objects on a local slab or allocate from a remote node.
> >  * The remote_packing_cost_limit is the maximum cost of remote
> >  * accesses that should be paid before it becomes worthwhile to
> >  * reclaim instead
> >  */
> > int remote_packing_cost_limit;
> > 
> > ?
> 
> That is not what this is about. And the functionality has been in SLUB 
> since the beginning.
> 

Yeah, my understanding of SLUB is crap. Sorry for the noise.

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
