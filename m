Return-Path: <linux-kernel-owner+w=401wt.eu-S1030865AbXDTQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030865AbXDTQXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030924AbXDTQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:23:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33080 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030865AbXDTQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:23:23 -0400
Date: Fri, 20 Apr 2007 09:23:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <20070420141406.GB16878@skynet.ie>
Message-ID: <Pine.LNX.4.64.0704200920350.20232@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070420141406.GB16878@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Mel Gorman wrote:

> I believe there is an assumption in parts of reclaim that LRU pages are
> order-0. An interesting bug or two is likely to rear its head there.

Correct. We need to deal with reclaim etc.

> > Note that this is proof-of-concept. Lots of functionality is missing and
> > various issues have not been dealt with. Use of higher order pages may cause
> > memory fragmentation. Mel Gorman's anti-fragmentation work is probably
> > essential if we want to do this. We likely need actual defragmentation
> > support.
> > 
> 
> Ok, anti-fragmentation will help up to a point but it's awkward with ramfs
> because those pages are not reclaimable or migratable no matter what the
> order. Normal filesystems would fare much better fragmentation-wise.
> 
> The problem is that the mapping gfp_mask is normally GFP_HIGH_MOVABLE but it's
> GFP_HIGHUSER for ramfs. This patchset will increase the number of non-movable
> high-order allocations quite considerably and it will tend to fragment memory
> worse than we do currently. I can think of ways it can be dealt with 
> (even marking them RECLAIMABLE would help) so I'm not massively worried
> now but I'll keep it in mind as things develop.

Well I think we will have xfs support soon. Then we can deal with more 
issues and be more complete. What I wanted from this post was a consensus 
on how to proceed. There are many subsystems involved and I do not want to 
go off the deep end.
