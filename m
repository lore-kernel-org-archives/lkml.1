Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZGDVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZGDVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZGDVOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 17:14:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:53163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZGDVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 17:14:52 -0400
Message-ID: <4A4FC5D0.6090000@kernel.org>
Date: Sat, 04 Jul 2009 14:12:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
References: <20090703164225.GA21447@elte.hu> <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
In-Reply-To: <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Jaswinder Singh Rajput wrote:
> Commit-ID:  63f9600fadb10ea739108ae93e3e842d9843c58b
> Gitweb:     http://git.kernel.org/tip/63f9600fadb10ea739108ae93e3e842d9843c58b
> Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> AuthorDate: Sat, 4 Jul 2009 07:51:32 +0530
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 4 Jul 2009 11:10:46 +0200
> 
> x86: Clean up mtrr/cleanup.c
> 
> Fix trivial style problems:
> 
>   WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
>   WARNING: Use #include <linux/kvm_para.h> instead of <asm/kvm_para.h>
> 
> Also, nr_mtrr_spare_reg should be unsigned long.
> 
> arch/x86/kernel/cpu/mtrr/cleanup.o:
> 
>    text	   data	    bss	    dec	    hex	filename
>    6241	   8992	   2056	  17289	   4389	cleanup.o.before
>    6241	   8992	   2056	  17289	   4389	cleanup.o.after
> 
> The md5 has changed:
>    1a7a27513aef1825236daf29110fe657  cleanup.o.before.asm
>    bcea358efa2532b6020e338e158447af  cleanup.o.after.asm
> 
> Because a WARN_ON()'s __LINE__ value changed by 3 lines.
> 
> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> LKML-Reference: <20090703164225.GA21447@elte.hu>
> [ Did lots of other cleanups to make the code look more consistent. ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/mtrr/cleanup.c |  350 ++++++++++++++++++------------------
>  1 files changed, 176 insertions(+), 174 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index 1d584a1..b8aba81 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -1,51 +1,52 @@
> -/*  MTRR (Memory Type Range Register) cleanup
> -
> -    Copyright (C) 2009 Yinghai Lu
> -
> -    This library is free software; you can redistribute it and/or
> -    modify it under the terms of the GNU Library General Public
> -    License as published by the Free Software Foundation; either
> -    version 2 of the License, or (at your option) any later version.
> -
> -    This library is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -    Library General Public License for more details.
> -
> -    You should have received a copy of the GNU Library General Public
> -    License along with this library; if not, write to the Free
> -    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -*/
> -
> +/*
> + * MTRR (Memory Type Range Register) cleanup
> + *
> + *  Copyright (C) 2009 Yinghai Lu
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Library General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Library General Public License for more details.
> + *
> + * You should have received a copy of the GNU Library General Public
> + * License along with this library; if not, write to the Free
> + * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/smp.h>
>  #include <linux/cpu.h>
> -#include <linux/mutex.h>
>  #include <linux/sort.h>
> +#include <linux/mutex.h>
> +#include <linux/uaccess.h>
> +#include <linux/kvm_para.h>
>  
> +#include <asm/processor.h>
>  #include <asm/e820.h>
>  #include <asm/mtrr.h>
> -#include <asm/uaccess.h>
> -#include <asm/processor.h>
>  #include <asm/msr.h>
> -#include <asm/kvm_para.h>
> +
>  #include "mtrr.h"
>  
> -/* should be related to MTRR_VAR_RANGES nums */
> +/* Should be related to MTRR_VAR_RANGES nums */
>  #define RANGE_NUM 256
>  
>  struct res_range {
> -	unsigned long start;
> -	unsigned long end;
> +	unsigned long	start;
> +	unsigned long	end;
>  };
>  
>  static int __init
> -add_range(struct res_range *range, int nr_range, unsigned long start,
> -			      unsigned long end)
> +add_range(struct res_range *range, int nr_range,
> +	  unsigned long start, unsigned long end)
>  {
> -	/* out of slots */
> +	/* Out of slots: */
>  	if (nr_range >= RANGE_NUM)
>  		return nr_range;
>  
> @@ -58,12 +59,12 @@ add_range(struct res_range *range, int nr_range, unsigned long start,
>  }
>  
>  static int __init
> -add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
> -			      unsigned long end)
> +add_range_with_merge(struct res_range *range, int nr_range,
> +		     unsigned long start, unsigned long end)
>  {
>  	int i;
>  
> -	/* try to merge it with old one */
> +	/* Try to merge it with old one: */
>  	for (i = 0; i < nr_range; i++) {
>  		unsigned long final_start, final_end;
>  		unsigned long common_start, common_end;
> @@ -84,7 +85,7 @@ add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
>  		return nr_range;
>  	}
>  
> -	/* need to add that */
> +	/* Need to add it: */
>  	return add_range(range, nr_range, start, end);
>  }
>  
> @@ -117,7 +118,7 @@ subtract_range(struct res_range *range, unsigned long start, unsigned long end)
>  		}
>  
>  		if (start > range[j].start && end < range[j].end) {
> -			/* find the new spare */
> +			/* Find the new spare: */
>  			for (i = 0; i < RANGE_NUM; i++) {
>  				if (range[i].end == 0)
>  					break;
> @@ -147,13 +148,19 @@ static int __init cmp_range(const void *x1, const void *x2)
>  }
>  
>  struct var_mtrr_range_state {
> -	unsigned long base_pfn;
> -	unsigned long size_pfn;
> -	mtrr_type type;
> +	unsigned long	base_pfn;
> +	unsigned long	size_pfn;
> +	mtrr_type	type;
>  };
>  
>  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
> +
>  static int __initdata debug_print;
> +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
> +
> +

two blank lines?


> +#define BIOS_BUG_MSG KERN_WARNING \
> +	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"

No user for this

YH
