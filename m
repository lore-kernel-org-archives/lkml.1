Return-Path: <linux-kernel-owner+w=401wt.eu-S966279AbXHaTAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966279AbXHaTAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965984AbXHaTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:00:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21388 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965978AbXHaTAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:00:22 -0400
Date: Fri, 31 Aug 2007 21:00:17 +0200
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
Message-ID: <20070831190017.GB29452@kernel.dk>
References: <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com> <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com> <20070831072611.GK29452@kernel.dk> <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com> <20070831074338.GL29452@kernel.dk> <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com> <20070831081201.GO29452@kernel.dk> <Pine.LNX.4.64.0708310821140.16456@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310821140.16456@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31 2007, Christoph Lameter wrote:
> On Fri, 31 Aug 2007, Jens Axboe wrote:
> 
> > > Ok. So another solution maybe to limit the blocksizes that can be used 
> > > with a device?
> > 
> > That'd work for creation, but not for moving things around.
> 
> What do you mean by moving things around? Creation binds a filesystem to a 
> device.

Only the bottom part. Change controller, move disk, whatever. There are
lots of ways to change part of the IO path.

> > > Hmmmm.. We could keep the existing scheme too and check that device 
> > > drivers split things up if they are too large? Isnt it possible today
> > > to create a huge bio of 2M for huge pages and send it to a device?
> > 
> > Not sure, aren't the constituents of compound pages the basis for IO?
> 
> get_user_pages() serializes compound pages into the base pages. But doesnt 
> the I/O layer coalesce these later into 2M chunks again?

You pretty much hit the nail on the head there yourself. The io layer
_may_ coalesce them all together, but it may also stop at am arbitrary
point and put the remainder in another request.

This situation is different from submitting one huge piece, the above is
what has always happened regardless of whether the origin happens to be
a compound page or not.

-- 
Jens Axboe

