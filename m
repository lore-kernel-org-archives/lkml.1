Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYL2GzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYL2GzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 01:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYL2GzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 01:55:00 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58428 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYL2Gy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 01:54:59 -0500
Subject: Re: [PATCH] powerpc: fix compile damage from 2a4aca11
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Rusty Russell <rusty@fandango2.ozlabs.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <200812291711.26118.rusty@fandango2.ozlabs.ibm.com>
References: <200812291711.26118.rusty@fandango2.ozlabs.ibm.com>
Content-Type: text/plain
Organization: IBM Australia
Date: Mon, 29 Dec 2008 17:47:17 +1100
Message-Id: <1230533237.15389.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 17:41 +1100, Rusty Russell wrote:
> In file included from /scratch/kisskb/src/arch/powerpc/mm/mem.c:51:
> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h: In function
> '_tlbil_all':
> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h:34: error: expected ';'
> before '}' token
> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h:36: error: invalid
> storage class for function '_tlbil_pid'
> 
> "powerpc/mm: Split low level tlb invalidate for nohash processors" needs
> more semicolons.  Or testing.  Or both.

Yeah, looks like both paulus and I are missing 40x and 8xx test configs
in our build tests :-( I'll fix that.,

> Signed-off-by: Rusty Russell <rusty@Fandango2.ozlabs.ibm.com>

Nice signed-off :-)

Cheers,
Ben.


> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
> index 4314b39..ad123bc 100644
> --- a/arch/powerpc/mm/mmu_decl.h
> +++ b/arch/powerpc/mm/mmu_decl.h
> @@ -30,11 +30,11 @@
>  #if defined(CONFIG_40x) || defined(CONFIG_8xx)
>  static inline void _tlbil_all(void)
>  {
> -	asm volatile ("sync; tlbia; isync" : : : "memory")
> +	asm volatile ("sync; tlbia; isync" : : : "memory");
>  }
>  static inline void _tlbil_pid(unsigned int pid)
>  {
> -	asm volatile ("sync; tlbia; isync" : : : "memory")
> +	asm volatile ("sync; tlbia; isync" : : : "memory");
>  }
>  #else /* CONFIG_40x || CONFIG_8xx */
>  extern void _tlbil_all(void);
> @@ -47,7 +47,7 @@ extern void _tlbil_pid(unsigned int pid);
>  #ifdef CONFIG_8xx
>  static inline void _tlbil_va(unsigned long address, unsigned int pid)
>  {
> -	asm volatile ("tlbie %0; sync" : : "r" (address) : "memory")
> +	asm volatile ("tlbie %0; sync" : : "r" (address) : "memory");
>  }
>  #else /* CONFIG_8xx */
>  extern void _tlbil_va(unsigned long address, unsigned int pid);

