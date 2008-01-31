Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbYAaTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbYAaTxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYAaTxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:53:07 -0500
Received: from gw.goop.org ([64.81.55.164]:37176 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYAaTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:53:07 -0500
Message-ID: <47A2270B.9050207@goop.org>
Date: Thu, 31 Jan 2008 11:52:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 04 of 11] x86: fix early_ioremap pagetable ops
References: <de52cce203cd6edeed0d.1201296193@localhost> <1201806096.20036.43.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201806096.20036.43.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
>
> This seems to have ended up in f6df72e71eba621b2f5c49b3a763116fac748f6e
> as:
> +	paravirt_release_pt(__pa(pmd) >> PAGE_SHIFT);
>
> and the pmd_populate_kernel hunk is missing altogether.
>
> ---
> >From bfa2a08064a269dd7906ed5f60e436360e1360e7 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Thu, 31 Jan 2008 18:56:06 +0000
> Subject: [PATCH] x86: fix early_ioremap pagetable ops for paravirt.
>
> Some important parts of f6df72e71eba621b2f5c49b3a763116fac748f6e got dropped
> along the way, reintroduce them.
>   

Yep.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> ---
>  arch/x86/mm/ioremap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index ed4208e..93d931e 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -302,7 +302,7 @@ void __init early_ioremap_init(void)
>  
>  	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
>  	memset(bm_pte, 0, sizeof(bm_pte));
> -	set_pmd(pmd, __pmd(__pa(bm_pte) | _PAGE_TABLE));
> +	pmd_populate_kernel(&init_mm, pmd, bm_pte);
>  
>  	/*
>  	 * The boot-ioremap range spans multiple pmds, for which
> @@ -332,7 +332,7 @@ void __init early_ioremap_clear(void)
>  
>  	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
>  	pmd_clear(pmd);
> -	paravirt_release_pt(__pa(pmd) >> PAGE_SHIFT);
> +	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
>  	__flush_tlb_all();
>  }
>  
>   

