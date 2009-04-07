Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZDGVp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZDGVp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbZDGVpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:45:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759967AbZDGVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:45:45 -0400
Date: Tue, 7 Apr 2009 14:38:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, tglx@linutronix.de,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 7/8] mm: allow preemption in apply_to_pte_range
Message-Id: <20090407143833.a6841a8b.akpm@linux-foundation.org>
In-Reply-To: <1238176963-21093-8-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
	<1238176963-21093-8-git-send-email-jeremy@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 11:02:42 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Impact: allow preemption in apply_to_pte_range updates to init_mm
> 
> Preemption is now allowed for lazy mmu mode, so don't disable
> it for the inner loop of apply_to_pte_range.  This only applies
> when doing updates to init_mm; user pagetables are still modified
> under the pte lock, so preemption is disabled anyway.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  mm/memory.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 27f8677..ef11ac6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1722,7 +1722,6 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  
>  	BUG_ON(pmd_huge(*pmd));
>  
> -	preempt_disable();
>  	arch_enter_lazy_mmu_mode();
>  
>  	token = pmd_pgtable(*pmd);
> @@ -1734,7 +1733,6 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>  
>  	arch_leave_lazy_mmu_mode();
> -	preempt_enable();
>  
>  	if (mm != &init_mm)
>  		pte_unmap_unlock(pte-1, ptl);

So across the aptch series the aggregate change to mm/ is nil, and this
is wholly an x86 patch series?

