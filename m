Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZFPNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZFPNFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZFPNEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:04:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZFPNEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:04:48 -0400
Date: Tue, 16 Jun 2009 09:02:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/19] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090616130227.GA10730@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-3-git-send-email-vgoyal@redhat.com> <4A37175C.80906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37175C.80906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:54:04AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +int elv_nr_busy_rt_ioq(struct elevator_queue *e)
> > +{
> > +	return e->efqd.busy_rt_queues;
> > +}
> > +EXPORT_SYMBOL(elv_nr_busy_rt_ioq);
> 
> This function is no need now.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Queued for next posting.

Thanks
Vivek

> ---
>  block/elevator-fq.c |    6 ------
>  block/elevator-fq.h |    1 -
>  2 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index f33155c..912ac6a 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2553,12 +2553,6 @@ int elv_nr_busy_ioq(struct elevator_queue *e)
>  }
>  EXPORT_SYMBOL(elv_nr_busy_ioq);
>  
> -int elv_nr_busy_rt_ioq(struct elevator_queue *e)
> -{
> -	return e->efqd.busy_rt_queues;
> -}
> -EXPORT_SYMBOL(elv_nr_busy_rt_ioq);
> -
>  int elv_hw_tag(struct elevator_queue *e)
>  {
>  	return e->efqd.hw_tag;
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 0939735..285a1ff 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -711,7 +711,6 @@ extern void io_group_set_async_queue(struct io_group *iog, int ioprio_class,
>  extern struct io_group *io_get_io_group(struct request_queue *q,
>  					struct bio *bio, int create);
>  extern int elv_nr_busy_ioq(struct elevator_queue *e);
> -extern int elv_nr_busy_rt_ioq(struct elevator_queue *e);
>  extern struct io_queue *elv_alloc_ioq(struct request_queue *q, gfp_t gfp_mask);
>  extern void elv_free_ioq(struct io_queue *ioq);
>  
> -- 
> 1.5.4.rc3
> 
