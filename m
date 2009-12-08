Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZLHOmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZLHOmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZLHOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:42:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZLHOmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:42:39 -0500
Date: Tue, 8 Dec 2009 09:42:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Optimization for close cooperating queue searching
Message-ID: <20091208144235.GA28615@redhat.com>
References: <4B1E03AD.7060606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E03AD.7060606@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 03:43:41PM +0800, Gui Jianfeng wrote:
> It doesn't make any sense to try to find out a close cooperating 
> queue if current cfqq is the only one in the group.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Looks good.

Vivek

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
