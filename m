Return-Path: <linux-kernel-owner+w=401wt.eu-S1423122AbXBUVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423122AbXBUVF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXBUVF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:05:58 -0500
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:59690 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423122AbXBUVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:05:57 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 16:05:57 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: akuster@mvista.com
Subject: Re: [patch 1/1] MM:  detach_vmas_to_be_unmapped fix
Date: Wed, 21 Feb 2007 21:59:03 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070221180742.A05F31C49A@hermes.mvista.com>
In-Reply-To: <20070221180742.A05F31C49A@hermes.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212159.07295.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 21. February 2007, akuster@mvista.com wrote:
> 
> ---
> 
>  mm/mmap.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN mm/mmap.c~Avoiding-mmap-fragmentation_fixup mm/mmap.c
> --- linux-2.6_clean/mm/mmap.c~Avoiding-mmap-fragmentation_fixup	2007-02-21 09:49:32.000000000 -0800
> +++ linux-2.6_clean-akuster/mm/mmap.c	2007-02-21 09:51:26.000000000 -0800
> @@ -1720,9 +1720,9 @@ detach_vmas_to_be_unmapped(struct mm_str
>  	*insertion_point = vma;
>  	tail_vma->vm_next = NULL;
>  	if (mm->unmap_area == arch_unmap_area)
> -		addr = prev ? prev->vm_end : mm->mmap_base;
> +		addr = prev ? prev->vm_start : mm->mmap_base;
>  	else
> -		addr = vma ?  vma->vm_start : mm->mmap_base;
> +		addr = vma ?  vma->vm_end : mm->mmap_base;
>  	mm->unmap_area(mm, addr);
>  	mm->mmap_cache = NULL;		/* Kill the cache. */
>  }

Please comment, why you think this is necessary.


Thanks & Regards

Ingo Oeser
