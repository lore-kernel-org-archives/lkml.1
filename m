Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbXHaHRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbXHaHRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXHaHRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:17:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60940 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbXHaHRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:17:40 -0400
Date: Fri, 31 Aug 2007 00:17:38 -0700 (PDT)
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
In-Reply-To: <20070831071142.GI29452@kernel.dk>
Message-ID: <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com>
 <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
 <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com>
 <20070831071142.GI29452@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Jens Axboe wrote:

> > Could you be more specific?
> 
> Size of a single segment, for instance. Or if the bio crosses a dma
> boundary. If your block is 64kb and the maximum segment size is 32kb,
> then you would need to clone the bio and split it into two.

A DMA boundary cannot be crossed AFAIK. The compound pages are aligned to 
the power of two boundaries and the page allocator will not create pages 
that cross the zone boundaries.

It looks like the code will correctly signal a failure if you try to write 
a 64k block on a device with a maximum segment size of 32k. Isnt this 
okay? One would not want to use a larger block size than supported by the 
underlying hardware?

> Things like that. This isn't a problem with single page requests, as we
> based the lower possible boundaries on that.

submit_bh() is used to submit a single buffer and I think that was our 
main concern here.
