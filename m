Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXCEQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXCEQpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbXCEQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:45:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35463 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXCEQpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:45:33 -0500
Message-ID: <45EC4924.2050104@austin.ibm.com>
Date: Mon, 05 Mar 2007 10:45:24 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       clameter@engr.sgi.com, mingo@elte.hu, arjan@infradead.org,
       mbligh@mbligh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E8594B.6020904@austin.ibm.com> <20070305032116.GA29678@wotan.suse.de> <45EC352A.7060802@austin.ibm.com> <20070305160143.GB8128@wotan.suse.de>
In-Reply-To: <20070305160143.GB8128@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you only need to allocate 1 page size and smaller allocations then no 
>> it's not a problem.  As soon as you go above that it will be.  You don't 
>> need to go all the way up to MAX_ORDER size to see an impact, it's just 
>> increasingly more severe as you get away from 1 page and towards MAX_ORDER.
> 
> We allocate order 1 and 2 pages for stuff without too much problem.

The question I want to know is where do you draw the line as to what is acceptable to 
allocate in a single contiguous block?

1 page?  8 pages?  256 pages?  4K pages?  Obviously 1 page works fine. With 4K page 
size and 16MB MAX_ORDER 4K pages is theoretically supported, but doesn't work under 
almost any circumstances (unless you use Mel's patches).

> on-demand hugepages could be done better anyway by having the hypervisor
> defrag physical memory and provide some way for the guest to ask for a
> hugepage, no?

Unless you break the 1:1 virt-phys mapping it doesn't matter if the hypervisor can 
defrag this for you as the kernel will have the physical address cached away 
somewhere and expect the data not to move.

I'm a big fan of making this somebody else's problem and the hypervisor would be a 
good place.  I just can't figure out how to actually do it at that layer without 
changing Linux in a way that is unacceptable to the community at large.


