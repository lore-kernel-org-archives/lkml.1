Return-Path: <linux-kernel-owner+w=401wt.eu-S1767140AbXDTQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767140AbXDTQv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767144AbXDTQv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:51:27 -0400
Received: from holomorphy.com ([66.93.40.71]:53971 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767140AbXDTQv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:51:26 -0400
Date: Fri, 20 Apr 2007 09:51:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 3/8] Flushing and zeroing higher order page cache pages
Message-ID: <20070420165143.GY2986@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163520.11948.15503.sendpatchset@schroedinger.engr.sgi.com> <20070420110244.GB12075@skynet.ie> <Pine.LNX.4.64.0704200910440.20232@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704200910440.20232@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Mel Gorman wrote:
>> While this looks fine, it seems that clear_huge_page() and
>> clear_mapping_page() could share a common helper. I also note that
>> clear_huge_page() calls cond_reched() and this doesn't which may be the
>> type of different behavior we want to avoid.

On Fri, Apr 20, 2007 at 09:15:25AM -0700, Christoph Lameter wrote:
> I am really thinking that this variable order page cache approach 
> is likely going to result in the final death of the huge page subsystem. I 
> would like to keep huge pages separate from this so that the huge page 
> subsystem can be removed at some point without too much trouble. Right now 
> it is a very sore point at least from a performance standpoint since the 
> hugetlb subsystem is serialized with a single lock. There is a weird maze 
> of locking and accounting constraints in there that makes it difficult to 
> fix this.

It'll drive a stake through its heart, but there are a number of stupid
catches to deal with before it'll finally flush down the drain.
Existing apps will require backward compatibility wrappers for various
forms of semantic damage done over the years, some over my objections,
effectively in perpetuity. fs/hugetlbfs/ can effectively be reduced to
wrappers around a normal fs for that, but sadly I doubt the rm -rf I
want will fly barring shoving that crud into fs/ramfs/ (which people
may be loath to do).


On Fri, 20 Apr 2007, Mel Gorman wrote:
>> That said, if this goes ahead, it might be an excuse to look at using
>> ramfs as the basis for hugetlbfs instead of it's current approach. I
>> believe using ramfs for hugepages is something that wli wants anyway.

On Fri, Apr 20, 2007 at 09:15:25AM -0700, Christoph Lameter wrote:
> Right. There is no reason for hugetlbfs to exist anymore. We will have 
> very transparent and flexible support for huge pages.

Ramming hugetlb, fs and all, down the garbage disposal is the direction
I really want to go, and in precisely this manner. (Ever wondered why I
never work on extending it?) There's an easy subdivision of labor here
(apart from where I contribute otherwise). Get generic going and keep
me posted and I'll actively go about ripping out those pieces made
redundant by it all.

To date I've been blocked by the absence of collaborators. I can put
company time down on this vs. other issues which are mere spare time.


-- wli
