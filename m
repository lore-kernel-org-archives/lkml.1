Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbYIYMGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbYIYMGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYIYL4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48608 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbYIYL4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 31/39] KVM: x86 emulator: Add mov r, imm instructions (opcodes 0xb0-0xbf)
Date: Thu, 25 Sep 2008 14:55:03 +0300
Message-Id: <1222343711-12508-32-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

The emulator only supported one instance of mov r, imm instruction
(opcode 0xb8), this adds the rest of these instructions.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ae30435..66e0bd6 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -154,9 +154,16 @@ static u16 opcode_table[256] = {
 	0, 0, ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
 	ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
 	ByteOp | ImplicitOps | String, ImplicitOps | String,
-	/* 0xB0 - 0xBF */
-	0, 0, 0, 0, 0, 0, 0, 0,
-	DstReg | SrcImm | Mov, 0, 0, 0, 0, 0, 0, 0,
+	/* 0xB0 - 0xB7 */
+	ByteOp | DstReg | SrcImm | Mov, ByteOp | DstReg | SrcImm | Mov,
+	ByteOp | DstReg | SrcImm | Mov, ByteOp | DstReg | SrcImm | Mov,
+	ByteOp | DstReg | SrcImm | Mov, ByteOp | DstReg | SrcImm | Mov,
+	ByteOp | DstReg | SrcImm | Mov, ByteOp | DstReg | SrcImm | Mov,
+	/* 0xB8 - 0xBF */
+	DstReg | SrcImm | Mov, DstReg | SrcImm | Mov,
+	DstReg | SrcImm | Mov, DstReg | SrcImm | Mov,
+	DstReg | SrcImm | Mov, DstReg | SrcImm | Mov,
+	DstReg | SrcImm | Mov, DstReg | SrcImm | Mov,
 	/* 0xC0 - 0xC7 */
 	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
 	0, ImplicitOps | Stack, 0, 0,
@@ -1660,7 +1667,7 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
-	case 0xb8: /* mov r, imm */
+	case 0xb0 ... 0xbf: /* mov r, imm */
 		goto mov;
 	case 0xc0 ... 0xc1:
 		emulate_grp2(ctxt);
-- 
1.6.0.1

