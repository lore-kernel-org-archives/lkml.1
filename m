Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXL1TRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXL1TRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXL1TRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:17:12 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:55116 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbXL1TRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:17:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEHadEdMROHU/2dsb2JhbACBV6tC
Date: Fri, 28 Dec 2007 14:12:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20071228191159.GA21353@Krystal>
References: <20071228185636.GA4738@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071228185636.GA4738@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:06:42 up 55 days, 12 min,  4 users,  load average: 0.05, 0.49,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (adrian.bunk@movial.fi) wrote:
> This patch restores the ARMv6 OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 

Yup, it must be put back, but I doubt stuffing it in
kernel/Kconfig.instrumentation is the best way to proceed, especially
since it will break the "instrumentation menu removal" patches currently
in -mm _and_ because this is arm-specific.

Why don't we simply put it in arch/arm/Kconfig ?


> ---
> 
>  kernel/Kconfig.instrumentation |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> 7fc221ef169610b5eac98e2ddd641811c0d53e4a 
> diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> index 468f47a..4453187 100644
> --- a/kernel/Kconfig.instrumentation
> +++ b/kernel/Kconfig.instrumentation
> @@ -29,2 +29,17 @@ config OPROFILE
> 
> +config OPROFILE_ARMV6
> +	bool
> +	depends on OPROFILE && ARM && CPU_V6 && !SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_MPCORE
> +	bool
> +	depends on OPROFILE && ARM && CPU_V6 && SMP
> +	default y
> +	select OPROFILE_ARM11_CORE
> +
> +config OPROFILE_ARM11_CORE
> +	bool
> +
>  config KPROBES

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
