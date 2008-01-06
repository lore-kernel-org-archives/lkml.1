Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYAFOli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYAFOli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbYAFOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:46608 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 08/33] KVM: Portability: Move kvm_vcpu_stat to x86.h
Date: Sun,  6 Jan 2008 16:39:14 +0200
Message-Id: <1199630379-28638-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches moves kvm_vcpu_stat to x86.h, so every
arch can define its own kvm_vcpu_stat structure.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   22 ----------------------
 drivers/kvm/x86.h |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 039faa7..9ea7149 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -47,28 +47,6 @@ struct kvm_guest_debug {
 	int singlestep;
 };
 
-struct kvm_vcpu_stat {
-	u32 pf_fixed;
-	u32 pf_guest;
-	u32 tlb_flush;
-	u32 invlpg;
-
-	u32 exits;
-	u32 io_exits;
-	u32 mmio_exits;
-	u32 signal_exits;
-	u32 irq_window_exits;
-	u32 halt_exits;
-	u32 halt_wakeup;
-	u32 request_irq_exits;
-	u32 irq_exits;
-	u32 host_state_reload;
-	u32 efer_reload;
-	u32 fpu_reload;
-	u32 insn_emulation;
-	u32 insn_emulation_fail;
-};
-
 /*
  * It would be nice to use something smarter than a linear search, TBD...
  * Thankfully we dont expect many devices to register (famous last words :),
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index a0dd447..4ca8485 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -255,6 +255,27 @@ struct kvm_vcpu_arch {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+struct kvm_vcpu_stat {
+	u32 pf_fixed;
+	u32 pf_guest;
+	u32 tlb_flush;
+	u32 invlpg;
+
+	u32 exits;
+	u32 io_exits;
+	u32 mmio_exits;
+	u32 signal_exits;
+	u32 irq_window_exits;
+	u32 halt_exits;
+	u32 halt_wakeup;
+	u32 request_irq_exits;
+	u32 irq_exits;
+	u32 host_state_reload;
+	u32 efer_reload;
+	u32 fpu_reload;
+	u32 insn_emulation;
+	u32 insn_emulation_fail;
+};
 
 struct descriptor_table {
 	u16 limit;
-- 
1.5.3.7

