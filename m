Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbXINCib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbXINCib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 22:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXINCiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 22:38:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38983 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbXINCiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 22:38:20 -0400
Date: Thu, 13 Sep 2007 19:38:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070913094030.GA22778@skynet.ie>
Message-ID: <Pine.LNX.4.64.0709131934310.12159@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111617.03586.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com>
 <200709121246.08833.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
 <20070913094030.GA22778@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Mel Gorman wrote:

> Surely, we'll be able to detect the situation where the memory is really
> contiguous as a fast path and have a slower path where fragmentation was
> a problem.

Yes I have a draft here now of a virtual compound page solution that I am 
testing with SLUB. Page allocator first tries to allocate a contiguous 
page. If that is not possible then we string together a contiguous page 
through order 0 allocs and vmalloc.
 
> The only implementation question about these patches that hasn't been addressed
> is the mmap() support. What's wrong with it in it's current form. Can it be
> fixed or if it's fundamentally screwed etc. That has fallen by the
> wayside.

Yes I have not heard about those. Got some more ideas how to clean it up 
even more in the meantime. No feedback usually means no objections..... 

> I am *very* wary of using reserve pools for anything other than
> emergency situations. If nothing else pools == wasted memory + a sizing
> problem. But hey, it is one option.

Well we need the page pools anyways for large page sizes > MAX_ORDER. But 

> Are we going to agree on some sort of plan or are we just going to
> handwave ourselves to death?

Ill try to do the virtual mapped compound pages. Hopefully that will 
allow fallback for compound pages in a generic way.
