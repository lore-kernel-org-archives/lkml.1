Return-Path: <linux-kernel-owner+w=401wt.eu-S2992648AbXCBRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992648AbXCBRXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992649AbXCBRXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:23:52 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36074 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992648AbXCBRXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:23:51 -0500
Date: Fri, 2 Mar 2007 09:23:49 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302085838.bcf9099e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <45E842F6.5010105@redhat.com> <20070302085838.bcf9099e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Andrew Morton wrote:

> > Linux is *not* happy on 256GB systems.  Even on some 32GB systems
> > the swappiness setting *needs* to be tweaked before Linux will even
> > run in a reasonable way.
> 
> Please send testcases.

It is not happy if you put 256GB into one zone. We are fine with 1k nodes 
with 8GB each and a 16k page size (which reduces the number of 
page_structs to manage by a fourth). So the total memory is 8TB which is 
significantly larger than 256GB.

If we do this node/zone merging and reassign MAX_ORDER blocks to virtual 
node/zones for containers (with their own LRU etc) then this would also 
reduce the number of page_structs on the list and may make things a bit 
easier.

We would then produce the same effect as the partitioning via NUMA nodes 
on our 8TB boxes. However, then you still have a bandwidth issue since 
your 256 likely only has a single bus and all memory traffic for the 
node/zones has to go through this single bottleneck. That bottleneck does 
not exist on NUMA machines.


