Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYAAPl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYAAPl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYAAPgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:33787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbYAAPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:25 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 17/54] KVM: x86 emulator: unify two switches
Date: Tue,  1 Jan 2008 17:35:43 +0200
Message-Id: <1199201780-14001-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rep prefix cleanup left two switch () statements next to each other.
Unify them.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   50 ++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 53377f0..499d1ad 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1541,31 +1541,6 @@ special_insn:
 	case 0x9d: /* popf */
 		c->dst.ptr = (unsigned long *) &ctxt->eflags;
 		goto pop_instruction;
-	case 0xc3: /* ret */
-		c->dst.ptr = &c->eip;
-		goto pop_instruction;
-	case 0xf4:              /* hlt */
-		ctxt->vcpu->halt_request = 1;
-		goto done;
-	case 0xf5:	/* cmc */
-		/* complement carry flag from eflags reg */
-		ctxt->eflags ^= EFLG_CF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
-		break;
-	case 0xf8: /* clc */
-		ctxt->eflags &= ~EFLG_CF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
-		break;
-	case 0xfa: /* cli */
-		ctxt->eflags &= ~X86_EFLAGS_IF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
-		break;
-	case 0xfb: /* sti */
-		ctxt->eflags |= X86_EFLAGS_IF;
-		c->dst.type = OP_NONE;	/* Disable writeback. */
-		break;
-	}
-	switch (c->b) {
 	case 0xa4 ... 0xa5:	/* movs */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
@@ -1652,6 +1627,9 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xc3: /* ret */
+		c->dst.ptr = &c->eip;
+		goto pop_instruction;
 	case 0xe8: /* call (near) */ {
 		long int rel;
 		switch (c->op_bytes) {
@@ -1676,8 +1654,26 @@ special_insn:
 		JMP_REL(c->src.val);
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
-
-
+	case 0xf4:              /* hlt */
+		ctxt->vcpu->halt_request = 1;
+		goto done;
+	case 0xf5:	/* cmc */
+		/* complement carry flag from eflags reg */
+		ctxt->eflags ^= EFLG_CF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xf8: /* clc */
+		ctxt->eflags &= ~EFLG_CF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xfa: /* cli */
+		ctxt->eflags &= ~X86_EFLAGS_IF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xfb: /* sti */
+		ctxt->eflags |= X86_EFLAGS_IF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
 	}
 	goto writeback;
 
-- 
1.5.3.7

