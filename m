Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZHXPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZHXPgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZHXPgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:36:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZHXPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:36:14 -0400
Subject: Re: [PATCH 14/15] sched: Conditionally limit __cpu_power when
 child sched domain has type NODE
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090820134506.GC29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134506.GC29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:35:32 +0200
Message-Id: <1251128132.7538.300.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:45 +0200, Andreas Herrmann wrote:
> We need this in case of performance policy. All sched_groups in
> child's parent domain (MN in this case) should be limited such that
> tasks are balanced among these sched_groups.

/me fails at correlating the above changelog and the below patch.

So here we go mess up cpu_power again in order to invluence the
placement policy?

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  kernel/sched.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0c950dc..ab88d88 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8555,11 +8555,11 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>  	 */
>  	if (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
>  	    ((child->flags &
> -	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
> +	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)) ||
> +	     (child->level == SD_LV_NODE))) {
>  		sd->groups->__cpu_power = 0;
>  		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
>  	}
> -
>  }
>  
>  /*
