Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZKPKMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZKPKMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZKPKMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:12:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56606 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZKPKMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:12:53 -0500
Message-ID: <4B0125A2.30806@monstr.eu>
Date: Mon, 16 Nov 2009 11:12:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix pfn_valid() for noMMU
References: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steve@digidescorp.com wrote:
> Configuring DEBUG_SLAB causes a noMMU kernel to die during initialization
> with an invalid virtual address panic in kfree_debugcheck().
> The panic is due to an improper definition of pfn_valid().
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Added to next branch.

Thanks,
Michal


> ---
> diff -uprN a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
> --- a/arch/microblaze/include/asm/page.h	2009-09-09 17:13:59.000000000 -0500
> +++ b/arch/microblaze/include/asm/page.h	2009-11-13 15:20:26.000000000 -0600
> @@ -161,7 +161,8 @@ extern int page_is_ram(unsigned long pfn
>  #  endif /* CONFIG_MMU */
>  
>  #  ifndef CONFIG_MMU
> -#  define pfn_valid(pfn)	((pfn) >= min_low_pfn && (pfn) <= max_mapnr)
> +#  define pfn_valid(pfn)	(((pfn) >= min_low_pfn) && \
> +				((pfn) <= (min_low_pfn + max_mapnr)))
>  #  define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT)
>  #  else /* CONFIG_MMU */
>  #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
