Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXD1DQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXD1DQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXD1DQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:16:43 -0400
Received: from holomorphy.com ([66.93.40.71]:36293 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXD1DQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:16:42 -0400
Date: Fri, 27 Apr 2007 20:16:25 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428031625.GW31925@holomorphy.com>
References: <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au> <20070427133947.GB4152@infradead.org> <4632B121.3030005@yahoo.com.au> <20070428023901.GT19966@holomorphy.com> <4632B672.90609@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632B672.90609@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> What sort of strategy do you intend to use to speculatively populate
>> the pagecache with contiguous pages?

On Sat, Apr 28, 2007 at 12:50:26PM +1000, Nick Piggin wrote:
> Andrew outlined it.

I'd like to suggest a few straightforward additions to the proposal:

(1) the interface to the page allocator tries to allocate N pages where
	(a) N is a power of 2
	(b) some effort is made to get contiguity
	(c) some effort is made to fall back to lesser contiguity
	(d) some effort is made to get N pages even with no contiguity
(2) a corresponding group freeing interface to the page allocator
(3) Pass the pages around in a list or similar so that O(1) instead of
	O(pages) splice operations under the lock suffice for passing
	them around. Dissecting compound pages outside locks helps.


-- wli
