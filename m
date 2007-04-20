Return-Path: <linux-kernel-owner+w=401wt.eu-S1030877AbXDTQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030877AbXDTQUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030891AbXDTQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:20:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030877AbXDTQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:20:31 -0400
Date: Fri, 20 Apr 2007 09:20:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420134226.GA16878@skynet.ie>
Message-ID: <Pine.LNX.4.64.0704200916480.20232@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
 <20070420134226.GA16878@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Mel Gorman wrote:

> So the difference here appears to be that specifying an order means you
> can't mmap(). right?
> 
> That's fair enough for the moment but relaxing would make ramfs
> potentially usable as a replacement for hugetlbfs so there would be just
> one ram-based filesystem instead of two.

Yes I have some draft of patches that enable mmap. But I think we should 
fist make the non mmap case work cleanly.

The current approach is to map higher order pages into an address space on 
a per PTE basis. A page fault will establish one pte which may point to a 
tail page of a compound page. This means that the 4k semantics are 
preserved. We essentially manage pointers into 4k sections of larger 
pages.

Later we could add support for PMD faults. If the page size is larger than
pmd size then establish pmds mapping 2M instead of ptes. But that would be 
much much later when everything else works.
