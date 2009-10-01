Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZJAXiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZJAXiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZJAXiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:12 -0400
Received: from kroah.org ([198.145.64.141]:42037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZJAXiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233320.549424364@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 12/30] KVM: MMU: fix bogus alloc_mmu_pages assignment
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-fix-bogus-alloc_mmu_pages-assignment.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit b90c062c65cc8839edfac39778a37a55ca9bda36)

Remove the bogus n_free_mmu_pages assignment from alloc_mmu_pages.

It breaks accounting of mmu pages, since n_free_mmu_pages is modified
but the real number of pages remains the same.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2692,14 +2692,6 @@ static int alloc_mmu_pages(struct kvm_vc
 
 	ASSERT(vcpu);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (vcpu->kvm->arch.n_requested_mmu_pages)
-		vcpu->kvm->arch.n_free_mmu_pages =
-					vcpu->kvm->arch.n_requested_mmu_pages;
-	else
-		vcpu->kvm->arch.n_free_mmu_pages =
-					vcpu->kvm->arch.n_alloc_mmu_pages;
-	spin_unlock(&vcpu->kvm->mmu_lock);
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first


