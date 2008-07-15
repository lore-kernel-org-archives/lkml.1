Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYGOA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYGOA37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYGOA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:29:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16832 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbYGOA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:29:51 -0400
Date: Tue, 15 Jul 2008 08:20:52 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, Joe Jin <joe.jin@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       greg.marsden@oracle.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, tao.ma@oracle.com
Subject: Re: [PATCH] x86_64: reserve crashkernel bootmem before reserve dma32 bootmem
Message-ID: <20080715002052.GA2123@joejin-pc.cn.oracle.com>
References: <200807141016.40572.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807141016.40572.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai, thanks!


On 2008-07-14 10:16, Yinghai Lu wrote:
> From: Joe Jin <joe.jin@oracle.com>
> 
> Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
> this cuased crashkernel end address must less than 64M or start address must
> more than 192M except crashkernel memory reserved before dma32 memory reserved.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/setup_64.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_64.c
> +++ linux-2.6/arch/x86/kernel/setup_64.c
> @@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
>  	contig_initmem_init(0, end_pfn);
>  #endif
>  
> -	dma32_reserve_bootmem();
> -
>  #ifdef CONFIG_ACPI_SLEEP
>  	/*
>  	 * Reserve low memory region for sleep support.
> @@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  	reserve_crashkernel();
>  
> +	dma32_reserve_bootmem();
> +
>  	reserve_ibft_region();
>  
>  	paging_init();
