Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZFENXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZFENXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZFENWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:22:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZFENWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:36 -0400
Date: Fri, 5 Jun 2009 09:21:44 -0400
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
Subject: Re: [PATCH 05/20] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Message-ID: <20090605132144.GB3491@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-6-git-send-email-vgoyal@redhat.com> <4A28E710.5080307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28E710.5080307@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:36:16PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +#ifdef CONFIG_GROUP_IOSCHED
> > +extern int io_group_allow_merge(struct request *rq, struct bio *bio);
> > +extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> 
> io_ioq_move is not used anymore, removing the dead code.
> 

Thanks Gui. Will include the patch in next posting.

Vivek

> Singed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.h |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 1c99e83..24a3af9 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -537,8 +537,6 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
>  
>  #ifdef CONFIG_GROUP_IOSCHED
>  extern int io_group_allow_merge(struct request *rq, struct bio *bio);
> -extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> -					struct io_group *iog);
>  static inline bfq_weight_t iog_weight(struct io_group *iog)
>  {
>  	return iog->entity.weight;
> @@ -588,15 +586,6 @@ static inline int update_requeue(struct io_queue *ioq, int requeue)
>  }
>  
>  #else /* !GROUP_IOSCHED */
> -/*
> - * No ioq movement is needed in case of flat setup. root io group gets cleaned
> - * up upon elevator exit and before that it has been made sure that both
> - * active and idle tree are empty.
> - */
> -static inline void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> -					struct io_group *iog)
> -{
> -}
>  
>  static inline int io_group_allow_merge(struct request *rq, struct bio *bio)
>  {
> -- 
> 1.5.4.rc3
> 
