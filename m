Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZIOTbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZIOTbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZIOTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:31:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51411 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbZIOTbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:31:38 -0400
Date: Tue, 15 Sep 2009 21:31:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: npiggin@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] fs: make use of rcu helpers
Message-ID: <20090915193141.GT23126@kernel.dk>
References: <20090915191903.290006007@suse.de> <20090915192242.553693570@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192242.553693570@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, npiggin@suse.de wrote:
> list_add_tail_rcu contains required barriers.

Thanks, applied as well.

> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/fs-writeback.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c
> +++ linux-2.6/fs/fs-writeback.c
> @@ -152,11 +152,6 @@ static void bdi_queue_work(struct backin
>  		atomic_set(&work->pending, bdi->wb_cnt);
>  		BUG_ON(!bdi->wb_cnt);
>  
> -		/*
> -		 * Make sure stores are seen before it appears on the list
> -		 */
> -		smp_mb();
> -
>  		spin_lock(&bdi->wb_lock);
>  		list_add_tail_rcu(&work->list, &bdi->work_list);
>  		spin_unlock(&bdi->wb_lock);
> 
> 

-- 
Jens Axboe

