Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZHSNEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZHSNEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZHSNEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50580 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752004AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/47] KVM: use vcpu_id instead of bsp_vcpu pointer in kvm_vcpu_is_bsp
Date: Wed, 19 Aug 2009 16:02:36 +0300
Message-Id: <1250686963-8357-41-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Change kvm_vcpu_is_bsp to use vcpu_id instead of bsp_vcpu pointer, which
is only initialized at the end of kvm_vm_ioctl_create_vcpu.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0604d56..4ea42c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -538,7 +538,7 @@ static inline void kvm_irqfd_release(struct kvm *kvm) {}
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-	return vcpu->kvm->bsp_vcpu == vcpu;
+	return vcpu->kvm->bsp_vcpu_id == vcpu->vcpu_id;
 }
 #endif
 #endif
-- 
1.6.3.3

