Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbZAOSxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbZAOSxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZAOSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:53:33 -0500
Received: from mx04.mailboxcop.com ([206.125.223.74]:44978 "EHLO
	mx04.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbZAOSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:53:32 -0500
Message-ID: <496F8631.3070902@jaysonking.com>
Date: Thu, 15 Jan 2009 12:53:37 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
References: <1231837036.11429.27.camel@ymzhang>	 <1231839464.14655.12.camel@marge.simson.net>	 <1231986636.10565.159.camel@minggr.sh.intel.com> <1232036235.8870.75.camel@laptop>
In-Reply-To: <1232036235.8870.75.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.04
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 341642990 - 59b5111924c9
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=341642990&m=59b5111924c9&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=341642990&m=59b5111924c9&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=341642990&m=59b5111924c9&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-01-15 at 10:30 +0800, Lin Ming wrote:
> 
>> Below patch fixes aim7 regression and specjbb2005 regression becomes
>> less than 1.5% on 8-core stokley.
> 
> Ingo, please apply the below.
> 
> Ming, would you also provide a S-o-b line?
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
> 


That still works for me. You may add:

Tested-by: Jayson King <dev@jaysonking.com>



