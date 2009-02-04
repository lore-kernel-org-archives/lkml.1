Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZBDUUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZBDUUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbZBDUUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:20:38 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43199 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbZBDUUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:20:37 -0500
Date: Wed, 4 Feb 2009 15:20:36 -0500
To: linux-kernel@vger.kernel.org
Cc: linux-m68k@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090204202036.GJ26064@csclub.uwaterloo.ca>
References: <20090204181453.GE26064@csclub.uwaterloo.ca> <20090204183142.GF26064@csclub.uwaterloo.ca> <20090204184659.GG26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090204184659.GG26064@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux-m68k@lists.linux-m68k.org to CC

-- 
Len Sorensen

On Wed, Feb 04, 2009 at 01:46:59PM -0500, Lennart Sorensen wrote:
> On Wed, Feb 04, 2009 at 01:31:42PM -0500, Lennart Sorensen wrote:
> > On Wed, Feb 04, 2009 at 01:14:53PM -0500, Lennart Sorensen wrote:
> > > make header_install fails to include the files unistd_no.h and
> > > unistd_mm.h on m68k, while those two files are included by unistd.h.
> > > 
> > > This patch fixes this by adding these two files to the list of m68k
> > > specific headers to export.
> > > 
> > > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > > 
> > > Signed
> > > diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> > > index 1a922fa..2bb4738 100644
> > > --- a/arch/m68k/include/asm/Kbuild
> > > +++ b/arch/m68k/include/asm/Kbuild
> > > @@ -1,2 +1,2 @@
> > >  include include/asm-generic/Kbuild.asm
> > > -header-y += cachectl.h
> > > +header-y += cachectl.h unistd_no.h unistd_mm.h
> > 
> > Hmm, seems it is actually much worse than I thought.  All _no.h and
> > _mm.h are being missed, making m68k compiles of things like uclibc
> > rather broken.  Yuck.
> 
> So updated patch that makes uclibc actually compile for m68k.
> 
> -- 
> Len Sorensen
> 
> 
> 
> make header_install fails to include the files *_no.h and
> *_mm.h on m68k, while those files are included by the matching *.h
> 
> This patch fixes this by adding these missing files to the list of m68k
> specific headers to export.  With this patch, uclibc compiles again.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index 1a922fa..c69926c 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -1,2 +1,2 @@
>  include include/asm-generic/Kbuild.asm
> -header-y += cachectl.h
> +header-y += cachectl.h atomic_mm.h atomic_no.h bitops_mm.h bitops_no.h bootinfo_mm.h bootinfo_no.h bug_mm.h bug_no.h bugs_mm.h bugs_no.h cache_mm.h cache_no.h cacheflush_mm.h cacheflush_no.h checksum_mm.h checksum_no.h current_mm.h current_no.h delay_mm.h delay_no.h div64_mm.h div64_no.h dma-mapping_mm.h dma-mapping_no.h dma_mm.h dma_no.h elf_mm.h elf_no.h entry_mm.h entry_no.h fb_mm.h fb_no.h fpu_mm.h fpu_no.h hardirq_mm.h hardirq_no.h hw_irq_mm.h hw_irq_no.h io_mm.h io_no.h irq_mm.h irq_no.h kmap_types_mm.h kmap_types_no.h machdep_mm.h machdep_no.h mc146818rtc_mm.h mc146818rtc_no.h mmu_context_mm.h mmu_context_no.h mmu_mm.h mmu_no.h module_mm.h module_no.h page_mm.h page_no.h page_offset_mm.h page_offset_no.h param_mm.h param_no.h pci_mm.h pci_no.h pgalloc_mm.h pgalloc_no.h pgtable_mm.h pgtable_no.h processor_mm.h processor_no.h ptrace_mm.h ptrace_no.h scatterlist_mm.h scatterlist_no.h segment_mm.h segment_no.h setup_mm.h setup_no.h sigcontext_mm.h sigcontext_no.h siginfo_mm.h siginfo_no.h signal_mm.h signal_no.h string_mm.h string_no.h swab_mm.h swab_no.h system_mm.h system_no.h thread_info_mm.h thread_info_no.h timex_mm.h timex_no.h tlbflush_mm.h tlbflush_no.h traps_mm.h traps_no.h uaccess_mm.h uaccess_no.h ucontext_mm.h ucontext_no.h unaligned_mm.h unaligned_no.h unistd_mm.h unistd_no.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
