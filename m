Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXD0Drp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXD0Drp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXD0Drp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:47:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225AbXD0Drn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:47:43 -0400
Date: Thu, 26 Apr 2007 20:47:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3 (mmap conceptual discussion)
In-Reply-To: <20070426195357.597ffd7e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704262040280.28253@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andrew Morton wrote:

> > Sure, that addresses the larger I/O side of things, but it doesn't address
> > the large filesystem blocksize issues that can only be solved with some kind
> > of page aggregation abstraction.
> 
> a) That wasn't a part of Christoph's original rationale list, so forgive
>    me for thinking it is not so important and got snuck in post-facto when
>    things got tough.

It was definitely part of my thinking. I never thought anyone could do it 
differently so I did not emphasize it.
 
> b) I don't immediately see why a filesystam cannot implement larger
>    blocksizes via this scheme - instantiate and lock four pages and go for
>    it.
> 
> > Compound pages and high order page cache
> > indexing solves this extremely neatly, regardless of whether the compound
> > page is contiguous or not.....
> 
> We cannot say anything about neatness until we've seen mmap.

Rough Draft was posted at 
http://marc.info/?l=linux-kernel&m=117709695522443&w=2
http://marc.info/?l=linux-kernel&m=117709215016822&w=2
http://marc.info/?l=linux-kernel&m=117709238129124&w=2

Basically 4k mmap semantics are preserved. One can mmap any 4k section of 
a compound page. state information is kept in the head page. So we have two
page struct pointers to juggle

1. The one pointing to the page for address calculations COW etc.

2. The one pointing to the head page for state information.

For each 4k pointer from a process to a compound page we would 
have to take a refcount.
