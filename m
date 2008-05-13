Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYEMTmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYEMTmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYEMTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:41:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56811 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbYEMTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:41:51 -0400
Date: Tue, 13 May 2008 22:40:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080513194018.GA14569@cs181133002.pp.htv.fi>
References: <20080513192706.GA13677@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080513192706.GA13677@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 09:27:06PM +0200, Ingo Molnar wrote:
> 
> Linus, please pull the latest x86 fixes branch from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Wrong URL.

> It includes a ISA-DMA fix that was a fallout of the PCI unification. 
> Thanks,
> 
> 	Ingo
> 
> ------------------>
>...
> Ingo Molnar (1):
>       x86: fix csum_partial() export
>...

See my comment below (and I'd really appreciate if such stuff was sent 
to the mailing list before the pull request for being able to comment
in time).

> Takashi Iwai (1):
>       x86/pci: fix broken ISA DMA

Linus already got the latter through the PCI tree,

Who is actually responsible for the x86 PCI stuff?

Having fixes for this stuff in two trees will create much confusion
(e.g. in -next).

>...
> --- a/arch/x86/kernel/x8664_ksyms_64.c
> +++ b/arch/x86/kernel/x8664_ksyms_64.c
> @@ -2,6 +2,7 @@
>     All C exports should go in the respective C files. */
>  
>  #include <linux/module.h>
> +#include <net/checksum.h>
>  #include <linux/smp.h>
>  
>  #include <asm/processor.h>
> @@ -29,6 +30,8 @@ EXPORT_SYMBOL(__copy_from_user_inatomic);
>  EXPORT_SYMBOL(copy_page);
>  EXPORT_SYMBOL(clear_page);
>  
> +EXPORT_SYMBOL(csum_partial);
> +
>  /*
>   * Export string functions. We normally rely on gcc builtin for most of these,
>   * but gcc sometimes decides not to inline them.
> diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> index bc503f5..bf51144 100644
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -136,8 +136,6 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
>  						(__force u32)sum);
>  }
>  
> -EXPORT_SYMBOL(csum_partial);
> -
>  /*
>   * this routine is used for miscellaneous IP-like checksums, mainly
>   * in icmp.c
>...

Wouldn't the better solution be to move csum-partial_64.c from lib-y to 
obj-y instead?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

