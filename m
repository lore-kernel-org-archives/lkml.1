Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXHaHdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXHaHdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXHaHdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:33:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41051 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756AbXHaHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:33:32 -0400
Date: Fri, 31 Aug 2007 00:33:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Dmitry Monakhov <dmonakhov@sw.ru>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
In-Reply-To: <20070831072611.GK29452@kernel.dk>
Message-ID: <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com>
 <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
 <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com>
 <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
 <20070831072611.GK29452@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Jens Axboe wrote:

> > A DMA boundary cannot be crossed AFAIK. The compound pages are aligned to 
> > the power of two boundaries and the page allocator will not create pages 
> > that cross the zone boundaries.
> 
> With a 64k page and a dma boundary of 0x7fff, that's two segments.

Ok so DMA memory restrictions not conforming to the DMA zones? The 
example is a bit weird. DMA only to the first 32k of memory? If the limit 
would be higher like 16MB then we would not have an issue. Is there really 
a device that can only do I/O to the first 32k of memory?

How do we split that up today? We could add processing to submit_bio to 
check for the boundary and create two bios.

> > submit_bh() is used to submit a single buffer and I think that was our 
> > main concern here.
> 
> And how large can that be?

As large as mkxxxfs allowed it to be. For XFS and extX with the current 
patchset 32k is the limit (64k with the fixes to ext2) but a new 
filesystem could theoretically use a larger blocksize.


