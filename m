Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZETL0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZETL0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZETLUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55284 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 26/46] KVM: x86 emulator: Complete decoding of call near in decode stage
Date: Wed, 20 May 2009 14:18:23 +0300
Message-Id: <1242818323-10413-27-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 14b8ee2..4a9cd4c 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -192,7 +192,7 @@ static u32 opcode_table[256] = {
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xE8 - 0xEF */
-	ImplicitOps | Stack, SrcImm | ImplicitOps,
+	SrcImm | Stack, SrcImm | ImplicitOps,
 	SrcImm | Src2Imm16, SrcImmByte | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
@@ -1781,18 +1781,7 @@ special_insn:
 		io_dir_in = 0;
 		goto do_io;
 	case 0xe8: /* call (near) */ {
-		long int rel;
-		switch (c->op_bytes) {
-		case 2:
-			rel = insn_fetch(s16, 2, c->eip);
-			break;
-		case 4:
-			rel = insn_fetch(s32, 4, c->eip);
-			break;
-		default:
-			DPRINTF("Call: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
+		long int rel = c->src.val;
 		c->src.val = (unsigned long) c->eip;
 		jmp_rel(c, rel);
 		emulate_push(ctxt);
-- 
1.6.0.6

