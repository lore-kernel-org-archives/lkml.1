Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZFHNAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZFHNAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZFHM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:59:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54644 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZFHM7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:59:54 -0400
Date: Mon, 8 Jun 2009 08:58:23 -0400
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
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090608125823.GC3652@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com> <4A2C649C.8070806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2C649C.8070806@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:08:44AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +/* Get next queue for service. */
> > +struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
> > +{
> > +	struct elv_fq_data *efqd = &q->elevator->efqd;
> > +	struct io_entity *entity = NULL;
> > +	struct io_queue *ioq = NULL;
> > +	struct io_sched_data *sd;
> > +
> > +	/*
> > +	 * one can check for which queue will be selected next while having
> > +	 * one queue active. preempt logic uses it.
> > +	 */
> > +	BUG_ON(extract && efqd->active_queue != NULL);
> > +
> > +	if (!efqd->busy_queues)
> > +		return NULL;
> > +
> > +	sd = &efqd->root_group->sched_data;
> > +	if (extract)
> > +		entity = bfq_lookup_next_entity(sd, 1);
> > +	else
> > +		entity = bfq_lookup_next_entity(sd, 0);
> 
> This if and else branch is not needed.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 3c5f9da..655162b 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -3069,10 +3069,7 @@ struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
>  
>  	sd = &efqd->root_group->sched_data;
>  	for (; sd != NULL; sd = entity->my_sched_data) {
> -		if (extract)
> -			entity = bfq_lookup_next_entity(sd, 1);
> -		else
> -			entity = bfq_lookup_next_entity(sd, 0);
> +		entity = bfq_lookup_next_entity(sd, extract);
>  
>  		/*
>  		 * entity can be null despite the fact that there are busy

Thanks Gui. Queued for next posting.

Thanks
Vivek
