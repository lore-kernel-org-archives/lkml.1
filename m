Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZH0VJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZH0VJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZH0VJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:09:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZH0VJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:09:48 -0400
Date: Thu, 27 Aug 2009 17:08:48 -0400
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
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
Message-ID: <20090827210848.GA3821@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com> <4A95F444.9040705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A95F444.9040705@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:49:40AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +static void update_min_vdisktime(struct io_service_tree *st)
> > +{
> > +	u64 vdisktime;
> > +
> > +	if (st->active_entity)
> > +		vdisktime = st->active_entity->vdisktime;
> > +
> > +	if (st->rb_leftmost) {
> > +		struct io_entity *entity = rb_entry(st->rb_leftmost,
> > +						struct io_entity, rb_node);
> > +
> > +		if (!st->active_entity)
> > +			vdisktime = entity->vdisktime;
> > +		else
> > +			vdisktime = min_vdisktime(vdisktime, entity->vdisktime);
> > +	}
> > +
> > +	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> > +}
> 
> block/elevator-fq.c: In function ‘elv_ioq_slice_expired’:
> block/elevator-fq.c:132: warning: ‘vdisktime’ may be used uninitialized in this function
> LD      block/built-in.o
> 
> We'd better initialize vdisktime at first.
> 

Thanks Gui. Will fix in next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index d04e925..a4161c2 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -131,6 +131,8 @@ static void update_min_vdisktime(struct io_service_tree *st)
>  {
>  	u64 vdisktime;
>  
> +	vdisktime = st->min_vdisktime;
> +
>  	if (st->active_entity)
>  		vdisktime = st->active_entity->vdisktime;
>  
> -- 
> 1.5.4.rc3
