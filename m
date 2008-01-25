Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYAYKOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYAYKOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYAYKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:14:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYAYKOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:14:33 -0500
Date: Fri, 25 Jan 2008 11:14:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86: Remove nx_enabled from fault.c
Message-ID: <20080125101418.GP23708@elte.hu>
References: <1201236068.12822.7.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201236068.12822.7.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On !PAE 32-bit, _PAGE_NX will be 0, making is_prefetch always return 
> early.  The test is sufficient on PAE as __supported_pte_mask is 
> updated in the same places as nx_enabled in init_32.c which also takes 
> disable_nx into account.

> @@ -92,18 +92,13 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
>  	unsigned char *max_instr;
>  
>  #ifdef CONFIG_X86_32
> -# ifdef CONFIG_X86_PAE
> -	/* If it was a exec fault on NX page, ignore */
> -	if (nx_enabled && (error_code & PF_INSTR))
> +	if (!(__supported_pte_mask & _PAGE_NX))
>  		return 0;
> -# else
> -	return 0;
> -# endif
> -#else /* CONFIG_X86_64 */
> +#endif
> +

thanks, applied this portion of the patch.

> @@ -468,7 +463,7 @@ static int vmalloc_fault(unsigned long address)
>  	pmd_t *pmd, *pmd_ref;
>  	pte_t *pte, *pte_ref;
>  
> -	if (address >= VMALLOC_START && address < VMALLOC_END)
> +	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;

hm, what's this?

	Ingo
