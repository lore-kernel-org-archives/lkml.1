Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYFZMdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYFZMdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYFZM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:55 -0400
Received: from il.qumranet.com ([212.179.150.194]:32398 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYFZM2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/50] KVM: x86 emulator: implement 'push imm' (opcode 0x68)
Date: Thu, 26 Jun 2008 15:28:12 +0300
Message-Id: <1214483312-9265-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encountered in FC6 boot sequence, now that we don't force ss.rpl = 0 during
the protected mode transition.  Not really necessary, but nice to have.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 4e037ea..b90857c 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -121,7 +121,7 @@ static u16 opcode_table[256] = {
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0,
 	/* 0x68 - 0x6F */
-	0, 0, SrcImmByte | Mov | Stack, 0,
+	SrcImm | Mov | Stack, 0, SrcImmByte | Mov | Stack, 0,
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x77 */
@@ -1424,6 +1424,7 @@ special_insn:
 			goto cannot_emulate;
 		c->dst.val = (s32) c->src.val;
 		break;
+	case 0x68: /* push imm */
 	case 0x6a: /* push imm8 */
 		emulate_push(ctxt);
 		break;
-- 
1.5.6

