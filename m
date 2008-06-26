Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYFZMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYFZMfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYFZM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:00 -0400
Received: from il.qumranet.com ([212.179.150.194]:32362 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYFZM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/50] KVM: x86 emulator: simplify push imm8 emulation
Date: Thu, 26 Jun 2008 15:28:11 +0300
Message-Id: <1214483312-9265-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of fetching the data explicitly, use SrcImmByte.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 2a9db4d..4e037ea 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -121,7 +121,7 @@ static u16 opcode_table[256] = {
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0,
 	/* 0x68 - 0x6F */
-	0, 0, ImplicitOps | Mov | Stack, 0,
+	0, 0, SrcImmByte | Mov | Stack, 0,
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x77 */
@@ -1425,8 +1425,6 @@ special_insn:
 		c->dst.val = (s32) c->src.val;
 		break;
 	case 0x6a: /* push imm8 */
-		c->src.val = 0L;
-		c->src.val = insn_fetch(s8, 1, c->eip);
 		emulate_push(ctxt);
 		break;
 	case 0x6c:		/* insb */
-- 
1.5.6

