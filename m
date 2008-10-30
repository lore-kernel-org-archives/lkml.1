Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYJ3Ktv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYJ3Ktv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYJ3Ktn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:49:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYJ3Ktn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:49:43 -0400
Date: Thu, 30 Oct 2008 11:49:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386/PAE: fix pud_page()
Message-ID: <20081030104926.GF3569@elte.hu>
References: <49099C71.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49099C71.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> To the unsuspecting user it is quite annoying that this broken and
> inconsistent with x86-64 definition still exists.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/pgtable-3level.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied, thanks Jan!

> -#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
> +#define pud_page(pud) pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
>  
>  #define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
>  
>  
>  /* Find an entry in the second-level page table.. */
> -#define pmd_offset(pud, address) ((pmd_t *)pud_page(*(pud)) +	\
> +#define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
>  				  pmd_index(address))

we were quite lucky there. Despite being a cleanup i've put this into 
x86/urgent - i agree that it's just too ugly and confusing.

	Ingo
