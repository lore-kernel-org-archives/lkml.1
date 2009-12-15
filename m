Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbZLOOdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbZLOOdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbZLOOdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:33:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbZLOOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:33:51 -0500
Date: Tue, 15 Dec 2009 09:28:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: set workload as expired if it doesn't have any
	slice left.
Message-ID: <20091215142841.GA5811@redhat.com>
References: <4B26EC23.6020701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B26EC23.6020701@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 09:53:39AM +0800, Gui Jianfeng wrote:
> When a group is resumed, if it doesn't have workload slice left,
> we should set workload_expires as expired. Otherwise, we might
> start from where we left in previous group by error. 
> Thanks the idea from Corrado.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Looks good.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/cfq-iosched.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index f3f6239..e2f8046 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2113,7 +2113,9 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>  		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
>  		cfqd->serving_type = cfqg->saved_workload;
>  		cfqd->serving_prio = cfqg->saved_serving_prio;
> -	}
> +	} else
> +		cfqd->workload_expires = jiffies - 1;
> +
>  	choose_service_tree(cfqd, cfqg);
>  }
>  
> -- 
> 1.5.4.rc3
