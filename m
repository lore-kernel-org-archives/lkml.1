Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZERBdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZERBdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZERBdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:33:12 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44456 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbZERBdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:33:10 -0400
Message-ID: <4A10BAD5.9040807@snapgear.com>
Date: Mon, 18 May 2009 11:33:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] arch/m68knommu: Convert #ifdef DEBUG printk(KERN_DEBUG
 to pr_debug(
References: <cover.1242407227.git.joe@perches.com> <4bba2ced6c7b9294db7d415009520fe72d7e6f1e.1242407227.git.joe@perches.com>
In-Reply-To: <4bba2ced6c7b9294db7d415009520fe72d7e6f1e.1242407227.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Perches wrote:
> From: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good, thanks. I'll apply to the m68knommu git tree
(for-linus branch).

Regards
Greg



> ---
>  arch/m68knommu/kernel/setup.c |   16 +++++++---------
>  arch/m68knommu/mm/init.c      |    4 +---
>  2 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
> index 5985f19..5c2bb3e 100644
> --- a/arch/m68knommu/kernel/setup.c
> +++ b/arch/m68knommu/kernel/setup.c
> @@ -166,15 +166,13 @@ void __init setup_arch(char **cmdline_p)
>  	printk(KERN_INFO "Motorola M5235EVB support (C)2005 Syn-tech Systems, Inc. (Jate Sujjavanich)\n");
>  #endif
>  
> -#ifdef DEBUG
> -	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
> -		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
> -		(int) &_sdata, (int) &_edata,
> -		(int) &_sbss, (int) &_ebss);
> -	printk(KERN_DEBUG "MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
> -		(int) &_ebss, (int) memory_start,
> -		(int) memory_start, (int) memory_end);
> -#endif
> +	pr_debug("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
> +		 "BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
> +		 (int) &_sdata, (int) &_edata,
> +		 (int) &_sbss, (int) &_ebss);
> +	pr_debug("MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
> +		 (int) &_ebss, (int) memory_start,
> +		 (int) memory_start, (int) memory_end);
>  
>  	/* Keep a copy of command line */
>  	*cmdline_p = &command_line[0];
> diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
> index 7befc0c..b1703c6 100644
> --- a/arch/m68knommu/mm/init.c
> +++ b/arch/m68knommu/mm/init.c
> @@ -126,9 +126,7 @@ void __init mem_init(void)
>  	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
>  	unsigned long end_mem   = memory_end; /* DAVIDM - this must not include kernel stack at top */
>  
> -#ifdef DEBUG
> -	printk(KERN_DEBUG "Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
> -#endif
> +	pr_debug("Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
>  
>  	end_mem &= PAGE_MASK;
>  	high_memory = (void *) end_mem;

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
