Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbXILAE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbXILAE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 20:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXILAEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 20:04:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45393 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754619AbXILAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 20:04:42 -0400
Date: Tue, 11 Sep 2007 17:04:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@suse.de>
cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911232657.GB14675@v2.random>
Message-ID: <Pine.LNX.4.64.0709111700410.29413@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org> <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com>
 <20070911202942.GB20688@lazybastard.org> <Pine.LNX.4.64.0709111337510.26598@schroedinger.engr.sgi.com>
 <20070911232657.GB14675@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Andrea Arcangeli wrote:

> On Tue, Sep 11, 2007 at 01:41:08PM -0700, Christoph Lameter wrote:
> > The advantages of this approach over Andreas is basically that the 4k 
> > filesystems still can be used as is. 4k is useful for binaries and for 
> 
> If you mean that with my approach you can't use a 4k filesystem as is,
> that's not correct. I even run the (admittedly premature but
> promising) benchmarks on my patch on a 4k blocksized
> filesystem... Guess what, you can even still mount a 1k fs on a 2.6
> kernel.

Right you can use a 4k filesystem. The 4k blocks are buffers in a larger 
page then.
 
> The main advantage I can see in your patch is that distributions won't
> need to ship a 64k PAGE_SIZE kernel rpm (but your single rpm will be
> slower).

I would think that your approach would be slower since you always have to 
populate 1 << N ptes when mmapping a file? Plus there is a lot of wastage 
of memory because even a file with one character needs an order N page? So 
there are less pages available for the same workload.

Then you are breaking mmap assumptions of applications becaused the order 
N kernel will no longer be able to map 4k pages.  You likely need a new 
binary format that has pages correctly aligned. I know that we would need 
one on IA64 if we go beyond the established page sizes.
