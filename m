Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbYBKJpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbYBKJpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYBKJpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:45:43 -0500
Received: from www.tglx.de ([62.245.132.106]:45879 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYBKJpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:45:43 -0500
Date: Mon, 11 Feb 2008 10:45:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/8] CPA: Fix gbpages support in
 try_preserve_lage_page
In-Reply-To: <20080211093429.CD9D31B41CE@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802111043340.12988@apollo.tec.linutronix.de>
References: <200802111034.764275766@suse.de> <20080211093429.CD9D31B41CE@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:

> 
> Use correct page sizes and masks for GB pages in try_preserve_large_page()
> 
> This prevents a boot hang on a GB capable system with CONFIG_DIRECT_GBPAGES
> enabled.

Doh, yes. Applied.

Thanks,
	tglx

> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/pageattr.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr.c
> +++ linux/arch/x86/mm/pageattr.c
> @@ -278,8 +278,8 @@ try_preserve_large_page(pte_t *kpte, uns
>  		break;
>  #ifdef CONFIG_X86_64
>  	case PG_LEVEL_1G:
> -		psize = PMD_PAGE_SIZE;
> -		pmask = PMD_PAGE_MASK;
> +		psize = PUD_PAGE_SIZE;
> +		pmask = PUD_PAGE_MASK;
>  		break;
>  #endif
>  	default:
> 
