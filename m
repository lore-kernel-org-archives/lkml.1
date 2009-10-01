Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZJAXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZJAXnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZJAXnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:43:18 -0400
Received: from kroah.org ([198.145.64.141]:42028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbZJAXiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:20 2009
Message-Id: <20091001233320.095488110@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Izik Eidus <ieidus@redhat.com>, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 09/30] KVM: MMU: make __kvm_mmu_free_some_pages handle empty list
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-make-__kvm_mmu_free_some_pages-handle-empty-list.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Izik Eidus <ieidus@redhat.com>

(cherry picked from commit 3b80fffe2b31fb716d3ebe729c54464ee7856723)

First check if the list is empty before attempting to look at list
entries.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2612,7 +2612,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
+	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES &&
+	       !list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
 		struct kvm_mmu_page *sp;
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,


