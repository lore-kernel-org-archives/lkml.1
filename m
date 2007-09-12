Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbXILXR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbXILXR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXILXRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:17:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbXILXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:17:48 -0400
Date: Wed, 12 Sep 2007 16:17:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709121246.08833.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111617.03586.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com>
 <200709121246.08833.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Nick Piggin wrote:

> I will still argue that my approach is the better technical solution for large
> block support than yours, I don't think we made progress on that. And I'm
> quite sure we agreed at the VM summit not to rely on your patches for
> VM or IO scalability.

The approach has already been tried (see the XFS layer) and found lacking. 

Having a fake linear block through vmalloc means that a special software 
layer must be introduced and we may face special casing in the block / fs 
layer to check if we have one of these strange vmalloc blocks.

> But you just showed in two emails that you don't understand what the
> problem is. To reiterate: lumpy reclaim does *not* invalidate my formulae;
> and antifrag does *not* isolate the issue.

I do understand what the problem is. I just do not get what your problem 
with this is and why you have this drive to demand perfection. We are 
working a variety of approaches on the (potential) issue but you 
categorically state that it cannot be solved.

> But what do you say about viable alternatives that do not have to
> worry about these "unlikely scenarios", full stop? So, why should we
> not use fs block for higher order page support?

Because it has already been rejected in another form and adds more 
layering to the filesystem and more checking for special cases in which 
we only have virtual linearity? It does not reduce the number of page 
structs that have to be handled by the lower layers etc.

Maybe we coud get to something like a hybrid that avoids some of these 
issues? Add support so something like a virtual compound page can be 
handled transparently in the filesystem layer with special casing if 
such a beast reaches the block layer?

> I didn't skip that. We have large page pools today. How does that give
> first class of support to those allocations if you have to have memory
> reserves?

See my other mail. That portion is not complete yet. Sorry.
