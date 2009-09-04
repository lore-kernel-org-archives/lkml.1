Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbZIDUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbZIDUS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934053AbZIDUOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:34 -0400
Received: from kroah.org ([198.145.64.141]:36218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934050AbZIDUOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200854.271909531@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 27/48] KVM: Make paravirt tlb flush also reload the PAE PDPTRs
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-make-paravirt-tlb-flush-also-reload-the-pae-pdptrs.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit a8cd0244e9cebcf9b358d24c7e7410062f3665cb)

The paravirt tlb flush may be used not only to flush TLBs, but also
to reload the four page-directory-pointer-table entries, as it is used
as a replacement for reloading CR3.  Change the code to do the entire
CR3 reloading dance instead of simply flushing the TLB.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2233,7 +2233,7 @@ static int kvm_pv_mmu_write(struct kvm_v
 
 static int kvm_pv_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->tlb_flush(vcpu);
+	kvm_set_cr3(vcpu, vcpu->arch.cr3);
 	return 1;
 }
 


