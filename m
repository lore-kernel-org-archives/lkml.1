Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXKHS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXKHS4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761348AbXKHS41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:56:27 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43990 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761227AbXKHS40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:56:26 -0500
Date: Thu, 8 Nov 2007 10:56:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
In-Reply-To: <20071108145044.GB2591@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081053250.8954@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com>
 <20071108145044.GB2591@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> On (06/11/07 17:11), Christoph Lameter didst pronounce:
> > We need the defrag ratio for the non NUMA situation now. The NUMA defrag works
> > by allocating objects from partial slabs on remote nodes. Rename it to
> > 
> > 	remote_node_defrag_ratio
> > 
> 
> I'm not too keen on the defrag name here largely because I cannot tell what
> it has to do with defragmention or ratios. It's really about working out
> when it is better to pack objects into a remote slab than reclaim objects
> from a local slab, right? It's also not clear what it is a ratio of what to
> what. I thought it might be clock cycles but that isn't very clear either.
> If we are renaming this can it be something like remote_packing_cost_limit ?

In a NUMA situation we have a choice between 

1. Allocating a page from the local node (which consumes more memory and 
is advantageous performance wise.

2. Not allocating from the local node but see if any other node has 
   available partially allocated slabs. If we allocate from them then
   we save memory and reduce the amount of partial slabs on the remote 
   node. Thus the fragmentation ratio is reduced.
 
> How about
> 
> /*
>  * When packing objects into slabs, it may become necessary to
>  * reclaim objects on a local slab or allocate from a remote node.
>  * The remote_packing_cost_limit is the maximum cost of remote
>  * accesses that should be paid before it becomes worthwhile to
>  * reclaim instead
>  */
> int remote_packing_cost_limit;
> 
> ?

That is not what this is about. And the functionality has been in SLUB 
since the beginning.
