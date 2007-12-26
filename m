Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXLZLX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXLZLX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXLZLHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:12 -0500
Received: from il.qumranet.com ([82.166.9.18]:50473 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbXLZLGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:09 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 44/55] KVM: add kvm_is_error_hva()
Date: Wed, 26 Dec 2007 13:05:49 +0200
Message-Id: <1198667160-22953-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Check for the "error hva", an address outside the user address space that
signals a bad gfn.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3f5ffc3..6498324 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -520,6 +520,7 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 extern struct page *bad_page;
 
 int is_error_page(struct page *page);
+int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
 			  int user_alloc);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index dacdc66..e3c7f3b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -498,6 +498,17 @@ int is_error_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(is_error_page);
 
+static inline unsigned long bad_hva(void)
+{
+	return PAGE_OFFSET;
+}
+
+int kvm_is_error_hva(unsigned long addr)
+{
+	return addr == bad_hva();
+}
+EXPORT_SYMBOL_GPL(kvm_is_error_hva);
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-- 
1.5.3.7

