Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXIQInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXIQInh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXIQIcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:45331 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXIQIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:31 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 034/104] KVM: SVM: internal function name cleanup
Date: Mon, 17 Sep 2007 10:31:16 +0200
Message-Id: <1190017947261-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Changes some svm.c internal function names:
1) io_adress -> io_address  (de-germanify the spelling)
2) kvm_reput_irq -> reput_irq  (it's not a generic kvm function)
3) kvm_do_inject_irq -> (it's not a generic kvm function)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 504fb50..cd96673 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1060,7 +1060,7 @@ static int io_get_override(struct vcpu_svm *svm,
 	return 0;
 }
 
-static unsigned long io_adress(struct vcpu_svm *svm, int ins, gva_t *address)
+static unsigned long io_address(struct vcpu_svm *svm, int ins, gva_t *address)
 {
 	unsigned long addr_mask;
 	unsigned long *reg;
@@ -1124,7 +1124,7 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (string) {
 		unsigned addr_mask;
 
-		addr_mask = io_adress(svm, in, &address);
+		addr_mask = io_address(svm, in, &address);
 		if (!addr_mask) {
 			printk(KERN_DEBUG "%s: get io address failed\n",
 			       __FUNCTION__);
@@ -1419,7 +1419,7 @@ static void pre_svm_run(struct vcpu_svm *svm)
 }
 
 
-static inline void kvm_do_inject_irq(struct vcpu_svm *svm)
+static inline void inject_irq(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control;
 
@@ -1430,7 +1430,7 @@ static inline void kvm_do_inject_irq(struct vcpu_svm *svm)
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
 }
 
-static void kvm_reput_irq(struct vcpu_svm *svm)
+static void reput_irq(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
@@ -1456,7 +1456,7 @@ static void do_interrupt_requests(struct vcpu_svm *svm,
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
 		 */
-		kvm_do_inject_irq(svm);
+		inject_irq(svm);
 
 	/*
 	 * Interrupts blocked.  Wait for unblock.
@@ -1698,7 +1698,7 @@ again:
 
 	stgi();
 
-	kvm_reput_irq(svm);
+	reput_irq(svm);
 
 	svm->next_rip = 0;
 
-- 
1.5.3

