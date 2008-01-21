Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYAUUsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYAUUsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbYAUUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:48:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbYAUUsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:48:17 -0500
Date: Mon, 21 Jan 2008 18:44:51 -0200
From: Eduardo Pereira Habkost <ehabkost@redhat.com>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: mingo@elte.hu, gcosta@redhat.com, glommer@gmail.com, jeremy@goop.org,
       chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fill in missing pv_mmu_ops entries for
	PAGETABLE_LEVELS >= 3
Message-ID: <20080121204451.GT7338@blackpad>
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080119181909.GA4640@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119181909.GA4640@dmt>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 04:19:09PM -0200, Marcelo Tosatti wrote:
> On Fri, Jan 18, 2008 at 03:20:15PM -0200, Glauber de Oliveira Costa wrote:
> > Hi,
> > 
> > This small series provides some more fixes towards the goal
> > to have the PARAVIRT selectable for x86_64. After that, just
> > some more small steps are needed.
> > 
> > The first fix is not even specific for PARAVIRT, and it's actually
> > preventing the whole tree from booting.
> > 
> 
> And the following allows PARAVIRT kernels to boot on x86_64.
> 
> -----
> 
> Fill in missing pagetable manipulation entries in pv_mmu_ops 
> for PAGETABLE_LEVELS >= 3.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> 
> Index: linux-2.6-x86/arch/x86/kernel/paravirt.c
> ===================================================================
> --- linux-2.6-x86.orig/arch/x86/kernel/paravirt.c
> +++ linux-2.6-x86/arch/x86/kernel/paravirt.c
> @@ -396,16 +396,25 @@ struct pv_mmu_ops pv_mmu_ops = {
>  	.kmap_atomic_pte = kmap_atomic,
>  #endif
>  
> +#if PAGETABLE_LEVELS >= 3
>  #ifdef CONFIG_X86_PAE
>  	.set_pte_atomic = native_set_pte_atomic,
>  	.set_pte_present = native_set_pte_present,
> -	.set_pud = native_set_pud,
>  	.pte_clear = native_pte_clear,
>  	.pmd_clear = native_pmd_clear,
> -
> +#endif
> +	.set_pud = native_set_pud,
> +	.set_pgd = native_set_pgd,
> +	.pgd_clear = native_pgd_clear,
>  	.pmd_val = native_pmd_val,
>  	.make_pmd = native_make_pmd,

Current x86.git doesn't have .set_pgd or .pgd_clear fields on
pv_mmu_ops.

Those fields, and the implementations of set_pgd(), __pud() and pud_val()
were missing on the last series from Glauber. I will send the missing
bits today.

> +	.pud_clear = native_pud_clear,

On the patches I will send, pud_clear() and pgd_clear() aren't present
on pv_mmu_ops and are implemented using set_pud() and set_pgd().

-- 
Eduardo
