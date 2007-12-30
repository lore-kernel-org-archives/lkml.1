Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXL3HUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXL3HUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXL3HLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:20 -0500
Received: from il.qumranet.com ([82.166.9.18]:59489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbXL3HKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 35/52] KVM: x86 emulator: retire ->write_std()
Date: Sun, 30 Dec 2007 09:10:21 +0200
Message-Id: <1198998638-22713-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theoretically used to acccess memory known to be ordinary RAM, it was
never implemented.  It is questionable whether it is possible to implement
it correctly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c         |   10 ----------
 drivers/kvm/x86_emulate.h |   11 -----------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 6212984..5a54e32 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1162,15 +1162,6 @@ int emulator_read_std(unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(emulator_read_std);
 
-static int emulator_write_std(unsigned long addr,
-			      const void *val,
-			      unsigned int bytes,
-			      struct kvm_vcpu *vcpu)
-{
-	pr_unimpl(vcpu, "emulator_write_std: addr %lx n %d\n", addr, bytes);
-	return X86EMUL_UNHANDLEABLE;
-}
-
 static int emulator_read_emulated(unsigned long addr,
 				  void *val,
 				  unsigned int bytes,
@@ -1367,7 +1358,6 @@ EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
 struct x86_emulate_ops emulate_ops = {
 	.read_std            = emulator_read_std,
-	.write_std           = emulator_write_std,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index e34868b..a62bf14 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -63,17 +63,6 @@ struct x86_emulate_ops {
 			unsigned int bytes, struct kvm_vcpu *vcpu);
 
 	/*
-	 * write_std: Write bytes of standard (non-emulated/special) memory.
-	 *            Used for stack operations, and others.
-	 *  @addr:  [IN ] Linear address to which to write.
-	 *  @val:   [IN ] Value to write to memory (low-order bytes used as
-	 *                required).
-	 *  @bytes: [IN ] Number of bytes to write to memory.
-	 */
-	int (*write_std)(unsigned long addr, const void *val,
-			 unsigned int bytes, struct kvm_vcpu *vcpu);
-
-	/*
 	 * read_emulated: Read bytes from emulated/special memory area.
 	 *  @addr:  [IN ] Linear address from which to read.
 	 *  @val:   [OUT] Value read from memory, zero-extended to 'u_long'.
-- 
1.5.3.7

