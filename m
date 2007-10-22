Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbXJVDiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbXJVDiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJVDij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:38:39 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:53747 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXJVDii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:38:38 -0400
Date: Sun, 21 Oct 2007 23:38:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] x86: add instrumentation menu
Message-ID: <20071022033836.GA5200@Krystal>
References: <20071022024808.GK30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071022024808.GK30533@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:35:59 up 84 days,  3:54,  2 users,  load average: 0.89, 0.42, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> It seems commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9 was incomplete 
> due to a clash with the x86 architecture merge.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Yes, my own fix only dealt with i386 and x86_64 Kconfig, without fixing
the x86 architecture. This patch seems good.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> 
>  arch/i386/Kconfig         |    2 ++
>  arch/x86/oprofile/Kconfig |   17 -----------------
>  arch/x86_64/Kconfig       |    2 ++
>  3 files changed, 4 insertions(+), 17 deletions(-)
> 
> e66850f5417ad721e75bf575b6ec49d7aec0af04 
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index f6e44fc..9e8a74f 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -1258,6 +1258,8 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> +source "kernel/Kconfig.instrumentation"
> +
>  source "arch/i386/Kconfig.debug"
>  
>  source "security/Kconfig"
> diff --git a/arch/x86/oprofile/Kconfig b/arch/x86/oprofile/Kconfig
> deleted file mode 100644
> index d8a8408..0000000
> --- a/arch/x86/oprofile/Kconfig
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -config PROFILING
> -	bool "Profiling support (EXPERIMENTAL)"
> -	help
> -	  Say Y here to enable the extended profiling support mechanisms used
> -	  by profilers such as OProfile.
> -	  
> -
> -config OPROFILE
> -	tristate "OProfile system profiling (EXPERIMENTAL)"
> -	depends on PROFILING
> -	help
> -	  OProfile is a profiling system capable of profiling the
> -	  whole system, include the kernel, kernel modules, libraries,
> -	  and applications.
> -
> -	  If unsure, say N.
> -
> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index aab25f3..106d5d5 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -801,6 +801,8 @@ source "drivers/firmware/Kconfig"
>  
>  source fs/Kconfig
>  
> +source "kernel/Kconfig.instrumentation"
> +
>  source "arch/x86_64/Kconfig.debug"
>  
>  source "security/Kconfig"
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
