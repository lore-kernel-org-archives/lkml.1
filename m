Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbXIQIiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbXIQIiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXIQIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:45323 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXIQIc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:27 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 032/104] KVM: Remove three magic numbers
Date: Mon, 17 Sep 2007 10:31:14 +0200
Message-Id: <11900179471921-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

There are several places where hardcoded numbers are used in place of
the easily-available constant, which is poor form.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/svm.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5b42731..6ad1b04 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -413,7 +413,7 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	for (i = 0; i < 2; ++i)
+	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
 		if (vcpu->pio.guest_pages[i]) {
 			__free_page(vcpu->pio.guest_pages[i]);
 			vcpu->pio.guest_pages[i] = NULL;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 9a840e0..c18f0b2 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -241,7 +241,7 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		printk(KERN_DEBUG "%s: NOP\n", __FUNCTION__);
 		return;
 	}
-	if (svm->next_rip - svm->vmcb->save.rip > 15) {
+	if (svm->next_rip - svm->vmcb->save.rip > MAX_INST_SIZE) {
 		printk(KERN_ERR "%s: ip 0x%llx next 0x%llx\n",
 		       __FUNCTION__,
 		       svm->vmcb->save.rip,
-- 
1.5.3

