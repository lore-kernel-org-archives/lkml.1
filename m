Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbYFZMm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbYFZMm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYFZM3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:32348 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYFZM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 25/50] KVM: x86 emulator: adds support to mov r,imm (opcode 0xb8) instruction
Date: Thu, 26 Jun 2008 15:28:07 +0300
Message-Id: <1214483312-9265-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add support to mov r, imm (0xb8) instruction.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 48b62cc..21d7ff6 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -152,7 +152,8 @@ static u16 opcode_table[256] = {
 	ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
 	ByteOp | ImplicitOps | String, ImplicitOps | String,
 	/* 0xB0 - 0xBF */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	DstReg | SrcImm | Mov, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xC0 - 0xC7 */
 	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
 	0, ImplicitOps | Stack, 0, 0,
@@ -1624,6 +1625,8 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xb8: /* mov r, imm */
+		goto mov;
 	case 0xc0 ... 0xc1:
 		emulate_grp2(ctxt);
 		break;
-- 
1.5.6

