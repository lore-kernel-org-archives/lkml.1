Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZHSSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZHSSlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZHSSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:41:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZHSSlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:41:36 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 14:41:36 EDT
Date: Wed, 19 Aug 2009 14:39:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 03/24] io-controller: Common flat fair queuing code in
	elevaotor layer
Message-ID: <20090819183942.GC4391@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-4-git-send-email-vgoyal@redhat.com> <4A8B7336.7010800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B7336.7010800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 11:36:22AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> 
> > +
> > +static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
> > +{
> > +	elv_log_ioq(q->elevator->efqd, ioq, "preempt");
> > +	elv_slice_expired(q);
> > +
> > +	/*
> > +	 * Put the new queue at the front of the of the current list,
> > +	 * so we know that it will be selected next.
> > +	 */
> > +
> > +	requeue_ioq(ioq);
> > +	ioq->slice_start = ioq->slice_end = 0;
> 
> I think this assignment is redundant because these two members will be reset
> when this ioq is scheduled.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

thanks Gui. Queued for next posting.

Vivek

> ---
>  block/elevator-fq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index d04e925..b3c387d 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2650,7 +2650,6 @@ static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
>  		 */
>  
>  		requeue_ioq(ioq);
> -		ioq->slice_start = ioq->slice_end = 0;
>  		elv_mark_ioq_slice_new(ioq);
>  	}
>  }
> -- 
> 1.5.4.rc3
> 
> 
