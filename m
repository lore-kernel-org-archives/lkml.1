Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZB1Brn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZB1Brn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZB1Bmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41792 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/30] KVM: fix sparse warnings: Should it be static?
Date: Sat, 28 Feb 2009 03:41:49 +0200
Message-Id: <1235785309-12835-31-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact: Make symbols static.

Fix this sparse warnings:
  arch/x86/kvm/mmu.c:992:5: warning: symbol 'mmu_pages_add' was not declared. Should it be static?
  arch/x86/kvm/mmu.c:1124:5: warning: symbol 'mmu_pages_next' was not declared. Should it be static?
  arch/x86/kvm/mmu.c:1144:6: warning: symbol 'mmu_pages_clear_parents' was not declared. Should it be static?
  arch/x86/kvm/x86.c:2037:5: warning: symbol 'kvm_read_guest_virt' was not declared. Should it be static?
  arch/x86/kvm/x86.c:2067:5: warning: symbol 'kvm_write_guest_virt' was not declared. Should it be static?
  virt/kvm/irq_comm.c:220:5: warning: symbol 'setup_routing_entry' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c  |   11 ++++++-----
 arch/x86/kvm/x86.c  |    8 ++++----
 virt/kvm/irq_comm.c |    4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4a21b0f..2a36f7f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -989,8 +989,8 @@ struct kvm_mmu_pages {
 	     idx < 512;					\
 	     idx = find_next_bit(bitmap, 512, idx+1))
 
-int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
-		   int idx)
+static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
+			 int idx)
 {
 	int i;
 
@@ -1121,8 +1121,9 @@ struct mmu_page_path {
 			i < pvec.nr && ({ sp = pvec.page[i].sp; 1;});	\
 			i = mmu_pages_next(&pvec, &parents, i))
 
-int mmu_pages_next(struct kvm_mmu_pages *pvec, struct mmu_page_path *parents,
-		   int i)
+static int mmu_pages_next(struct kvm_mmu_pages *pvec,
+			  struct mmu_page_path *parents,
+			  int i)
 {
 	int n;
 
@@ -1141,7 +1142,7 @@ int mmu_pages_next(struct kvm_mmu_pages *pvec, struct mmu_page_path *parents,
 	return n;
 }
 
-void mmu_pages_clear_parents(struct mmu_page_path *parents)
+static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 {
 	struct kvm_mmu_page *sp;
 	unsigned int level = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4db5be..8ca100a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2043,8 +2043,8 @@ static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
 	return dev;
 }
 
-int kvm_read_guest_virt(gva_t addr, void *val, unsigned int bytes,
-			struct kvm_vcpu *vcpu)
+static int kvm_read_guest_virt(gva_t addr, void *val, unsigned int bytes,
+			       struct kvm_vcpu *vcpu)
 {
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
@@ -2073,8 +2073,8 @@ out:
 	return r;
 }
 
-int kvm_write_guest_virt(gva_t addr, void *val, unsigned int bytes,
-			 struct kvm_vcpu *vcpu)
+static int kvm_write_guest_virt(gva_t addr, void *val, unsigned int bytes,
+				struct kvm_vcpu *vcpu)
 {
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a70d805..864ac54 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -233,8 +233,8 @@ void kvm_free_irq_routing(struct kvm *kvm)
 	__kvm_free_irq_routing(&kvm->irq_routing);
 }
 
-int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
-			const struct kvm_irq_routing_entry *ue)
+static int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
+			       const struct kvm_irq_routing_entry *ue)
 {
 	int r = -EINVAL;
 	int delta;
-- 
1.6.0.6

