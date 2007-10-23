Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbXJWNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbXJWNFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJWNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:05:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35237 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781AbXJWNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:05:04 -0400
Date: Tue, 23 Oct 2007 15:05:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: mark irqbalance not-recommended
Message-ID: <20071023130533.GS30533@stusta.de>
References: <20071023115709.GA1734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071023115709.GA1734@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 01:57:09PM +0200, Pavel Machek wrote:
> 
> Mark CONFIG_IRQBALANCE as not recommended any more. It eats too much
> power, and better solutions are available in userspace.

What about additionally a printk() during init and a 
feature-removal-schedule.txt entry scheduling removal
one year from now?

> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> ---
> commit 2665f7971b5b97830b028308553a78a95c131988
> tree e1782cceebfb5900373469c0043d113de88f861f
> parent f5085f6ea1c5771708c44a4a42ee217e760ff4a0
> author Pavel <pavel@amd.ucw.cz> Tue, 23 Oct 2007 13:56:15 +0200
> committer Pavel <pavel@amd.ucw.cz> Tue, 23 Oct 2007 13:56:15 +0200
> 
>  arch/i386/Kconfig |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index eba2d88..10f3c38 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -779,10 +779,13 @@ config EFI
>  config IRQBALANCE
>   	bool "Enable kernel irq balancing"

If you want people to notice it's deprecated you should add a
" (DEPRECATED)" to the kconfig prompt.

>  	depends on SMP && X86_IO_APIC
> -	default y
> +	default n

Please drop the "default n", it has no effect.

>  	help
> - 	  The default yes will allow the kernel to do irq load balancing.
> -	  Saying no will keep the kernel from doing irq load balancing.
> + 	  Saying yes will allow the kernel to do irq load balancing;
> +	  but it generates too many CPU wakeups, eating power, and
> +	  is better done in userspace.
> +
> +	  Say N.
>  
>  # turning this on wastes a bunch of space.
>  # Summit needs it only when NUMA is on

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

