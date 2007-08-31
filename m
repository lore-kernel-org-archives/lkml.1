Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXHaG5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXHaG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 02:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763663AbXHaG4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 02:56:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28919 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760921AbXHaG4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 02:56:16 -0400
Date: Fri, 31 Aug 2007 08:56:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
Message-ID: <20070831065613.GH29452@kernel.dk>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com> <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30 2007, Christoph Lameter wrote:
> This may already be handled?
> 
> submit_bh() calls submit_bio() which calls __generic_make_request() and 
> there we do:
> 
>                 if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
>                         printk("bio too big device %s (%u > %u)\n",
>                                 bdevname(bio->bi_bdev, b),
>                                 bio_sectors(bio),
>                                 q->max_hw_sectors);
>                         goto end_io;
>                 }
> 
> So if we try to push a too large buffer down with submit_bh() we get a 
> failure.

Only partly, you may be violating a number of other restrictions (size
is many things, not just length of the data).

-- 
Jens Axboe

