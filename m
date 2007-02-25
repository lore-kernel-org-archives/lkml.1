Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXBYM5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXBYM5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964892AbXBYM5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:57:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:37866 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXBYM5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:57:08 -0500
Subject: [PATCH 3/4] kvm: move do_remove_write_access() up
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 25 Feb 2007 12:57:07 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45E186FE.2000909@qumranet.com>
In-Reply-To: <45E186FE.2000909@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070225125707.27238250196@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To be called from kvm_vm_ioctl_set_memory_region()

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e710810..be7694d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -611,6 +611,13 @@ void fx_init(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(fx_init);
 
+static void do_remove_write_access(struct kvm_vcpu *vcpu, int slot)
+{
+	spin_lock(&vcpu->kvm->lock);
+	kvm_mmu_slot_remove_write_access(vcpu, slot);
+	spin_unlock(&vcpu->kvm->lock);
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -756,13 +763,6 @@ out:
 	return r;
 }
 
-static void do_remove_write_access(struct kvm_vcpu *vcpu, int slot)
-{
-	spin_lock(&vcpu->kvm->lock);
-	kvm_mmu_slot_remove_write_access(vcpu, slot);
-	spin_unlock(&vcpu->kvm->lock);
-}
-
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
