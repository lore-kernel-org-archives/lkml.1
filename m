Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZCAUzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZCAUzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZCAUy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:54:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:50212 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753718AbZCAUy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:54:57 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19IFshfFTNIdnv9q6+E+GaQ/WjJpkCQQwXQvpZITJ
	yXp0CxdsgDrTCh
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: gpu/drm, x86, PAT: io_mapping_create_wc and resource_size_t
Date: Sun, 1 Mar 2009 21:54:50 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>, Ingo Molnar <mingo@elte.hu>
References: <200902280201.n1S217FR011162@hera.kernel.org> <200903011454.55865.s.L-H@gmx.de> <20090301165327.GA12970@linux-os.sc.intel.com>
In-Reply-To: <20090301165327.GA12970@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903012154.52961.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sonntag, 1. März 2009, Pallipadi, Venkatesh wrote:
> On Sun, Mar 01, 2009 at 05:54:53AM -0800, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Samstag, 28. Februar 2009, Linux Kernel Mailing List wrote:
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4ab0d47d0ab311eb181532c1ecb6d02905685071
> > > Commit:     4ab0d47d0ab311eb181532c1ecb6d02905685071
[...]
> >   Building modules, stage 2.
> >   MODPOST 809 modules
> > ERROR: "pgprot_writecombine" [drivers/gpu/drm/i915/i915.ko] undefined!
> > ERROR: "is_io_mapping_possible" [drivers/gpu/drm/i915/i915.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > This is a build regression in comparison to 2.6.29-rc6.
> > 
> 
> My bad. I had missed drm as module compilation. Below patch should fix it.
> Can you please verify.

Thanks, this builds fine for i386 and amd64 and seems to work on i945GME.

Regards
	Stefan Lippers-Hollmann
-- 
> Thanks,
> Venki
> 
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
>  arch/x86/mm/iomap_32.c     |    1 +
>  arch/x86/mm/pat.c          |    2 ++
>  include/linux/io-mapping.h |    3 ++-
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/mm/iomap_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/iomap_32.c	2009-03-01 08:31:12.000000000 -0800
> +++ linux-2.6/arch/x86/mm/iomap_32.c	2009-03-01 08:47:20.000000000 -0800
> @@ -37,6 +37,7 @@ is_io_mapping_possible(resource_size_t b
>  	return 1;
>  }
>  #endif
> +EXPORT_SYMBOL_GPL(is_io_mapping_possible);
>  
>  /* Map 'pfn' using fixed map 'type' and protections 'prot'
>   */
> Index: linux-2.6/arch/x86/mm/pat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/pat.c	2009-03-01 08:31:00.000000000 -0800
> +++ linux-2.6/arch/x86/mm/pat.c	2009-03-01 08:45:48.000000000 -0800
> @@ -11,6 +11,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/debugfs.h>
>  #include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/gfp.h>
>  #include <linux/mm.h>
>  #include <linux/fs.h>
> @@ -868,6 +869,7 @@ pgprot_t pgprot_writecombine(pgprot_t pr
>  	else
>  		return pgprot_noncached(prot);
>  }
> +EXPORT_SYMBOL(pgprot_writecombine);
>  
>  #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
>  
> Index: linux-2.6/include/linux/io-mapping.h
> ===================================================================
> --- linux-2.6.orig/include/linux/io-mapping.h	2009-03-01 08:31:12.000000000 -0800
> +++ linux-2.6/include/linux/io-mapping.h	2009-03-01 08:49:53.000000000 -0800
> @@ -91,8 +91,9 @@ io_mapping_unmap_atomic(void *vaddr)
>  static inline void *
>  io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
>  {
> +	resource_size_t phys_addr;
>  	BUG_ON(offset >= mapping->size);
> -	resource_size_t phys_addr = mapping->base + offset;
> +	phys_addr = mapping->base + offset;
>  	return ioremap_wc(phys_addr, PAGE_SIZE);
>  }
>  
> 


