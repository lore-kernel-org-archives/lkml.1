Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYATFF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYATFF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYATFFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:05:21 -0500
Received: from gw.goop.org ([64.81.55.164]:51305 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYATFFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:05:20 -0500
Message-ID: <4792D68D.8090307@goop.org>
Date: Sat, 19 Jan 2008 21:05:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Marcelo Tosatti <marcelo@kvack.org>
CC: mingo@elte.hu, gcosta@redhat.com, ehabkost@redhat.com, glommer@gmail.com,
       chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fill in missing pv_mmu_ops entries for PAGETABLE_LEVELS
 >= 3
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080119181909.GA4640@dmt>
In-Reply-To: <20080119181909.GA4640@dmt>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Fri, Jan 18, 2008 at 03:20:15PM -0200, Glauber de Oliveira Costa wrote:
>   
>> Hi,
>>
>> This small series provides some more fixes towards the goal
>> to have the PARAVIRT selectable for x86_64. After that, just
>> some more small steps are needed.
>>
>> The first fix is not even specific for PARAVIRT, and it's actually
>> preventing the whole tree from booting.
>>
>>     
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

Looks good, thanks.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

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
> +
> +#if PAGETABLE_LEVELS == 4
> +	.pud_val = native_pud_val,
> +	.make_pud = native_make_pud,
> +	.pud_clear = native_pud_clear,
>  #endif
> +#endif /* PAGETABLE_LEVELS >= 3 */
>  
>  	.pte_val = native_pte_val,
>  	.pgd_val = native_pgd_val,
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

