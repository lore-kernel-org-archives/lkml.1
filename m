Return-Path: <linux-kernel-owner+w=401wt.eu-S2992534AbXCBPq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992534AbXCBPq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992533AbXCBPq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:46:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992532AbXCBPqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:46:25 -0500
Message-ID: <45E842F6.5010105@redhat.com>
Date: Fri, 02 Mar 2007 10:29:58 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@skynet.ie>, npiggin@suse.de, clameter@engr.sgi.com,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
In-Reply-To: <20070301160915.6da876c5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> And I'd judge that per-container RSS limits are of considerably more value
> than antifrag (in fact per-container RSS might be a superset of antifrag,
> in the sense that per-container RSS and containers could be abused to fix
> the i-cant-get-any-hugepages problem, dunno).

The RSS bits really worry me, since it looks like they could
exacerbate the scalability problems that we are already running
into on very large memory systems.

Linux is *not* happy on 256GB systems.  Even on some 32GB systems
the swappiness setting *needs* to be tweaked before Linux will even
run in a reasonable way.

Pageout scanning needs to be more efficient, not less.  The RSS
bits are worrysome...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
