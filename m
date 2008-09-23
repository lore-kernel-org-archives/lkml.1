Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYIWNxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYIWNxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYIWNrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52375 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYIWNrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:23 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH 15/40] KVM: Consolidate XX_VECTOR defines
Date: Tue, 23 Sep 2008 16:46:29 +0300
Message-Id: <1222177614-26669-16-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |    4 ----
 arch/x86/kvm/vmx.c         |    2 +-
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 54b0bf3..743c98d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -36,10 +36,6 @@ MODULE_LICENSE("GPL");
 #define IOPM_ALLOC_ORDER 2
 #define MSRPM_ALLOC_ORDER 1
 
-#define DB_VECTOR 1
-#define UD_VECTOR 6
-#define GP_VECTOR 13
-
 #define DR7_GD_MASK (1 << 13)
 #define DR6_BD_MASK (1 << 13)
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9591ca7..5c9dac5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -470,7 +470,7 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug.enabled)
-		eb |= 1u << 1;
+		eb |= 1u << DB_VECTOR;
 	if (vcpu->arch.rmode.active)
 		eb = ~0;
 	if (vm_need_ept())
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index af1c0f7..2446893 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -57,6 +57,7 @@
 #define KVM_PAGES_PER_HPAGE (KVM_HPAGE_SIZE / PAGE_SIZE)
 
 #define DE_VECTOR 0
+#define DB_VECTOR 1
 #define UD_VECTOR 6
 #define NM_VECTOR 7
 #define DF_VECTOR 8
-- 
1.6.0.1

