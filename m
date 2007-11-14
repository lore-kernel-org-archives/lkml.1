Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbXKNUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbXKNUz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbXKNUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:55:21 -0500
Received: from koto.vergenet.net ([210.128.90.7]:36942 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761375AbXKNUzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:55:18 -0500
Date: Wed, 14 Nov 2007 12:55:10 -0800
From: Simon Horman <horms@verge.net.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IA64 efi: make full use of macro efi_md_size
Message-ID: <20071114205459.GC2368@verge.net.au>
References: <4737AF9D.7070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4737AF9D.7070403@cn.fujitsu.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 09:42:53AM +0800, Li Zefan wrote:
> Macro efi_md_size is defined in efi.c, and here we apply it
> throughout efi.c.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

This looks correct to me.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  arch/ia64/kernel/efi.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index 0e4ef20..7392d7b 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -369,7 +369,7 @@ efi_get_pal_addr (void)
>  			continue;
>  		}
>  
> -		if (md->num_pages << EFI_PAGE_SHIFT > IA64_GRANULE_SIZE)
> +		if (efi_md_size(md) > IA64_GRANULE_SIZE)
>  			panic("Woah!  PAL code size bigger than a granule!");
>  
>  #if EFI_DEBUG
> @@ -377,7 +377,7 @@ efi_get_pal_addr (void)
>  
>  		printk(KERN_INFO "CPU %d: mapping PAL code [0x%lx-0x%lx) into [0x%lx-0x%lx)\n",
>  			smp_processor_id(), md->phys_addr,
> -			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> +			md->phys_addr + efi_md_size(md),
>  			vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
>  #endif
>  		return __va(md->phys_addr);
> @@ -522,7 +522,7 @@ efi_init (void)
>  			md = p;
>  			printk("mem%02u: type=%u, attr=0x%lx, range=[0x%016lx-0x%016lx) (%luMB)\n",
>  			       i, md->type, md->attribute, md->phys_addr,
> -			       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> +			       md->phys_addr + efi_md_size(md),
>  			       md->num_pages >> (20 - EFI_PAGE_SHIFT));
>  		}
>  	}
> @@ -655,7 +655,7 @@ efi_memory_descriptor (unsigned long phys_addr)
>  	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
>  		md = p;
>  
> -		if (phys_addr - md->phys_addr < (md->num_pages << EFI_PAGE_SHIFT))
> +		if (phys_addr - md->phys_addr < efi_md_size(md))
>  			 return md;
>  	}
>  	return NULL;
> @@ -1159,7 +1159,7 @@ efi_initialize_iomem_resources(struct resource *code_resource,
>  
>  		res->name = name;
>  		res->start = md->phys_addr;
> -		res->end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
> +		res->end = md->phys_addr + efi_md_size(md) - 1;
>  		res->flags = flags;
>  
>  		if (insert_resource(&iomem_resource, res) < 0)
> -- 
> 1.5.3.rc7
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Horms, California Edition

