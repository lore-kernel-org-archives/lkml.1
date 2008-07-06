Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYGFDge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYGFDge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 23:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYGFDg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 23:36:26 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:52187 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbYGFDgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 23:36:25 -0400
Message-ID: <48703D53.7000402@snapgear.com>
Date: Sun, 06 Jul 2008 13:34:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 16/20] m68knommu: use generic show_mem()
References: <20080704160737.750988999@saeurebad.de> <20080704161457.056057813@saeurebad.de>
In-Reply-To: <20080704161457.056057813@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Johannes Weiner wrote:
> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- free pages, printed by show_free_areas()
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>



> ---
>  arch/m68knommu/mm/init.c |   27 ---------------------------
>  1 file changed, 27 deletions(-)
> 
> --- a/arch/m68knommu/mm/init.c
> +++ b/arch/m68knommu/mm/init.c
> @@ -62,33 +62,6 @@ static unsigned long empty_bad_page;
>  
>  unsigned long empty_zero_page;
>  
> -void show_mem(void)
> -{
> -    unsigned long i;
> -    int free = 0, total = 0, reserved = 0, shared = 0;
> -    int cached = 0;
> -
> -    printk(KERN_INFO "\nMem-info:\n");
> -    show_free_areas();
> -    i = max_mapnr;
> -    while (i-- > 0) {
> -	total++;
> -	if (PageReserved(mem_map+i))
> -	    reserved++;
> -	else if (PageSwapCache(mem_map+i))
> -	    cached++;
> -	else if (!page_count(mem_map+i))
> -	    free++;
> -	else
> -	    shared += page_count(mem_map+i) - 1;
> -    }
> -    printk(KERN_INFO "%d pages of RAM\n",total);
> -    printk(KERN_INFO "%d free pages\n",free);
> -    printk(KERN_INFO "%d reserved pages\n",reserved);
> -    printk(KERN_INFO "%d pages shared\n",shared);
> -    printk(KERN_INFO "%d pages swap cached\n",cached);
> -}
> -
>  extern unsigned long memory_start;
>  extern unsigned long memory_end;
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
