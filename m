Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXD0Vgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXD0Vgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXD0Vgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:36:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29316 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbXD0Vgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:36:49 -0400
Date: Fri, 27 Apr 2007 14:37:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: "Sunil Naidu" <akula2.shark@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>, trivial@kernel.org
Subject: Re: [PATCH] Move LOG_BUF_SHIFT to a more sensible place
Message-Id: <20070427143726.859a9d92.randy.dunlap@oracle.com>
In-Reply-To: <200704272053.32502.s0348365@sms.ed.ac.uk>
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
	<8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
	<20070427085500.1c4b267c.randy.dunlap@oracle.com>
	<200704272053.32502.s0348365@sms.ed.ac.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 20:53:32 +0100 Alistair John Strachan wrote:

> Several people have observed that perhaps LOG_BUF_SHIFT should be in a more 
> obvious place than under DEBUG_KERNEL. Under some circumstances (such as the 
> PARISC architecture), DEBUG_KERNEL can increase kernel size, which is an 
> undesirable trade off for something as trivial as increasing the kernel log 
> buffer size.
> 
> Instead, move LOG_BUF_SHIFT into "General Setup", so that people are more 
> likely to be able to change it such a circumstance that the default buffer 
> size is insufficient.
> 
> Signed-off-by: Alistair John Strachan <s0348365@sms.ed.ac.uk>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index b170aa1..cc9eb35 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -262,6 +262,23 @@ config IKCONFIG_PROC
>  	  This option enables access to the kernel configuration file
>  	  through /proc/config.gz.
>  
> +config LOG_BUF_SHIFT
> +	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
> +	range 12 21
> +	default 17 if S390 || LOCKDEP
> +	default 16 if X86_NUMAQ || IA64
> +	default 15 if SMP
> +	default 14
> +	help
> +	  Select kernel log buffer size as a power of 2.
> +	  Defaults and Examples:
> +	  	     17 => 128 KB for S/390
> +		     16 => 64 KB for x86 NUMAQ or IA-64
> +	             15 => 32 KB for SMP
> +	             14 => 16 KB for uniprocessor
> +		     13 =>  8 KB
> +		     12 =>  4 KB
> +
>  config CPUSETS
>  	bool "Cpuset support"
>  	depends on SMP
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 3f3e740..de82401 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -86,23 +86,6 @@ config DEBUG_SHIRQ
>  	  Drivers ought to be able to handle interrupts coming in at those
>  	  points; some don't and need to be caught.
>  
> -config LOG_BUF_SHIFT
> -	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
> -	range 12 21
> -	default 17 if S390 || LOCKDEP
> -	default 16 if X86_NUMAQ || IA64
> -	default 15 if SMP
> -	default 14
> -	help
> -	  Select kernel log buffer size as a power of 2.
> -	  Defaults and Examples:
> -	  	     17 => 128 KB for S/390
> -		     16 => 64 KB for x86 NUMAQ or IA-64
> -	             15 => 32 KB for SMP
> -	             14 => 16 KB for uniprocessor
> -		     13 =>  8 KB
> -		     12 =>  4 KB
> -
>  config DETECT_SOFTLOCKUP
>  	bool "Detect Soft Lockups"
>  	depends on DEBUG_KERNEL && !S390
> 
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
