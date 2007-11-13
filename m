Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXKMEHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXKMEHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXKMEHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:07:34 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3885 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbXKMEHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:34 -0500
Subject: [PATCH] - drivers/kvm/* - remove ptr comparisons to 0
From: Joe Perches <joe@perches.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 20:06:51 -0800
Message-Id: <1194926811.9407.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fix sparse warnings "Using plain integer as NULL pointer"

Signed-off-by: Joe Perches <joe@perches.com>

---

 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    3 ++-
 drivers/kvm/lapic.c    |    2 +-
 drivers/kvm/svm.c      |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3b0bc4b..f572a81 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -433,7 +433,7 @@ static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
-	return pic_irqchip(kvm) != 0;
+	return pic_irqchip(kvm) != NULL;
 }
 
 struct descriptor_table {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 07ae280..e06beaf 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3535,7 +3535,8 @@ int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size,
-					   __alignof__(struct kvm_vcpu), 0, 0);
+					   __alignof__(struct kvm_vcpu),
+					   0, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_4;
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 238fcad..274b07e 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -771,7 +771,7 @@ void kvm_free_apic(struct kvm_lapic *apic)
 
 	if (apic->regs_page) {
 		__free_page(apic->regs_page);
-		apic->regs_page = 0;
+		apic->regs_page = NULL;
 	}
 
 	kfree(apic);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 729f1cd..6c7c797 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1282,7 +1282,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		       exit_code);
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || svm_exit_handlers[exit_code] == 0) {
+	    || !svm_exit_handlers[exit_code]) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 		kvm_run->hw.hardware_exit_reason = exit_code;
 		return 0;


