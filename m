Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbZGQNyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbZGQNyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934641AbZGQNyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:54:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934633AbZGQNyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:54:51 -0400
Date: Fri, 17 Jul 2009 09:52:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 22/25] io-controller: Per io group bdi congestion
	interface
Message-ID: <20090717135246.GA16839@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-23-git-send-email-vgoyal@redhat.com> <4A5FC2CA.1040609@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5FC2CA.1040609@ds.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:16:10PM -0400, Munehiro Ikeda wrote:
> Hi,
> 
> Vivek Goyal wrote, on 07/02/2009 04:01 PM:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 2035c20..79fe6a9 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -90,6 +90,27 @@ void blk_queue_congestion_threshold(struct request_queue *q)
> >   	q->nr_congestion_off = nr;
> >   }
> > 
> > +#ifdef CONFIG_GROUP_IOSCHED
> > +int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
> > +					struct page *page)
> > +{
> > +	int ret = 0;
> > +	struct request_queue *q = bdi->unplug_io_data;
> > +
> > +	if (!q&&  !q->elevator)
> > +		return bdi_congested(bdi, bdi_bits);
> 
> It causes NULL pointer dereference for brd etc.
> 
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  block/blk-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 79fe6a9..39fab66 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -97,7 +97,7 @@ int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
>  	int ret = 0;
>  	struct request_queue *q = bdi->unplug_io_data;
>  
> -	if (!q && !q->elevator)
> +	if (!q || !q->elevator)
>  		return bdi_congested(bdi, bdi_bits);
>  

Hi,

Thanks for the patch. I also noticed this recently and fixed it for next
to be posted version.

Thanks
Vivek

>  	/* Do we need to hold queue lock? */
> -- 
> 1.6.2.5
> 
> 
> -- 
> IKEDA, Munehiro
>   NEC Corporation of America
>     m-ikeda@ds.jp.nec.com
