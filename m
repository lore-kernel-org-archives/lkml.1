Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXITSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXITSMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbXITSL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:11:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39470 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756882AbXITSL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:11:58 -0400
Date: Thu, 20 Sep 2007 11:11:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@suse.de>
cc: David Chinner <dgc@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070920145407.GY4608@v2.random>
Message-ID: <Pine.LNX.4.64.0709201108070.8626@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <1190163523.24970.378.camel@edge.yarra.acx>
 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
 <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random>
 <20070920013821.GR995458@sgi.com> <20070920145407.GY4608@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Andrea Arcangeli wrote:

> The only point of this largepage stuff is to go an extra mile to save
> a bit more of cpu vs a strict vmap based solution (fsblock of course
> will be smart enough that if it notices the PAGE_SIZE is >= blocksize
> it doesn't need to run any vmap at all and it can just use the direct
> mapping, so vmap translates in 1 branch only to check the blocksize
> variable, PAGE_SIZE is immediate in the .text at compile time). But if

Hmmm.. You are not keeping up with things? Heard of virtual compound 
pages? They only require a vmap when the page allocator fails a 
larger order allocation (which we have established is rare to the point 
of nonexistence). The next rev of large blocksize will use that for 
fallback. Plus vcompounds can be used to get rid of most uses of vmalloc 
reducing the need for virtual mapping in general.

Largeblock is a general solution for managing large data sets using a 
single page struct. See the original message that started this thread. It 
can be used for various other subsystems like vcompound can.
