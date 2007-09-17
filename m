Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbXIQIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbXIQIx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbXIQIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:45259 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbXIQIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 103/104] KVM: x86 emulator: popf
Date: Mon, 17 Sep 2007 10:32:25 +0200
Message-Id: <11900179492892-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction:
    popf
    opcode:  0x9d

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7360a71..9737c3b 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -127,7 +127,7 @@ static u8 opcode_table[256] = {
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	0, ModRM | DstReg, 0, DstMem | SrcNone | ModRM | Mov,
 	/* 0x90 - 0x9F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, ImplicitOps, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov, DstReg | SrcMem | Mov,
 	ByteOp | DstMem | SrcReg | Mov, DstMem | SrcReg | Mov,
@@ -1293,6 +1293,9 @@ special_insn:
 	case 0x9c: /* pushf */
 		src.val =  (unsigned long) _eflags;
 		goto push;
+	case 0x9d: /* popf */
+		dst.ptr = (unsigned long *) &_eflags;
+		goto pop_instruction;
 	case 0xc3: /* ret */
 		dst.ptr = &_eip;
 		goto pop_instruction;
-- 
1.5.3

