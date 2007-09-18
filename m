Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbXIRUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbXIRUmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXIRUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:42:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35848 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755451AbXIRUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:42:12 -0400
Date: Tue, 18 Sep 2007 13:42:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709181010.28043.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709181337460.4318@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709161822.47879.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171504150.29993@schroedinger.engr.sgi.com>
 <200709181010.28043.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Nick Piggin wrote:

> > We can avoid all doubt in this patchset as well by adding support for
> > fallback to a vmalloced compound page.
> 
> How would you do a vmapped fallback in your patchset? How would
> you keep track of pages 2..N if they don't exist in the radix tree?

Through the vmalloc structures and through the conventions established for 
compound pages?

> What if they don't even exist in the kernel's linear mapping? It seems
> you would also require more special casing in the fault path and special
> casing in the block layer to do this.

Well yeah there is some sucky part about vmapping things (same as in yours,
possibly more in mine since its general and not specific to the page 
cache). On the other hand a generic vcompound fallback will allow us to 
use the page allocator in many places where we currently have to use 
vmalloc because the allocations are too big. It will allow us to get rid 
of most of the vmalloc uses and thereby reduce TLB pressure somewhat.

The vcompound patchset is almost ready..... Maybe bits and pieces may 
even help fsblock.
