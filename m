Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZHXPhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZHXPhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZHXPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:36:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:56588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZHXPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:36:57 -0400
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
 cpumask on multi-node processors
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090820134604.GD29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134604.GD29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:36:16 +0200
Message-Id: <1251128176.7538.301.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> The correct mask that describes core-siblings of an processor
> is topology_core_cpumask. See topology adapation patches, especially
> http://marc.info/?l=linux-kernel&m=124964999608179


argh, violence, murder kill.. this is the worst possible hack and you're
extending it :/

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index f797214..f39bb2c 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -446,7 +446,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>  	 * And for power savings, we return cpu_core_map
>  	 */
>  	if (sched_mc_power_savings || sched_smt_power_savings)
> -		return cpu_core_mask(cpu);
> +		return topology_core_cpumask(cpu);
>  	else
>  		return c->llc_shared_map;
>  }
