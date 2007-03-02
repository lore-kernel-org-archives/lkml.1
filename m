Return-Path: <linux-kernel-owner+w=401wt.eu-S964790AbXCBSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbXCBSPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXCBSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:15:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55182 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964790AbXCBSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:15:38 -0500
Date: Fri, 2 Mar 2007 10:15:36 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302100619.cec06d6a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <45E842F6.5010105@redhat.com> <20070302085838.bcf9099e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>
 <20070302093501.34c6ef2a.akpm@linux-foundation.org> <45E8624E.2080001@redhat.com>
 <20070302100619.cec06d6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Andrew Morton wrote:

> > One particular case is a 32GB system with a database that takes most
> > of memory.  The amount of actually freeable page cache memory is in
> > the hundreds of MB.
> 
> Where's the rest of the memory? tmpfs?  mlocked?  hugetlb?

The memory is likely in use but there is enough memory free in unmapped 
clean pagecache pages so that we occasionally are able to free pages. Then 
the app is reading more from disk replenishing that ...
Thus we are forever cycling through the LRU lists moving pages between 
the lists aging etc etc. Can lead to a livelock.

> > A third scenario is where a system has way more RAM than swap, and not
> > a whole lot of freeable page cache.  In this case, the VM ends up
> > spending WAY too much CPU time scanning and shuffling around essentially
> > unswappable anonymous memory and tmpfs files.
> 
> Well we've allegedly fixed that, but it isn't going anywhere without
> testing.

We have fixed the case in which we compile the kernel without swap. Then 
anonymous pages behave like mlocked pages. Did we do more than that?

