Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZKLJCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZKLJCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZKLJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:02:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:52020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZKLJCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:02:17 -0500
Subject: Re: linux-next: rr tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20091112190308.443d97a3.sfr@canb.auug.org.au>
References: <20091112190308.443d97a3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 20:02:00 +1100
Message-ID: <1258016520.2140.329.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 19:03 +1100, Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> 
> .tmp_exports-asm.o: In function `__ksymtab_pci_alloc_consistent':
> (__ksymtab_sorted+0x2a30): undefined reference to `pci_alloc_consistent'
> .tmp_exports-asm.o: In function `__ksymtab_pci_free_consistent':
> (__ksymtab_sorted+0x2b70): undefined reference to `pci_free_consistent'
> 
> Caused by the powerpc architecture EXPORTing static inlines (for 32 bit
> builds) interacting with changes in the rr tree.
> 
> I have applied this patch for today:

Thanks. Our EXPORTs are bogus (probably leftovers) it seems. I'll dbl
check tomorrow but that looks like a patch I should pickup in powerpc
-next anyways.

Cheers,
Ben.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 12 Nov 2009 18:54:13 +1100
> Subject: [PATCH] powerpc: do not export pci_alloc/free_consistent
> 
> Since they are static inline functions.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/kernel/ppc_ksyms.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
> index 07115d6..4254514 100644
> --- a/arch/powerpc/kernel/ppc_ksyms.c
> +++ b/arch/powerpc/kernel/ppc_ksyms.c
> @@ -96,8 +96,6 @@ EXPORT_SYMBOL(copy_4K_page);
>  EXPORT_SYMBOL(isa_io_base);
>  EXPORT_SYMBOL(isa_mem_base);
>  EXPORT_SYMBOL(pci_dram_offset);
> -EXPORT_SYMBOL(pci_alloc_consistent);
> -EXPORT_SYMBOL(pci_free_consistent);
>  #endif /* CONFIG_PCI */
>  
>  EXPORT_SYMBOL(start_thread);
> -- 
> 1.6.5.2
> 


