Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXDTQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXDTQP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXDTQP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:15:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60867 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030332AbXDTQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:15:28 -0400
Date: Fri, 20 Apr 2007 09:15:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 3/8] Flushing and zeroing higher order page cache pages
In-Reply-To: <20070420110244.GB12075@skynet.ie>
Message-ID: <Pine.LNX.4.64.0704200910440.20232@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163520.11948.15503.sendpatchset@schroedinger.engr.sgi.com>
 <20070420110244.GB12075@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Mel Gorman wrote:

> While this looks fine, it seems that clear_huge_page() and
> clear_mapping_page() could share a common helper. I also note that
> clear_huge_page() calls cond_reched() and this doesn't which may be the
> type of different behavior we want to avoid.

I am really thinking that this variable order page cache approach 
is likely going to result in the final death of the huge page subsystem. I 
would like to keep huge pages separate from this so that the huge page 
subsystem can be removed at some point without too much trouble. Right now 
it is a very sore point at least from a performance standpoint since the 
hugetlb subsystem is serialized with a single lock. There is a weird maze 
of locking and accounting constraints in there that makes it difficult to 
fix this.

> That said, if this goes ahead, it might be an excuse to look at using
> ramfs as the basis for hugetlbfs instead of it's current approach. I
> believe using ramfs for hugepages is something that wli wants anyway.

Right. There is no reason for hugetlbfs to exist anymore. We will have 
very transparent and flexible support for huge pages.
