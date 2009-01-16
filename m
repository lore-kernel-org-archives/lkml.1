Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbZAPAwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbZAPAwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZAPAw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:52:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:50399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZAPAw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:52:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,273,1231142400"; 
   d="scan'208";a="100542078"
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "dev@jaysonking.com" <dev@jaysonking.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232036235.8870.75.camel@laptop>
References: <1231837036.11429.27.camel@ymzhang>
	 <1231839464.14655.12.camel@marge.simson.net>
	 <1231986636.10565.159.camel@minggr.sh.intel.com>
	 <1232036235.8870.75.camel@laptop>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 08:49:43 +0800
Message-Id: <1232066983.4923.5.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 00:17 +0800, Peter Zijlstra wrote:
> On Thu, 2009-01-15 at 10:30 +0800, Lin Ming wrote:
> 
> > Below patch fixes aim7 regression and specjbb2005 regression becomes
> > less than 1.5% on 8-core stokley.
> 
> Ingo, please apply the below.
> 
> Ming, would you also provide a S-o-b line?

Yes,

Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Lin Ming

> 
> ---
> Subject: sched_slice fixlet
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Thu Jan 15 17:10:02 CET 2009
> 
> Mike's change: 0a582440f -- sched: fix sched_slice())
> Broke group scheduling by forgetting to reload cfs_rq on each loop.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_fair.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -429,7 +429,10 @@ static u64 sched_slice(struct cfs_rq *cf
>  	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
>  
>  	for_each_sched_entity(se) {
> -		struct load_weight *load = &cfs_rq->load;
> +		struct load_weight *load;
> +
> +		cfs_rq = cfs_rq_of(se);
> +		load = &cfs_rq->load;
>  
>  		if (unlikely(!se->on_rq)) {
>  			struct load_weight lw = cfs_rq->load;
> 
> 

