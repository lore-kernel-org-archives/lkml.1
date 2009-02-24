Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZBXOcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZBXOcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZBXOcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:32:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49561 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbZBXOcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:32:22 -0500
Date: Tue, 24 Feb 2009 14:32:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
Message-ID: <20090224143218.GA5364@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <87ljryuij0.fsf@basil.nowhere.org> <20090223143232.GJ6740@csn.ul.ie> <20090223174947.GT26292@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090223174947.GT26292@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 06:49:48PM +0100, Andi Kleen wrote:
> > hmm, it would be ideal but I haven't looked too closely at how it could
> > be implemented. I thought first you could just associate a zonelist with
> 
> Yes like that. This was actually discussed during the initial cpuset
> implementation. I thought back then it would be better to do it
> elsewhere, but changed my mind later when I saw the impact on the
> fast path.
> 

Back then there would have been other anomolies as well such as
MPOL_BIND using zones in the wrong order. Zeroing would still have
dominated the cost of the allocation and slab would hide other details.
Hindsight is 20/20 and all that.

Right now, I don't think cpusets are a dominant factor for most setups but
I'm open to being convinced otherwise. For now, I'm happy if it's just shoved
a bit more to the side in the non-cpuset case. Like the CPU cache hot/cold
path, it might be best to leave it for a second or third pass and tackle
the low-lying fruit for the first pass.

> > the cpuset but you'd need one for each node allowed by the cpuset so it
> > could get quite large. Then again, it might be worthwhile if cpusets
> 
> Yes you would need one per node, but that's not a big problem because
> systems with lots of nodes are also expected to have lots of memory.
> Most systems have a very small number of nodes.
> 

That's a fair point on the memory consumption. There might be issues
with the cache consumption but if the cpuset is being heavily used for an
allocation-intensive workload then it probably will not be noticeable.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
