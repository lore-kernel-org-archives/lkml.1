Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYAFOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYAFOrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbYAFOkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:46650 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 22/33] KVM: MMU: Add cache miss statistic
Date: Sun,  6 Jan 2008 16:39:28 +0200
Message-Id: <1199630379-28638-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |    1 +
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9a57e1a..8f12ec5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -715,6 +715,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			pgprintk("%s: found\n", __FUNCTION__);
 			return sp;
 		}
+	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
 		return sp;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 733bff6..fa9e42c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -73,6 +73,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_pde_zapped", VM_STAT(mmu_pde_zapped) },
 	{ "mmu_flooded", VM_STAT(mmu_flooded) },
 	{ "mmu_recycled", VM_STAT(mmu_recycled) },
+	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ NULL }
 };
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 28940e1..ced1beb 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -289,6 +289,7 @@ struct kvm_vm_stat {
 	u32 mmu_pde_zapped;
 	u32 mmu_flooded;
 	u32 mmu_recycled;
+	u32 mmu_cache_miss;
 	u32 remote_tlb_flush;
 };
 
-- 
1.5.3.7

