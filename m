Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0BPKmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:42:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/38] KVM: Move cr0/cr4/efer related helpers to x86.h
Date: Tue, 16 Feb 2010 12:35:15 +0200
Message-Id: <1266316536-28936-18-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They have more general scope than the mmu.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/emulate.c |    1 -
 arch/x86/kvm/mmu.c     |    1 +
 arch/x86/kvm/mmu.h     |   24 ------------------------
 arch/x86/kvm/x86.h     |   24 ++++++++++++++++++++++++
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6a429ee..645b245 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -33,7 +33,6 @@
 #include <asm/kvm_emulate.h>
 
 #include "x86.h"
-#include "mmu.h"		/* for is_long_mode() */
 
 /*
  * Opcode effective-address decode tables.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff2b2e8..6f7158f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -18,6 +18,7 @@
  */
 
 #include "mmu.h"
+#include "x86.h"
 #include "kvm_cache_regs.h"
 
 #include <linux/kvm_host.h>
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 599159f..61ef5a6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -58,30 +58,6 @@ static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 	return kvm_mmu_load(vcpu);
 }
 
-static inline int is_long_mode(struct kvm_vcpu *vcpu)
-{
-#ifdef CONFIG_X86_64
-	return vcpu->arch.shadow_efer & EFER_LMA;
-#else
-	return 0;
-#endif
-}
-
-static inline int is_pae(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
-}
-
-static inline int is_pse(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr4_bits(vcpu, X86_CR4_PSE);
-}
-
-static inline int is_paging(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
-}
-
 static inline int is_present_gpte(unsigned long pte)
 {
 	return pte & PT_PRESENT_MASK;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f783d8f..2dc24a7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -41,4 +41,28 @@ static inline bool is_protmode(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PE);
 }
 
+static inline int is_long_mode(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_X86_64
+	return vcpu->arch.shadow_efer & EFER_LMA;
+#else
+	return 0;
+#endif
+}
+
+static inline int is_pae(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
+}
+
+static inline int is_pse(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr4_bits(vcpu, X86_CR4_PSE);
+}
+
+static inline int is_paging(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
+}
+
 #endif
-- 
1.6.5.3

