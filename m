Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZGIIs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZGIIs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZGIIst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:48:49 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53648 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbZGIIss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:48:48 -0400
Date: Thu, 9 Jul 2009 10:48:40 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, rjw@sisk.pl,
       mingo@elte.hu, Shaohua Li <shaohua.li@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Young <hidave.darkstar@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, sven.wegener@stealer.net,
       cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: Unbreak build for !SMP: symlinked cpus cannot
	happen for !SMP
Message-ID: <20090709084840.GR9464@buzzloop.caiaq.de>
References: <1247081067-21964-1-git-send-email-daniel@caiaq.de> <200907091043.39607.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907091043.39607.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 10:43:35AM +0200, Thomas Renninger wrote:
> Or like that:
> Either all #ifdef CONFIG_SMP related conditionals to managed cpus
> should vanish or all should be covered. This one takes the latter
> approach.

Dave Jones fixed it already, see

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5e1596f75395e7a402e1059c518e633d2732dcf8

Daniel




> ---
> 'managed_policy' is used for the non-smp case in line 941.
> 
> Make the symlink code conditional to #ifdef CONFIG_SMP as already
> done at other places.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> Index: cpufreq/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- cpufreq.orig/drivers/cpufreq/cpufreq.c
> +++ cpufreq/drivers/cpufreq/cpufreq.c
> @@ -930,6 +930,7 @@ static int cpufreq_add_dev(struct sys_de
>  	}
>  	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  
> +#ifdef CONFIG_SMP
>  	/* symlink affected CPUs */
>  	for_each_cpu(j, policy->cpus) {
>  		if (j == cpu)
> @@ -947,6 +948,7 @@ static int cpufreq_add_dev(struct sys_de
>  			goto err_out_unregister;
>  		}
>  	}
> +#endif
>  
>  	policy->governor = NULL; /* to assure that the starting sequence is
>  				  * run in cpufreq_set_policy */
> 
