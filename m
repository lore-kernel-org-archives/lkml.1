Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYIYMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYIYMFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbYIYL4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48577 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbYIYLz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:58 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 22/39] KVM: MMU: Move SHADOW_PT_INDEX to mmu.c
Date: Thu, 25 Sep 2008 14:54:54 +0300
Message-Id: <1222343711-12508-23-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

It is not specific to the paging mode, so can be made global (and reusable).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |    2 ++
 arch/x86/kvm/paging_tmpl.h |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 171bcea..51d4cd7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -135,6 +135,8 @@ module_param(dbg, bool, 0644);
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+
 struct kvm_rmap_desc {
 	u64 *shadow_ptes[RMAP_EXT];
 	struct kvm_rmap_desc *more;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 4a814bf..ebb26a0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -29,7 +29,6 @@
 	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT64_DIR_BASE_ADDR_MASK
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT64_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#ifdef CONFIG_X86_64
@@ -46,7 +45,6 @@
 	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT32_DIR_BASE_ADDR_MASK
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
-	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
@@ -504,7 +502,6 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 #undef FNAME
 #undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
-#undef SHADOW_PT_INDEX
 #undef PT_LEVEL_MASK
 #undef PT_DIR_BASE_ADDR_MASK
 #undef PT_LEVEL_BITS
-- 
1.6.0.1

