Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZHUCBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZHUCBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZHUCBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZHUCBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:01:09 -0400
Date: Thu, 20 Aug 2009 22:00:28 -0400
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
Message-ID: <20090821020028.GA3763@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com> <4A8DFE3A.6030503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8DFE3A.6030503@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 09:54:02AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +static void put_prev_io_entity(struct io_entity *entity)
> > +{
> > +	struct io_service_tree *st = entity->st;
> > +	struct io_sched_data *sd = io_entity_sched_data(entity);
> > +
> > +	st->active_entity = NULL;
> > +	sd->active_entity = NULL;
> > +
> > +	if (unlikely(entity->ioprio_changed)) {
> > +		dequeue_io_entity(entity);
> > +		io_entity_update_prio(entity);
> 
> Hi Vivek,
> 
> we don't need to update prio here for the following enqueue_io_entity() 
> is already taking care of it.
> 

Thanks Gui. Jerome already raised this point in one of the replies. Will
take care of it in next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 201543e..b720139 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -607,7 +607,6 @@ static void put_prev_io_entity(struct io_entity *entity)
>  
>  	if (unlikely(entity->ioprio_changed)) {
>  		dequeue_io_entity(entity);
> -		io_entity_update_prio(entity);
>  		enqueue_io_entity(entity);
>  	} else
>  		__enqueue_io_entity(st, entity);
> -- 
> 1.5.4.rc3
> 
