Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZBRSna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZBRSna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBRSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:43:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZBRSnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:43:20 -0500
Date: Wed, 18 Feb 2009 15:42:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
Message-ID: <20090218184234.GF25719@amt.cnet>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com> <499C1158.7020401@redhat.com> <20090218135436.GF8751@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218135436.GF8751@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 02:54:37PM +0100, Joerg Roedel wrote:
> > Adding __GFP_ZERO here will cause us to clear the page twice, which is wasteful.
> 
> The assertion which the attached patch removes fails sometimes. Removing
> this assertion is the alternative solution to this problem ;-)
> 

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 18 Feb 2009 14:51:13 +0100
Subject: [PATCH] kvm mmu: remove assertion in kvm_mmu_alloc_page

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 
 diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
 index d93ecec..b226973 100644
 --- a/arch/x86/kvm/mmu.c
 +++ b/arch/x86/kvm/mmu.c
 @@ -802,7 +802,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
  	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
  	INIT_LIST_HEAD(&sp->oos_link);
 -	ASSERT(is_empty_shadow_page(sp->spt));
  	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
  	sp->multimapped = 0;
  	sp->parent_pte = parent_pte;
