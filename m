Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbYEIPgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbYEIPgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYEIPf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:35:57 -0400
Received: from www.tglx.de ([62.245.132.106]:38815 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbYEIPf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:35:56 -0400
Date: Fri, 9 May 2008 17:35:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 5 of 8] x86: use PTE_MASK in pgtable_32.h
In-Reply-To: <a2ab59b40561969b7fea.1210330963@localhost>
Message-ID: <alpine.LFD.1.10.0805091733550.3197@apollo.tec.linutronix.de>
References: <a2ab59b40561969b7fea.1210330963@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Jeremy Fitzhardinge wrote:

> ---
>  include/asm-x86/pgtable_32.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
> --- a/include/asm-x86/pgtable_32.h
> +++ b/include/asm-x86/pgtable_32.h
> @@ -98,9 +98,9 @@
>  extern int pmd_bad(pmd_t pmd);
>  
>  #define pmd_bad_v1(x)							\
> -	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER)))
> +	(_KERNPG_TABLE != (pmd_val((x)) & ~(PTE_MASK | _PAGE_USER)))
>  #define	pmd_bad_v2(x)							\
> -	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER |	\
> +	(_KERNPG_TABLE != (pmd_val((x)) & ~(PTE_MASK | _PAGE_USER |	\

that's gone from mainline already. Hugh's patch restored the old pmd_bad check.

Thanks,
	tglx
