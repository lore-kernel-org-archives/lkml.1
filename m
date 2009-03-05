Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZCEHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZCEHEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZCEHEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:04:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:47079 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZCEHEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:04:11 -0500
Date: Thu, 5 Mar 2009 08:04:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] loop: don't increment p->offset with (size_t) -EINVAL
Message-ID: <20090305070409.GM11787@kernel.dk>
References: <49AE8227.9050703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AE8227.9050703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04 2009, Roel Kluin wrote:
> Upon a 'transfer error block' size is set to -EINVAL, but this becomes positive
> since size is unsigned: p->offset still gets incremented.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index edbaac6..bf03455 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -392,8 +392,7 @@ lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
>  	struct loop_device *lo = p->lo;
>  	struct page *page = buf->page;
>  	sector_t IV;
> -	size_t size;
> -	int ret;
> +	int size, ret;
>  
>  	ret = buf->ops->confirm(pipe, buf);
>  	if (unlikely(ret))

Good catch! Applied.

-- 
Jens Axboe

