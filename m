Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbYDCTmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbYDCTmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbYDCTd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:28 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53024
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743AbYDCTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/35] KVM: Move some x86 specific constants and structures to include/asm-x86
Date: Thu,  3 Apr 2008 22:32:44 +0300
Message-Id: <1207251170-5013-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_host.h |   13 +++++++++++++
 include/linux/kvm_host.h   |   13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 52e276c..2773f91 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -20,6 +20,13 @@
 
 #include <asm/desc.h>
 
+#define KVM_MAX_VCPUS 16
+#define KVM_MEMORY_SLOTS 32
+/* memory slots that does not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 4
+
+#define KVM_PIO_PAGE_OFFSET 1
+
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
@@ -113,6 +120,12 @@ enum {
 
 #define KVM_NR_MEM_OBJS 40
 
+struct kvm_guest_debug {
+	int enabled;
+	unsigned long bp[4];
+	int singlestep;
+};
+
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 958e003..f4e1436 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -24,13 +24,6 @@
 
 #include <asm/kvm_host.h>
 
-#define KVM_MAX_VCPUS 16
-#define KVM_MEMORY_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
-
-#define KVM_PIO_PAGE_OFFSET 1
-
 /*
  * vcpu->requests bit members
  */
@@ -43,12 +36,6 @@
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
 
-struct kvm_guest_debug {
-	int enabled;
-	unsigned long bp[4];
-	int singlestep;
-};
-
 /*
  * It would be nice to use something smarter than a linear search, TBD...
  * Thankfully we dont expect many devices to register (famous last words :),
-- 
1.5.4.5

