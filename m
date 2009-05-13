Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZEMPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZEMPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZEMPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:35:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58922 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZEMPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:35:40 -0400
Date: Wed, 13 May 2009 11:29:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
	handling
Message-ID: <20090513152909.GD7696@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A29B5.7030109@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:00:21AM +0800, Gui Jianfeng wrote:

[..]
> @@ -2137,7 +2366,7 @@ void elv_fq_unset_request_ioq(struct request_queue *q, struct request *rq)
>  void bfq_init_entity(struct io_entity *entity, struct io_group *iog)
>  {
>  	entity->ioprio = entity->new_ioprio;
> -	entity->weight = entity->new_weight;
> +	entity->weight = entity->new_weigh;
>  	entity->ioprio_class = entity->new_ioprio_class;
>  	entity->sched_data = &iog->sched_data;
>  }
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index db3a347..0407633 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -253,6 +253,14 @@ struct io_group {
>  #endif
>  };
>  
> +struct policy_node {

Would "io_policy_node" be better?

> +	struct list_head node;
> +	char dev_name[32];
> +	void *key;
> +	unsigned long weight;
> +	unsigned long ioprio_class;
> +};
> +
>  /**
>   * struct bfqio_cgroup - bfq cgroup data structure.
>   * @css: subsystem state for bfq in the containing cgroup.
> @@ -269,6 +277,9 @@ struct io_cgroup {
>  
>  	unsigned long weight, ioprio_class;
>  
> +	/* list of policy_node */
> +	struct list_head list;
> +

How about "struct list_head policy_list" or "struct list_head io_policy"?

Thanks
Vivek
