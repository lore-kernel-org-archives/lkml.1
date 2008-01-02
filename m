Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbYABRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbYABRwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYABRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:52:05 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:34732 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbYABRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:52:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HANNde0dMROHU/2dsb2JhbACBV6ZK
Date: Wed, 2 Jan 2008 12:46:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] Fix blackfin HARDWARE_PM support
Message-ID: <20080102174634.GB2189@Krystal>
References: <20071228185643.GB4738@stusta.de> <20071228192320.GI6780@does.not.exist> <20071228192855.GA23157@Krystal> <200712290114.46694.rgetz@blackfin.uclinux.org> <20071229162932.GC12262@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071229162932.GC12262@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:46:20 up 59 days, 22:51,  5 users,  load average: 0.83, 1.99,
	1.86
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> (Robin, can you check if this patch does what is currently intended with
> HARDWARE_PM please ? This involves testing with CONFIG_OPROFILE y/m/n.)
> 
> This patch restores the blackfin Hardware Performance Monitor Profiling
> support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Since there seems to be no good reason to behave differently from other
> architectures, it now automatically selects the hardware performance counters
> whenever the profiling is activated.
> 
> mach-common/irqpanic.c: pm_overflow
> calls pm_overflow_handler which is in oprofile/op_model_bf533.c. I doubt that
> setting HARDWARE_PM as "m" will work at all, since the pm_overflow_handler
> should be in the core kernel image because it is called by irqpanic.c.
> 
> Therefore, I change HARDWARE_PM from a tristate to a bool.
> 
> The whole arch/$(ARCH)/oprofile/ is built depending on CONFIG_OPROFILE. Since
> part of the HARDWARE_PM support files sits in this directory, it makes sense to
> also depend on OPROFILE, not only PROFILING. Since OPROFILE already depends on
> PROFILING, it is correct to only depend on OPROFILE only.
> 


This patch header should also include :

Problem identified by Adrian Bunk. Patch inspired by the original fix
proposed by him.

Thanks,

Mathieu


> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Adrian Bunk <adrian.bunk@movial.fi>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: bryan.wu@analog.com
> CC: Robin Getz <rgetz@blackfin.uclinux.org>
> ---
>  arch/blackfin/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6-lttng/arch/blackfin/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-12-29 11:00:05.000000000 -0500
> +++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-12-29 11:25:39.000000000 -0500
> @@ -65,6 +65,10 @@ config GENERIC_CALIBRATE_DELAY
>  	bool
>  	default y
>  
> +config HARDWARE_PM
> +	def_bool y
> +	depends on OPROFILE
> +
>  source "init/Kconfig"
>  source "kernel/Kconfig.preempt"
>  
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
