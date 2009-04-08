Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbZDHH3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbZDHH3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763124AbZDHH2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:28:43 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65360 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763198AbZDHH2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=x55WC0R8pYA9RokbGmR19Ui0pvyT7o6j0ZRj3EfAzw2Ie4dkDb6l85+EQdZ8p6/oLx
         7plpsEJteBQSW7Ix8Hfo8WS2PUfB3ekKuqHGh7dnmgcFFn3KNtaIQVJDlewLM5nZrssm
         CsuwO1RjxL+G0hH7/taBH94djG+XtQmAsltVc=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Wed, 8 Apr 2009 09:28:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904071112.28949.a.miskiewicz@gmail.com> <20090408013008.GA6696@linux-os.sc.intel.com>
In-Reply-To: <20090408013008.GA6696@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904080928.34580.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 of April 2009, Pallipadi, Venkatesh wrote:
> On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz Miskiewicz wrote:
> > On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> > > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> > >
> > > I was finally able to reproduce the problem of "freeing invalid
> > > memtype" with upstream git kernel (commit 0221c81b1b) + latest xf86
> > > intel driver. But, with upstream + the patch I had sent you earlier in
> > > this thread (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I
> > > don't see those freeing invalid memtype errors anymore.
> > >
> > > Can you please double check with current git and that patch and let me
> > > know if you are still seeing the problem.
> >
> > Latest linus tree + that patch (it's really applied here), xserver 1.6,
> > libdrm from git master, intel driver from git master, previously mesa 7.4
> > (and 7.5 snap currently), tremolous.net 1.1.0 game (tremolous-smp
> > binary), GM45 gpu.
> >
> > To reproduce I just need to run tremolous-smp and connect to some map.
> > When map finishes loading I instantly get:
[...]

> OK. One more test patch below, applies over linus's git and you can ignore
> the earlier patch. The patch below should get rid of the problem and
> as it removes the track/untrack of vm_insert_pfn completely. This will
> also eliminate the overhead of hundreds or thousands of entries in
> pat_memtype_list. Can you please test it.

With this patch I'm no longer able to reproduce problem. Thanks!

Things look like this now:
# cat /debug/x86/pat_memtype_list 
PAT memtype list:                              
uncached-minus @ 0xbd6d1000-0xbd6d2000         
uncached-minus @ 0xbd6d2000-0xbd6d3000
uncached-minus @ 0xbd6d3000-0xbd6d4000
uncached-minus @ 0xbd706000-0xbd707000
uncached-minus @ 0xbd707000-0xbd708000
uncached-minus @ 0xbd96a000-0xbd96b000
uncached-minus @ 0xbd96a000-0xbd96b000
uncached-minus @ 0xbd96a000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd979000-0xbd97a000
uncached-minus @ 0xbd97b000-0xbd97c000
uncached-minus @ 0xbd98b000-0xbd98d000
uncached-minus @ 0xbd98b000-0xbd98e000
uncached-minus @ 0xbd98d000-0xbd98e000
uncached-minus @ 0xbd98e000-0xbd98f000
uncached-minus @ 0xbd98e000-0xbd98f000
uncached-minus @ 0xc2000000-0xc2001000
write-combining @ 0xd0000000-0xe0000000
write-combining @ 0xd2000000-0xd2020000
write-combining @ 0xd2020000-0xd2512000
uncached-minus @ 0xe0000000-0xe4000000
uncached-minus @ 0xf4400000-0xf4800000
uncached-minus @ 0xf4400000-0xf4480000
uncached-minus @ 0xf4600000-0xf4800000
uncached-minus @ 0xf4800000-0xf4801000
uncached-minus @ 0xf4801000-0xf4802000
uncached-minus @ 0xf4801000-0xf4802000
uncached-minus @ 0xfc000000-0xfc020000
uncached-minus @ 0xfc020000-0xfc024000
uncached-minus @ 0xfc025000-0xfc026000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc226000-0xfc227000
uncached-minus @ 0xfc227000-0xfc228000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed1f000-0xfed20000
# cat /proc/mtrr
reg00: base=0x13c000000 ( 5056MB), size=   64MB, count=1: uncachable
reg01: base=0x0be000000 ( 3040MB), size=   32MB, count=1: uncachable
reg02: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg03: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg04: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg05: base=0x0bde00000 ( 3038MB), size=    2MB, count=1: uncachable
reg06: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining


>
> Thanks,
> Venki
>
> ---
>  arch/x86/mm/pat.c |  124
> +++++++++++------------------------------------------ mm/memory.c       |  
> 14 +-----
>  2 files changed, 29 insertions(+), 109 deletions(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 640339e..5992af2 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -732,15 +732,11 @@ static void free_pfn_range(u64 paddr, unsigned long
> size) * track_pfn_vma_copy is called when vma that is covering the pfnmap
> gets * copied through copy_page_range().
>   *
> - * If the vma has a linear pfn mapping for the entire range, we get the
> prot - * from pte and reserve the entire vma range with single
> reserve_pfn_range call. - * Otherwise, we reserve the entire vma range, my
> ging through the PTEs page - * by page to get physical address and
> protection.
> + * We get the prot from pte and reserve the entire vma range with single
> + * reserve_pfn_range call.
>   */
>  int track_pfn_vma_copy(struct vm_area_struct *vma)
>  {
> -	int retval = 0;
> -	unsigned long i, j;
>  	resource_size_t paddr;
>  	unsigned long prot;
>  	unsigned long vma_start = vma->vm_start;
> @@ -751,94 +747,35 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
>  	if (!pat_enabled)
>  		return 0;
>
> -	if (is_linear_pfn_mapping(vma)) {
> -		/*
> -		 * reserve the whole chunk covered by vma. We need the
> -		 * starting address and protection from pte.
> -		 */
> -		if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
> -			WARN_ON_ONCE(1);
> -			return -EINVAL;
> -		}
> -		pgprot = __pgprot(prot);
> -		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
> -	}
> -
> -	/* reserve entire vma page by page, using pfn and prot from pte */
> -	for (i = 0; i < vma_size; i += PAGE_SIZE) {
> -		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
> -			continue;
> -
> -		pgprot = __pgprot(prot);
> -		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
> -		if (retval)
> -			goto cleanup_ret;
> -	}
> -	return 0;
> -
> -cleanup_ret:
> -	/* Reserve error: Cleanup partial reservation and return error */
> -	for (j = 0; j < i; j += PAGE_SIZE) {
> -		if (follow_phys(vma, vma_start + j, 0, &prot, &paddr))
> -			continue;
> -
> -		free_pfn_range(paddr, PAGE_SIZE);
> +	/*
> +	 * reserve the whole chunk covered by vma. We need the
> +	 * starting address and protection from pte.
> +	 */
> +	if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
>  	}
> -
> -	return retval;
> +	pgprot = __pgprot(prot);
> +	return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
>  }
>
>  /*
>   * track_pfn_vma_new is called when a _new_ pfn mapping is being
> established * for physical range indicated by pfn and size.
>   *
> - * prot is passed in as a parameter for the new mapping. If the vma has a
> - * linear pfn mapping for the entire range reserve the entire vma range
> with - * single reserve_pfn_range call.
> - * Otherwise, we look t the pfn and size and reserve only the specified
> range - * page by page.
> - *
> - * Note that this function can be called with caller trying to map only a
> - * subrange/page inside the vma.
> + * prot is passed in as a parameter for the new mapping.
>   */
>  int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>  			unsigned long pfn, unsigned long size)
>  {
> -	int retval = 0;
> -	unsigned long i, j;
> -	resource_size_t base_paddr;
>  	resource_size_t paddr;
> -	unsigned long vma_start = vma->vm_start;
> -	unsigned long vma_end = vma->vm_end;
> -	unsigned long vma_size = vma_end - vma_start;
>
>  	if (!pat_enabled)
>  		return 0;
>
> -	if (is_linear_pfn_mapping(vma)) {
> -		/* reserve the whole chunk starting from vm_pgoff */
> -		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
> -		return reserve_pfn_range(paddr, vma_size, prot, 0);
> -	}
> -
> -	/* reserve page by page using pfn and size */
> -	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
> -	for (i = 0; i < size; i += PAGE_SIZE) {
> -		paddr = base_paddr + i;
> -		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
> -		if (retval)
> -			goto cleanup_ret;
> -	}
> -	return 0;
> -
> -cleanup_ret:
> -	/* Reserve error: Cleanup partial reservation and return error */
> -	for (j = 0; j < i; j += PAGE_SIZE) {
> -		paddr = base_paddr + j;
> -		free_pfn_range(paddr, PAGE_SIZE);
> -	}
> -
> -	return retval;
> +	/* reserve the whole chunk starting from pfn */
> +	paddr = (resource_size_t)pfn << PAGE_SHIFT;
> +	return reserve_pfn_range(paddr, vma->vm_end - vma->vm_start, prot, 0);
>  }
>
>  /*
> @@ -849,7 +786,6 @@ cleanup_ret:
>  void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>  			unsigned long size)
>  {
> -	unsigned long i;
>  	resource_size_t paddr;
>  	unsigned long prot;
>  	unsigned long vma_start = vma->vm_start;
> @@ -859,29 +795,21 @@ void untrack_pfn_vma(struct vm_area_struct *vma,
> unsigned long pfn, if (!pat_enabled)
>  		return;
>
> -	if (is_linear_pfn_mapping(vma)) {
> -		/* free the whole chunk starting from vm_pgoff */
> -		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
> -		free_pfn_range(paddr, vma_size);
> +	if (pfn) {
> +		paddr = (resource_size_t)pfn << PAGE_SHIFT;
> +		free_pfn_range(paddr, size);
>  		return;
>  	}
>
> -	if (size != 0 && size != vma_size) {
> -		/* free page by page, using pfn and size */
> -		paddr = (resource_size_t)pfn << PAGE_SHIFT;
> -		for (i = 0; i < size; i += PAGE_SIZE) {
> -			paddr = paddr + i;
> -			free_pfn_range(paddr, PAGE_SIZE);
> -		}
> -	} else {
> -		/* free entire vma, page by page, using the pfn from pte */
> -		for (i = 0; i < vma_size; i += PAGE_SIZE) {
> -			if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
> -				continue;
> -
> -			free_pfn_range(paddr, PAGE_SIZE);
> -		}
> +	/*
> +	 * reserve the whole chunk covered by vma. We need the
> +	 * starting address pte.
> +	 */
> +	if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
> +		WARN_ON_ONCE(1);
> +		return;
>  	}
> +	free_pfn_range(paddr, vma_size);
>  }
>
>  pgprot_t pgprot_writecombine(pgprot_t prot)
> diff --git a/mm/memory.c b/mm/memory.c
> index cf6873e..4cae7e0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -719,7 +719,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct
> mm_struct *src_mm, if (is_vm_hugetlb_page(vma))
>  		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
>
> -	if (unlikely(is_pfn_mapping(vma))) {
> +	if (unlikely(is_linear_pfn_mapping(vma))) {
>  		/*
>  		 * We do not free on error cases below as remove_vma
>  		 * gets called on error from higher level routine
> @@ -982,7 +982,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>  		if (vma->vm_flags & VM_ACCOUNT)
>  			*nr_accounted += (end - start) >> PAGE_SHIFT;
>
> -		if (unlikely(is_pfn_mapping(vma)))
> +		if (unlikely(is_linear_pfn_mapping(vma)))
>  			untrack_pfn_vma(vma, 0, 0);
>
>  		while (start != end) {
> @@ -1515,7 +1515,6 @@ out:
>  int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn)
>  {
> -	int ret;
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	/*
>  	 * Technically, architectures with pte_special can avoid all these
> @@ -1531,15 +1530,8 @@ int vm_insert_pfn(struct vm_area_struct *vma,
> unsigned long addr,
>
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
>  		return -EFAULT;
> -	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
> -		return -EINVAL;
> -
> -	ret = insert_pfn(vma, addr, pfn, pgprot);
>
> -	if (ret)
> -		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
> -
> -	return ret;
> +	return insert_pfn(vma, addr, pfn, pgprot);
>  }
>  EXPORT_SYMBOL(vm_insert_pfn);


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

