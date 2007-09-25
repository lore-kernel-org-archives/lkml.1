Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXIYKYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXIYKYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXIYKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:24:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46530 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbXIYKX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:23:59 -0400
Date: Tue, 25 Sep 2007 11:23:56 +0100
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, neilb@suse.de, Geert.Uytterhoeven@sonycom.com,
       geoffrey.levand@am.sony.com
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070925102356.GB8076@skynet.ie>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F812DF.4010909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <46F812DF.4010909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/09/07 01:11), Kamalesh Babulal didst pronounce:

Hi Kamalesh,

> The build fails with following error
> 
> CC drivers/block/ps3disk.o
> drivers/block/ps3disk.c: In function ???ps3disk_scatter_gather???:
> drivers/block/ps3disk.c:115: error: ???bio??? undeclared (first use in this
> function)
> drivers/block/ps3disk.c:115: error: (Each undeclared identifier is
> reported only once
> drivers/block/ps3disk.c:115: error: for each function it appears in.)
> drivers/block/ps3disk.c:115: error: ???j??? undeclared (first use in this
> function)
> drivers/block/ps3disk.c:116: error: implicit declaration of function
> ???bio_kunmap_bvec???
> make[2]: *** [drivers/block/ps3disk.o] Error 1
> make[1]: *** [drivers/block] Error 2
> make: *** [drivers] Error 2
> 
> The function bio_kunmap_bvec is missing.I tried checking the git-block.patch
> as well as the linux/kernel/git/axboe/linux-2.6-block.git and did not
> find this function.
> 
> Previously this function was replaced by __bio_kunmap_atomic();
> This patch does not solves the implicit "declaration of function
> ???bio_kunmap_bvec???"
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
> <mailto:kamalesh@linux.vnet.ibm.com>>

Your mailer appears to have mangled both your signoff and the whitespace in
the patch and it does not apply. However, fixing it does not solve the problem
because of this mysterious bio_kunmap_bvec() that is only referenced by this
driver. Was it accidently added during the addition of sg chaining support?

> ---
> 
> --- linux-2.6.23-rc7/drivers/block/ps3disk.c    2007-09-24 20:50:41.000000000 +0530
> +++ linux-2.6.23-rc7/drivers/block/~ps3disk.c   2007-09-24 20:50:59.000000000 +0530
> @@ -112,7 +112,7 @@ static void ps3disk_scatter_gather(struc
>                 else
>                         memcpy(buf, dev->bounce_buf+offset, size);
>                 offset += size;
> -               flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
> +              flush_kernel_dcache_page(bio_iovec_idx(iter.bio, iter.i)->bv_page);
>                 bio_kunmap_bvec(bvec, flags);
>                 i++;
>         }
> 
> -- 
> 
> Thanks & Regards,
> Kamalesh Babulal,
> Linux Technology Center,
> IBM, ISTL.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
