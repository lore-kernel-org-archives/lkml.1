Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229Ab0AZXra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0AZXra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009Ab0AZXrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:47:09 -0500
Received: from kroah.org ([198.145.64.141]:35545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab0AZXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233932.903327347@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [91/98] KVM: x86: Fix probable memory leak of vcpu->arch.mce_banks
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

commit 36cb93fd6b6bf7e9163a69a8bf20207aed5fea44 upstream.

vcpu->arch.mce_banks is malloc in kvm_arch_vcpu_init(), but
never free in any place, this may cause memory leak. So this
patch fixed to free it in kvm_arch_vcpu_uninit().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4782,6 +4782,7 @@ fail:
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
 	down_read(&vcpu->kvm->slots_lock);
 	kvm_mmu_destroy(vcpu);


