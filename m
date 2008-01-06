Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYAFOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYAFOoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbYAFOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:46645 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 13/33] KVM: Portability: Move kvm_vm_stat to x86.h
Date: Sun,  6 Jan 2008 16:39:19 +0200
Message-Id: <1199630379-28638-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patch moves kvm_vm_stat to x86.h, and every arch
can define its own kvm_vm_stat in $arch.h

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   10 ----------
 drivers/kvm/x86.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ab9657a..bf6a3b3 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -103,16 +103,6 @@ struct kvm_memory_slot {
 	int user_alloc;
 };
 
-struct kvm_vm_stat {
-	u32 mmu_shadow_zapped;
-	u32 mmu_pte_write;
-	u32 mmu_pte_updated;
-	u32 mmu_pde_zapped;
-	u32 mmu_flooded;
-	u32 mmu_recycled;
-	u32 remote_tlb_flush;
-};
-
 struct kvm {
 	struct mutex lock; /* protects everything except vcpus */
 	struct mm_struct *mm; /* userspace tied to this vm */
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 9455839..dfb8091 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -283,6 +283,16 @@ struct kvm_arch{
 	struct page *apic_access_page;
 };
 
+struct kvm_vm_stat {
+	u32 mmu_shadow_zapped;
+	u32 mmu_pte_write;
+	u32 mmu_pte_updated;
+	u32 mmu_pde_zapped;
+	u32 mmu_flooded;
+	u32 mmu_recycled;
+	u32 remote_tlb_flush;
+};
+
 struct kvm_vcpu_stat {
 	u32 pf_fixed;
 	u32 pf_guest;
-- 
1.5.3.7

