Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZFDHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZFDHYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZFDHYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:24:02 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46219 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZFDHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:24:01 -0400
Date: Thu, 4 Jun 2009 00:24:00 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 9/9] exec_path 9/9: remove VM_EXECUTABLE
Message-ID: <20090604072400.GT9285@us.ibm.com>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090603230810.GJ853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230810.GJ853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 03:08:10AM +0400, Alexey Dobriyan wrote:
> Noone uses VM_EXECUTABLE now, binfmt loaders set ->exec_path by hand
> and MAP_EXECUTABLE is ignored from userland.

nit: MAP_EXECUTABLE is still used in the binfmt loaders when they
supply flags to do_mmap(). That needs to be removed before getting
rid of VM_EXECUTABLE.

Cheers,
	-Matt Helsley

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  include/linux/mm.h   |    1 -
>  include/linux/mman.h |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b3b61a6..79854af 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -82,7 +82,6 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
>  #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
> 
> -#define VM_EXECUTABLE	0x00001000
>  #define VM_LOCKED	0x00002000
>  #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
> 
> diff --git a/include/linux/mman.h b/include/linux/mman.h
> index 9872d6c..1a01871 100644
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -86,7 +86,6 @@ calc_vm_flag_bits(unsigned long flags)
>  {
>  	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
>  	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
> -	       _calc_vm_trans(flags, MAP_EXECUTABLE, VM_EXECUTABLE) |
>  	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
>  }
>  #endif /* __KERNEL__ */
