Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbZFKOX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbZFKOX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFKOXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:23:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZFKOXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:23:49 -0400
Date: Thu, 11 Jun 2009 10:21:56 -0400
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
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use of flat
	elevator fair queuing
Message-ID: <20090611142156.GB27892@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-5-git-send-email-vgoyal@redhat.com> <4A30A05C.4060703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A30A05C.4060703@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 02:12:44PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > This patch changes cfq to use fair queuing code from elevator layer.
> > 
> 
> last_end_request in cic is of no use anymore. Get rid of it.
> 

Thanks Gui. Queued for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c       |    4 ----
>  include/linux/iocontext.h |    1 -
>  2 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5871568..705e7ba 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1170,7 +1170,6 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
>  	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask | __GFP_ZERO,
>  							q->node);
>  	if (cic) {
> -		cic->last_end_request = jiffies;
>  		INIT_LIST_HEAD(&cic->queue_list);
>  		INIT_HLIST_NODE(&cic->cic_list);
>  		cic->dtor = cfq_free_io_context;
> @@ -1794,9 +1793,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  
>  	if (!cfq_class_idle(cfqq))
>  		cfqd->last_end_request = now;
> -
> -	if (sync)
> -		RQ_CIC(rq)->last_end_request = now;
>  }
>  
>  /*
> diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
> index 1fe9d78..9c4587b 100644
> --- a/include/linux/iocontext.h
> +++ b/include/linux/iocontext.h
> @@ -39,7 +39,6 @@ struct cfq_io_context {
>  
>  	struct io_context *ioc;
>  
> -	unsigned long last_end_request;
>  	sector_t last_request_pos;
>  
>  	unsigned int seek_samples;
> -- 
> 1.5.4.rc3
> 
