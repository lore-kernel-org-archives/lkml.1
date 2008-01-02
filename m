Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYABRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYABRoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYABRoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:44:05 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:50137 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbYABRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:44:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAHpbe0dMROHU/2dsb2JhbACBV6ZS
Date: Wed, 2 Jan 2008 12:43:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] Fix ARMv6 OProfile support
Message-ID: <20080102174357.GA2189@Krystal>
References: <20071228185636.GA4738@stusta.de> <20071229160556.GA12262@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071229160556.GA12262@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:42:54 up 59 days, 22:48,  5 users,  load average: 1.60, 2.98,
	2.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Fix ARMv6 OProfile support
> 
> This patch restores the ARMv6 OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> It puts the config options in arch/arm/Kconfig.
> 

This patch header should also include :

Problem identified by Adrian Bunk. Patch inspired by the original fix
proposed by him.

Thanks,

Mathieu


> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Adrian Bunk <adrian.bunk@movial.fi>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: rmk@arm.linux.org.uk
> CC: phil.el@wanadoo.fr
> CC: oprofile-list@lists.sourceforge.net
> ---
>  arch/arm/Kconfig |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> Index: linux-2.6-lttng/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-12-28 17:00:50.000000000 -0500
> +++ linux-2.6-lttng/arch/arm/Kconfig	2007-12-28 17:02:05.000000000 -0500
> @@ -130,6 +130,25 @@ config FIQ
>  config ARCH_MTD_XIP
>  	bool
>  
> +if OPROFILE
> +
> +config OPROFILE_ARMV6
> +	bool
> +	depends on CPU_V6 && !SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_MPCORE
> +	bool
> +	depends on CPU_V6 && SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_ARM11_CORE
> +	bool
> +
> +endif
> +
>  config VECTORS_BASE
>  	hex
>  	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
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
