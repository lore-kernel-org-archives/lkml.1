Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYIHUX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYIHUX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYIHUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:23:49 -0400
Received: from gw.goop.org ([64.81.55.164]:43827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYIHUXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:23:49 -0400
Message-ID: <48C589D2.5030905@goop.org>
Date: Mon, 08 Sep 2008 13:23:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] x86: unsigned long pte_pfn
References: <Pine.LNX.4.64.0809082100090.30216@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0809082100090.30216@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> pte_pfn() has always been of type unsigned long, even on 32-bit PAE;
> but in the current tip/next/mm tree it's unsigned long long on 64-bit,
> which gives an irritating warning if you try to printk a pfn with the
> usual %lx.  Copy the inline function used by 32-bit's pgtable-3level.h.
>   

That looks OK, but rather than copying it, why not move the definition
into pgtable.h?  Isn't it identical for all pagetable modes?

    J

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>
>  include/asm-x86/pgtable_64.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> --- 2.6.27-rc5-mm1/include/asm-x86/pgtable_64.h	2008-09-05 10:08:04.000000000 +0100
> +++ linux/include/asm-x86/pgtable_64.h	2008-09-08 19:12:39.000000000 +0100
> @@ -182,7 +182,11 @@ static inline int pmd_bad(pmd_t pmd)
>  
>  #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
>  #define pte_page(x)	pfn_to_page(pte_pfn((x)))
> -#define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
> +
> +static inline unsigned long pte_pfn(pte_t pte)
> +{
> +	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
> +}
>  
>  /*
>   * Macro to mark a page protection value as "uncacheable".
>   

