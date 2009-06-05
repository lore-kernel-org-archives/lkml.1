Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZFENYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZFENYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZFENX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:23:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZFENXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:23:55 -0400
Date: Fri, 5 Jun 2009 09:22:11 -0400
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
Subject: Re: [PATCH 10/20] io-conroller: Prepare elevator layer for single
	queue schedulers
Message-ID: <20090605132211.GC3491@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-11-git-send-email-vgoyal@redhat.com> <4A28E293.90402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28E293.90402@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:17:07PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > +				e->ops->elevator_free_sched_queue_fn(e,
> > +							sched_q);
> > +				sched_q = NULL;
> > +				goto queue_fail;
> > +			}
> > +		}
> > +
> > +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
> 
> It's better to use IOPRIO_NORM here.
> 

Sure. Queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index f1179aa..3c5f9da 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2403,7 +2403,8 @@ alloc_ioq:
>  			}
>  		}
>  
> -		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
> +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE,
> +			     IOPRIO_NORM, 1);
>  		io_group_set_ioq(iog, ioq);
>  		elv_mark_ioq_sync(ioq);
>  		elv_get_iog(iog);
> -- 
> 1.5.4.rc3
