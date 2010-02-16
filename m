Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab0BPKfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab0BPKfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/38] KVM: fix Hyper-V hypercall warnings and wrong mask value
Date: Tue, 16 Feb 2010 12:35:01 +0200
Message-Id: <1266316536-28936-4-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Fix compilation warnings and wrong mask value.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f72a44..9b0758b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3806,12 +3806,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	longmode = is_long_mode(vcpu) && cs_l == 1;
 
 	if (!longmode) {
-		param = (kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffff);
-		ingpa = (kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffff);
-		outgpa = (kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffff);
+		param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
+		ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
+		outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
 	}
 #ifdef CONFIG_X86_64
 	else {
-- 
1.6.5.3

