Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbXDZJYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbXDZJYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXDZJYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:24:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:53037 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Yaozu Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 13/18] KVM: MMU: Avoid heavy ASSERT at non debug mode.
Date: Thu, 26 Apr 2007 12:22:13 +0300
Message-Id: <1177579338431-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yaozu Dong <eddie.dong@intel.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index c814394..8ccf84e 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -52,11 +52,15 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
 static int dbg = 1;
 #endif
 
+#ifndef MMU_DEBUG
+#define ASSERT(x) do { } while (0)
+#else
 #define ASSERT(x)							\
 	if (!(x)) {							\
 		printk(KERN_WARNING "assertion failed %s:%d: %s\n",	\
 		       __FILE__, __LINE__, #x);				\
 	}
+#endif
 
 #define PT64_PT_BITS 9
 #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
@@ -434,6 +438,7 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	}
 }
 
+#ifdef MMU_DEBUG
 static int is_empty_shadow_page(hpa_t page_hpa)
 {
 	u64 *pos;
@@ -448,6 +453,7 @@ static int is_empty_shadow_page(hpa_t page_hpa)
 		}
 	return 1;
 }
+#endif
 
 static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
 {
-- 
1.5.0.6

