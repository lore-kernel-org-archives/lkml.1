Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZCNQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZCNQ1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZCNQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:27:04 -0400
Received: from www.tglx.de ([62.245.132.106]:60833 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZCNQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:27:03 -0400
Date: Sat, 14 Mar 2009 17:20:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: trampoline.c cleanup
In-Reply-To: <1237045494.4546.22.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain>
References: <1237045494.4546.22.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:

> Subject: [PATCH] x86: trampoline.c cleanup
> 
> Impact: cleanup
> 
>  - fix style problems

Err. This patch is a style problem itself.
 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/trampoline.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> index 808031a..e3b1f2e 100644
> --- a/arch/x86/kernel/trampoline.c
> +++ b/arch/x86/kernel/trampoline.c
> @@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
>  	 * trampoline before removing it. (see the GDT stuff)
>  	 */
>  	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
> -#endif
> +#endif /* CONFIG_X86_32 */

There is no need for this useless comment. The #ifdef is 5 lines
above. Such comments are only helpful in large nested sections.

>  	/* Has to be in very low memory so we can execute real-mode AP code. */
>  	reserve_early(TRAMPOLINE_BASE, TRAMPOLINE_BASE + TRAMPOLINE_SIZE,
>  			"TRAMPOLINE");
> @@ -29,5 +29,6 @@ void __init reserve_trampoline_memory(void)
>  unsigned long setup_trampoline(void)
>  {
>  	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
> +
>  	return virt_to_phys(trampoline_base);

What's the purpose of this ?

Can we please apply some common sense and not just run down a
checklist and modify files for no value.

Thanks,

	tglx
