Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbXIKVxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbXIKVxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbXIKVws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:52:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36171 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755883AbXIKVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:52:47 -0400
Date: Tue, 11 Sep 2007 14:52:45 -0700 (PDT)
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
In-Reply-To: <200709111606.10873.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111530.16136.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111439280.27023@schroedinger.engr.sgi.com>
 <200709111606.10873.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> > No you have not explained why the theoretical issues continue to exist
> > given even just considering Lumpy Reclaim in .23 nor what effect the
> > antifrag patchset would have.
> 
> So how does lumpy reclaim, your slab patches, or anti-frag have
> much effect on the worst case situation? Or help much against a
> targetted fragmentation attack?

F.e. Lumpy reclaim reclaim neighboring pages and thus works against 
fragmentation. So your formulae no longer works.

> > And you have used a 2M pagesize which is 
> > irrelevant to this patchset that deals with blocksizes up to 64k. In my
> > experience the use of blocksize < PAGE_COSTLY_ORDER (32k) is reasonably
> > safe.
> 
> I used EXACTLY the page sizes that you brought up in your patch
> description (ie. 64K and 2MB).

The patch currently only supports 64k. There is hope that it will support 
2M at some point and as mentioned also a special large page pool facility 
may be required.

Quoting from the post:

I would like to increase the supported blocksize to very large pages in 
the future so that device drives will be capable of providing large 
contiguous mapping. For that purpose I think that we need a mechanism to 
reserve pools of varying large sizes at boot time. Such a mechanism can 
also be used to compensate in situations where one wants to use larger 
buffers but defragmentation support is not (yet?) capable to reliably 
provide pages of the desired sizes.


