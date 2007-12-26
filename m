Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXLZLWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXLZLWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXLZLHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:50471 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXLZLGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:10 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 48/55] KVM: Portability: Move kvm_x86_ops to x86.c
Date: Wed, 26 Dec 2007 13:05:53 +0200
Message-Id: <1198667160-22953-49-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 -
 drivers/kvm/x86.c      |    2 ++
 drivers/kvm/x86.h      |    2 ++
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 31dafa3..7808189 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -55,7 +55,6 @@ static LIST_HEAD(vm_list);
 
 static cpumask_t cpus_hardware_enabled;
 
-struct kvm_x86_ops *kvm_x86_ops;
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 4282a0f..2edc53e 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -44,6 +44,8 @@
 
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
+struct kvm_x86_ops *kvm_x86_ops;
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", STAT_OFFSET(pf_fixed) },
 	{ "pf_guest", STAT_OFFSET(pf_guest) },
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 663b822..ec32c26 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -85,6 +85,8 @@ struct kvm_vcpu {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+extern struct kvm_x86_ops *kvm_x86_ops;
+
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

