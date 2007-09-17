Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbXIQIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbXIQIwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXIQId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbXIQIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 100/104] KVM: x86 emulator: lea
Date: Mon, 17 Sep 2007 10:32:22 +0200
Message-Id: <11900179491742-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction
    lea r16/r32, m
    opcode:  0x8d:

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 57f1a5a..4c78a4f 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -125,7 +125,7 @@ static u8 opcode_table[256] = {
 	/* 0x88 - 0x8F */
 	ByteOp | DstMem | SrcReg | ModRM | Mov, DstMem | SrcReg | ModRM | Mov,
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
-	0, 0, 0, DstMem | SrcNone | ModRM | Mov,
+	0, ModRM | DstReg, 0, DstMem | SrcNone | ModRM | Mov,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
@@ -1022,6 +1022,9 @@ push:
 		break;
 	case 0x88 ... 0x8b:	/* mov */
 		goto mov;
+	case 0x8d: /* lea r16/r32, m */
+		dst.val = modrm_val;
+		break;
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		/* 64-bit mode: POP always pops a 64-bit operand. */
 		if (mode == X86EMUL_MODE_PROT64)
-- 
1.5.3

