Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZHXPEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZHXPEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZHXPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:04:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:44264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZHXPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:04:23 -0400
Subject: Re: [PATCH 10/15] sched: Check for sched_mn_power_savings when
 doing load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20090820134104.GY29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134104.GY29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:03:40 +0200
Message-Id: <1251126220.7538.273.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> The patch adds support for POWERSAVINGS_BALANCE_BASIC for MN domain
> level. Currently POWERSAVINGS_BALANCE_WAKEUP is not used for MN domain.
> 
> (I have to admit that so far I don't have the correct understanding
> what's the benefit of POWERSAVINGS_BALANCE_WAKEUP (when an deticated
> wakeup CPU is used) in contrast to POWERSAVINGS_BALANCE_BASIC.  I also
> have not found an example that would demonstrate the difference
> between those two powersaving levels.)

blame svaidy for not writing enough comments ;-)

iirc it moves tasks to sched_mv_preferred_wakeup_cpu instead of waking
an idle cpu, this leaves idle cpus idle longer at the cost of creating
overload on other cpus.

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  kernel/sched.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ebcda58..7a0d710 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4591,7 +4591,8 @@ static int find_new_ilb(int cpu)
>  	 * Have idle load balancer selection from semi-idle packages only
>  	 * when power-aware load balancing is enabled
>  	 */
> -	if (!(sched_smt_power_savings || sched_mc_power_savings))
> +	if (!(sched_smt_power_savings || sched_mc_power_savings ||
> +	      sched_mn_power_savings))
>  		goto out_done;
>  
>  	/*
> @@ -4681,7 +4682,7 @@ int select_nohz_load_balancer(int stop_tick)
>  			int new_ilb;
>  
>  			if (!(sched_smt_power_savings ||
> -						sched_mc_power_savings))
> +			      sched_mc_power_savings || sched_mn_power_savings))
>  				return 1;
>  			/*
>  			 * Check to see if there is a more power-efficient
