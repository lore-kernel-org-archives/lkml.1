Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZDOJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZDOJIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZDOJIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:08:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51055 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZDOJIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:08:11 -0400
Date: Wed, 15 Apr 2009 11:08:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] brd: support barriers
Message-ID: <20090415090810.GU5178@kernel.dk>
References: <20090415082707.GA7685@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415082707.GA7685@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Nick Piggin wrote:
> Hi Jens,
> Do you have a tree I can send this though? Is this the right way to
> do what I want?

It'll let the barriers through, so I think it does what you want :-)
I can put it in the block tree.

> 
> --
> 
> brd is always ordered (not that it matters, as it is defined not to
> survive when the system goes down). So tell the block layer it is
> ordered, which might be of help with testing filesystems.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  drivers/block/brd.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/block/brd.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/brd.c
> +++ linux-2.6/drivers/block/brd.c
> @@ -436,6 +436,7 @@ static struct brd_device *brd_alloc(int
>  	if (!brd->brd_queue)
>  		goto out_free_dev;
>  	blk_queue_make_request(brd->brd_queue, brd_make_request);
> +	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
>  	blk_queue_max_sectors(brd->brd_queue, 1024);
>  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
>  

-- 
Jens Axboe

