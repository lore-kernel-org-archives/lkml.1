Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZFJNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZFJNWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbZFJNWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:22:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33377 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZFJNWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:22:46 -0400
Date: Wed, 10 Jun 2009 09:22:00 -0400
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
Subject: Re: [PATCH 17/19] io-controller: Support per cgroup per device
	weights and io class
Message-ID: <20090610132159.GA19680@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-18-git-send-email-vgoyal@redhat.com> <4A2F646A.8070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2F646A.8070403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 03:44:42PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> > @@ -1233,6 +1254,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
> >  		elv_get_iog(iog);
> >  
> >  		iog->iocg_id = css_id(&iocg->css);
> > +		io_group_init_entity(iocg, iog, iog->dev);
> 
> Hi Vivek,
> 
> A regression occurs in io.policy handling. IO Controller completely stops working when i use 
> this interface. 
> Make sure that we initialize entity after iog->dev is setting up properly.
> 

Thanks Gui. Will do in next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 6b30c36..a516dce 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1451,7 +1451,6 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
>  		elv_get_iog(iog);
>  
>  		iog->iocg_id = css_id(&iocg->css);
> -		io_group_init_entity(iocg, iog, iog->dev);
>  		iog->my_entity = &iog->entity;
>  
>  		if (bio) {
> @@ -1459,6 +1458,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
>  			iog->dev = MKDEV(disk->major, disk->first_minor);
>  		}
>  
> +		io_group_init_entity(iocg, iog, iog->dev);
> +
>  		blk_init_request_list(&iog->rl);
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
>  		io_group_path(iog, iog->path, sizeof(iog->path));
> -- 
> 1.5.4.rc3
