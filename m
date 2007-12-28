Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbXL1TTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbXL1TTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXL1TTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:19:10 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53188 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbXL1TTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:19:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALbadEdMROHU/2dsb2JhbACBV6s5
Date: Fri, 28 Dec 2007 14:14:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore blackfin HARDWARE_PM support
Message-ID: <20071228191404.GB21353@Krystal>
References: <20071228185643.GB4738@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071228185643.GB4738@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:12:06 up 55 days, 17 min,  5 users,  load average: 0.47, 0.73,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (adrian.bunk@movial.fi) wrote:
> This patch restores the blackfin Hardware Performance Monitor Profiling 
> support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 

Yep, this one too must be put back, but kernel/Kconfig.instrumentation
seems like the wrong spot for a blackfin-specific config option (and
this will break the instrumentation menu removal patches in -mm).

Can we put this in arch/blackfin/Kconfig instead ?

> ---
> 
>  kernel/Kconfig.instrumentation |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 942996f33f81726c5edb012d61ecdad70c55884d 
> diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> index 97c76ca..e023671 100644
> --- a/kernel/Kconfig.instrumentation
> +++ b/kernel/Kconfig.instrumentation
> @@ -44,2 +44,11 @@ config OPROFILE_MPCORE
>  
> +config HARDWARE_PM
> +	tristate "Hardware Performance Monitor Profiling"
> +	depends on BLACKFIN && PROFILING
> +	help
> +	  take use of hardware performance monitor to profiling the kernel
> +	  and application.
> +
> +	  If unsure, say N.
> +
>  config KPROBES
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
