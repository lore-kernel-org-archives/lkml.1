Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753457AbYLRSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYLRSNe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYLRSM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:12:58 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:34481 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYLRSM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:12:57 -0500
Date: Thu, 18 Dec 2008 23:42:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 8/8] sched: idle_balance() does not call
	load_balance_newidle()
Message-ID: <20081218181252.GH26572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>,
	Pavel Machek <pavel@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175658.29812.62512.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081218175658.29812.62512.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-18 23:26:59]:

> load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE
> is set at higher level domain (3-CPU) and not in low level domain
> (2-MC).
> 
> pulled_task is initialised to -1 and checked for non-zero which
> is always true if the lowest level sched_domain does not have
> SD_BALANCE_NEWIDLE flag set.
> 
> Trivial fix to initialise pulled_task to zero.
> 
> This patch has been queued for 2.6.29
> http://lkml.org/lkml/2008/12/8/213
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f82a7a0..e6a88bf 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3773,7 +3773,7 @@ out_balanced:
>  static void idle_balance(int this_cpu, struct rq *this_rq)
>  {
>  	struct sched_domain *sd;
> -	int pulled_task = -1;
> +	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
>  	cpumask_t tmpmask;
>

Isn't this already in Ingo's patch queue? 

-- 
	Balbir
