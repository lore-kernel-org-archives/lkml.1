Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZHZJa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZHZJa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbZHZJa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:30:59 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:54767 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZHZJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:30:58 -0400
Date: Wed, 26 Aug 2009 15:00:43 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090826093043.GA22064@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820133914.GW29327@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Thu, Aug 20, 2009 at 03:39:14PM +0200, Andreas Herrmann wrote:
> @@ -9208,6 +9229,11 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
>  		err = sysfs_create_file(&cls->kset.kobj,
>  					&attr_sched_mc_power_savings.attr);
>  #endif
> +#ifdef CONFIG_SCHED_MN
> +	if (!err && mc_capable())
> +		err = sysfs_create_file(&cls->kset.kobj,
> +					&attr_sched_mn_power_savings.attr);
> +#endif

This would create the sysfs tunable even on systems which are
mc_capable() but don't have multi-nodes on a package, no ?

>  	return err;
>  }
>  #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> -- 
> 1.6.0.4
> 
> 

-- 
Thanks and Regards
gautham
