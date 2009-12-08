Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZLHHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZLHHyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZLHHyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:54:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57384 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZLHHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:54:44 -0500
Date: Tue, 8 Dec 2009 08:54:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Optimization for close cooperating queue searching
Message-ID: <20091208075449.GK8742@kernel.dk>
References: <4B1E03AD.7060606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E03AD.7060606@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08 2009, Gui Jianfeng wrote:
> It doesn't make any sense to try to find out a close cooperating 
> queue if current cfqq is the only one in the group.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index cfb0b2f..89b5dd9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1750,6 +1750,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  		return NULL;
>  
>  	/*
> +	 * Don't search priority tree if it's the only queue in the group.
> +	 */
> +	if (cur_cfqq->cfqg->nr_cfqq == 1)
> +		return NULL;
> +
> +	/*
>  	 * We should notice if some of the queues are cooperating, eg
>  	 * working closely on the same area of the disk. In that case,
>  	 * we can group them together and don't waste time idling.
> -- 
> 1.5.4.rc3

Good point, thanks applied.

-- 
Jens Axboe

