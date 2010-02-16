Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0BPKhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:37:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/38] KVM: VMX: Remove redundant check in vm_need_virtualize_apic_accesses()
Date: Tue, 16 Feb 2010 12:35:27 +0200
Message-Id: <1266316536-28936-30-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

flexpriority_enabled implies cpu_has_vmx_virtualize_apic_accesses() returning
true, so we don't need this check here.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 334b016..f083b64 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -358,9 +358,7 @@ static inline int cpu_has_vmx_ple(void)
 
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
-	return flexpriority_enabled &&
-		(cpu_has_vmx_virtualize_apic_accesses()) &&
-		(irqchip_in_kernel(kvm));
+	return flexpriority_enabled && irqchip_in_kernel(kvm);
 }
 
 static inline int cpu_has_vmx_vpid(void)
-- 
1.6.5.3

