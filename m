Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZGRONG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZGRONG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZGRONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:13:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54951 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZGRONE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:13:04 -0400
Date: Sat, 18 Jul 2009 16:11:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove initialization of page_table in
	one_page_table_init()
Message-ID: <20090718141157.GH32618@elte.hu>
References: <4A5C488A.90204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5C488A.90204@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> Only judge if (!page_table) when CONFIG_DEBUG_PAGEALLOC or CONFIG_KMEMCHECK
> are defined, then we don't need to set init value for page_table.
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
> arch/x86/mm/init_32.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3cd7711..55da09b 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -108,13 +108,13 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
> static pte_t * __init one_page_table_init(pmd_t *pmd)
> {
>     if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
> -        pte_t *page_table = NULL;
> +        pte_t *page_table;
>
>         if (after_bootmem) {
> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>             page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
> -#endif
>             if (!page_table)
> +#endif
>                 page_table =
>                 (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);

I think the original code was cleaner - putting an #ifdef straight 
into the middle of a control block is quite fragile.

	Ingo
