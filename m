Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0BOOQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:16:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0BOOQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:16:36 -0500
Date: Mon, 15 Feb 2010 09:16:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: reorder cfq_queue removing padding on 64bit &
	allowing more objects/slab in it's kmem_cache
Message-ID: <20100215141626.GB5355@redhat.com>
References: <1266243036.2149.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266243036.2149.21.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 02:10:36PM +0000, Richard Kennedy wrote:
> This removes 8 bytes of padding from struct cfq_queue on 64 bit builds,
> shrinking it's size to 256 bytes, so fitting into 1 fewer cachelines and
> allowing 1 more object/slab in it's kmem_cache.
>  
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ----
> patch against 2.6.33-rc8
> tested on x86_64 AMDX2
> 
> regards
> Richard
> 
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 023f4e6..db4c127 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -116,10 +116,10 @@ struct cfq_queue {
>  	unsigned long dispatch_start;
>  	unsigned int allocated_slice;
>  	/* time when first request from queue completed and slice started. */
> +	unsigned int slice_dispatch;

Can you move it above the comment. The comment describes "slice_start" and
now comment and variable have been separated.

Vivek

>  	unsigned long slice_start;
>  	unsigned long slice_end;
>  	long slice_resid;
> -	unsigned int slice_dispatch;
>  
>  	/* pending metadata requests */
>  	int meta_pending;
> @@ -130,13 +130,13 @@ struct cfq_queue {
>  	unsigned short ioprio, org_ioprio;
>  	unsigned short ioprio_class, org_ioprio_class;
>  
> +	pid_t pid;
> +
>  	unsigned int seek_samples;
>  	u64 seek_total;
>  	sector_t seek_mean;
>  	sector_t last_request_pos;
>  
> -	pid_t pid;
> -
>  	struct cfq_rb_root *service_tree;
>  	struct cfq_queue *new_cfqq;
>  	struct cfq_group *cfqg;
> 
