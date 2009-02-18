Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZBRODU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZBRODU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBRODJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:03:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZBRODH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:03:07 -0500
Message-ID: <499C1536.30302@redhat.com>
Date: Wed, 18 Feb 2009 14:03:34 +0000
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com> <499C1158.7020401@redhat.com> <20090218135436.GF8751@amd.com>
In-Reply-To: <20090218135436.GF8751@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> The assertion which the attached patch removes fails sometimes. Removing
> this assertion is the alternative solution to this problem ;-)
>
> From ca45f3a2e45cd7e76ca624bb1098329db8ff83ab Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Wed, 18 Feb 2009 14:51:13 +0100
> Subject: [PATCH] kvm mmu: remove assertion in kvm_mmu_alloc_page
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index d93ecec..b226973 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -802,7 +802,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&sp->oos_link);
> -	ASSERT(is_empty_shadow_page(sp->spt));
>  	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
>  	sp->multimapped = 0;
>  	sp->parent_pte = parent_pte;
>   

sp->spt is allocated using mmu_memory_cache_alloc(), which zeros the 
page.  How can the assertion fail?


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

