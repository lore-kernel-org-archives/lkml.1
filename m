Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZCQCk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZCQCk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZCQCkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:40:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZCQCkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:40:46 -0400
Message-ID: <49BF0CA1.3010304@zytor.com>
Date: Mon, 16 Mar 2009 19:36:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: {PATCH] x86: print out initial max_pfn_mapped
References: <49BF0978.40605@kernel.org>
In-Reply-To: <49BF0978.40605@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: more debug info
> 
> check range that is mapped before init_memory_mapping().
> also make 64bit have max_pfn_mapped assigned before that calling
> 
> Index: linux-2.6/arch/x86/mm/init.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init.c
> +++ linux-2.6/arch/x86/mm/init.c
> @@ -65,12 +65,11 @@ static void __init find_early_table_spac
>  	 */
>  #ifdef CONFIG_X86_32
>  	start = 0x7000;
> -	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
> -					tables, PAGE_SIZE);
> -#else /* CONFIG_X86_64 */
> +#else
>  	start = 0x8000;
> -	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
>  #endif
> +	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
> +					tables, PAGE_SIZE);
>  	if (e820_table_start == -1UL)
>  		panic("Cannot find space for the kernel page tables");
>  

This doesn't seem to match anything anywhere in the description.
Furthermore, why do we even have a different starting address for
different architectures?  If anything, this starting address is way too
low (hogging ZONE_DMA and all that...)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

