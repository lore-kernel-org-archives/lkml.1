Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZFHN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZFHN5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZFHN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:57:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40503 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbZFHN5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:57:43 -0400
Date: Mon, 8 Jun 2009 09:56:52 -0400
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
Message-ID: <20090608135652.GE3652@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com> <4A2CC15F.2010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2CC15F.2010708@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:44:31PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +static inline pid_t elv_ioq_pid(struct io_queue *ioq)
> > +{
> > +	return ioq->pid;
> > +}
> > +
> > +static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
> > +{
> > +	return ioq->ttime_mean;
> > +}
> > +
> > +static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
> > +{
> > +	return ioq_sample_valid(ioq->ttime_samples);
> > +}
> > +
> 
> These three functions are dead now, just remove them.
> 

Thanks Gui. queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.h |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 24a3af9..b2bb11a 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -452,21 +452,6 @@ static inline int elv_ioq_nr_queued(struct io_queue *ioq)
>  	return ioq->nr_queued;
>  }
>  
> -static inline pid_t elv_ioq_pid(struct io_queue *ioq)
> -{
> -	return ioq->pid;
> -}
> -
> -static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
> -{
> -	return ioq->ttime_mean;
> -}
> -
> -static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
> -{
> -	return ioq_sample_valid(ioq->ttime_samples);
> -}
> -
>  static inline void elv_get_ioq(struct io_queue *ioq)
>  {
>  	atomic_inc(&ioq->ref);
> -- 
> 1.5.4.rc3
