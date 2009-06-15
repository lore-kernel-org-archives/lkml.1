Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZFONFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZFONFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbZFONFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:05:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760603AbZFONE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:04:59 -0400
Date: Mon, 15 Jun 2009 09:02:25 -0400
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
Message-ID: <20090615130225.GB5717@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-5-git-send-email-vgoyal@redhat.com> <4A360CD2.8060707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A360CD2.8060707@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 04:56:50PM +0800, Gui Jianfeng wrote:
> > -static inline int
> > -cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > +static inline int cfq_class_rt(struct cfq_queue *cfqq)
> >  {
> > -	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
> > +	return elv_ioq_class_rt(cfqq->ioq);
> >  }
> 
> Hi Vivek,
> 
> cfq_class_rt isn't needed now, clean it up.
> 

Thanks Gui. Queued up for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 705e7ba..23b24b9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -234,11 +234,6 @@ static inline int cfq_class_idle(struct cfq_queue *cfqq)
>  	return elv_ioq_class_idle(cfqq->ioq);
>  }
>  
> -static inline int cfq_class_rt(struct cfq_queue *cfqq)
> -{
> -	return elv_ioq_class_rt(cfqq->ioq);
> -}
> -
>  static inline int cfq_cfqq_sync(struct cfq_queue *cfqq)
>  {
>  	return elv_ioq_sync(cfqq->ioq);
> -- 
> 1.5.4.rc3
> 
