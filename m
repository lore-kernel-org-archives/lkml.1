Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbXL3HLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbXL3HLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXL3HKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:59467 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXL3HKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Joe Perches <joe@perches.com>
Subject: [PATCH 01/52] KVM: Remove ptr comparisons to 0
Date: Sun, 30 Dec 2007 09:09:47 +0200
Message-Id: <1198998638-22713-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Fix sparse warnings "Using plain integer as NULL pointer"

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    3 ++-
 drivers/kvm/svm.c      |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e34e246..c4ad66b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -398,7 +398,7 @@ static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
-	return pic_irqchip(kvm) != 0;
+	return pic_irqchip(kvm) != NULL;
 }
 
 struct descriptor_table {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bce4216..7a871e0 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1449,7 +1449,8 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size,
-					   __alignof__(struct kvm_vcpu), 0, 0);
+					   __alignof__(struct kvm_vcpu),
+					   0, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_4;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 0f0958d..762302a 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1271,7 +1271,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		       exit_code);
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || svm_exit_handlers[exit_code] == 0) {
+	    || !svm_exit_handlers[exit_code]) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 		kvm_run->hw.hardware_exit_reason = exit_code;
 		return 0;
-- 
1.5.3.7

