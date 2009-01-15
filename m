Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZAOPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZAOPLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZAOPLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:11:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZAOPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:11:04 -0500
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, dev@jaysonking.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231986636.10565.159.camel@minggr.sh.intel.com>
References: <1231837036.11429.27.camel@ymzhang>
	 <1231839464.14655.12.camel@marge.simson.net>
	 <1231986636.10565.159.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 16:10:58 +0100
Message-Id: <1232032258.8870.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:30 +0800, Lin Ming wrote:

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 8e1352c..617e54c 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -429,10 +429,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
>  
>  	for_each_sched_entity(se) {
> -		struct load_weight *load = &cfs_rq->load;
> +		struct load_weight *load = &cfs_rq_of(se)->load;
>  
>  		if (unlikely(!se->on_rq)) {
> -			struct load_weight lw = cfs_rq->load;
> +			struct load_weight lw = cfs_rq_of(se)->load;
>  
>  			update_load_add(&lw, se->load.weight);
>  			load = &lw;
> 

I was wrong, this does look good.

Thanks

