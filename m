Return-Path: <linux-kernel-owner+w=401wt.eu-S1945895AbXBPPC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945895AbXBPPC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945898AbXBPPC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:02:59 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50932 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945895AbXBPPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:02:58 -0500
Message-ID: <45D5C789.1090607@student.ltu.se>
Date: Fri, 16 Feb 2007 16:02:33 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Vignesh Babu BM <vignesh.babu@wipro.com>
CC: Kernel Janitors List <kernel-janitors@lists.osdl.org>, linux-mm@kvack.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] [PATCH] is_power_of_2 in ia64mm
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
In-Reply-To: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vignesh Babu BM wrote:
> Replacing (n & (n-1)) in the context of power of 2 checks
> with is_power_of_2
>
>
> diff --git a/arch/ia64/mm/hugetlbpage.c b/arch/ia64/mm/hugetlbpage.c
> index 0c7e94e..0ccc70e 100644
> --- a/arch/ia64/mm/hugetlbpage.c
> +++ b/arch/ia64/mm/hugetlbpage.c
> @@ -16,6 +16,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/slab.h>
>  #include <linux/sysctl.h>
> +#include <linux/log2.h>
>  #include <asm/mman.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlb.h>
> @@ -175,7 +176,7 @@ static int __init hugetlb_setup_sz(char *str)
>  		tr_pages = 0x15557000UL;
>  
>  	size = memparse(str, &str);
> -	if (*str || (size & (size-1)) || !(tr_pages & size) ||
> +	if (*str || !is_power_of_2(size) || !(tr_pages & size) ||
>  		size <= PAGE_SIZE ||
>  		size >= (1UL << PAGE_SHIFT << MAX_ORDER)) {
>  		printk(KERN_WARNING "Invalid huge page size specified\n");
>
>   
As we talked about before; is this really correct? !is_power_of_2(0) == 
true while (0 & (0-1)) == 0.

Richard Knutsson

