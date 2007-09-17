Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXIQIel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXIQIel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXIQIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 007/104] KVM: Trivial: Make decode_register() static
Date: Mon, 17 Sep 2007 10:30:49 +0200
Message-Id: <11900179463013-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

I have shied away from touching x86_emulate.c (it could definitely use
some love, but it is forked from the Xen code, and it would be more
productive to cross-merge fixes).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    9 +++++++--
 drivers/kvm/x86_emulate.h |    8 --------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 4b8a0cc..f5e4644 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -443,8 +443,13 @@ struct operand {
 			   (((reg) + _inc) & ((1UL << (ad_bytes << 3)) - 1)); \
 	} while (0)
 
-void *decode_register(u8 modrm_reg, unsigned long *regs,
-		      int highbyte_regs)
+/*
+ * Given the 'reg' portion of a ModRM byte, and a register block, return a
+ * pointer into the block that addresses the relevant register.
+ * @highbyte_regs specifies whether to decode AH,CH,DH,BH.
+ */
+static void *decode_register(u8 modrm_reg, unsigned long *regs,
+			     int highbyte_regs)
 {
 	void *p;
 
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 2847d67..574cca7 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -152,12 +152,4 @@ struct x86_emulate_ctxt {
 int x86_emulate_memop(struct x86_emulate_ctxt *ctxt,
 		      struct x86_emulate_ops *ops);
 
-/*
- * Given the 'reg' portion of a ModRM byte, and a register block, return a
- * pointer into the block that addresses the relevant register.
- * @highbyte_regs specifies whether to decode AH,CH,DH,BH.
- */
-void *decode_register(u8 modrm_reg, unsigned long *regs,
-		      int highbyte_regs);
-
 #endif				/* __X86_EMULATE_H__ */
-- 
1.5.3

