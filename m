Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYLHLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYLHLsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYLHLi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48255 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 24/45] KVM: VMX: Move private memory slot position
Date: Mon,  8 Dec 2008 13:36:35 +0200
Message-Id: <1228736216-15787-25-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

PCI device assignment would map guest MMIO spaces as separate slot, so it is
possible that the device has more than 2 MMIO spaces and overwrite current
private memslot.

The patch move private memory slot to the top of userspace visible memory slots.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 arch/x86/kvm/vmx.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index dae134f..7623eb7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2513,7 +2513,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	int ret;
 	struct kvm_userspace_memory_region tss_mem = {
-		.slot = 8,
+		.slot = TSS_PRIVATE_MEMSLOT,
 		.guest_phys_addr = addr,
 		.memory_size = PAGE_SIZE * 3,
 		.flags = 0,
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 18598af..3db236c 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -338,8 +338,9 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
-#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
+#define TSS_PRIVATE_MEMSLOT			(KVM_MEMORY_SLOTS + 0)
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 1)
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 2)
 
 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
-- 
1.6.0.3

