Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYCaOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYCaOlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYCaOhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:38 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51312
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYCaOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/40] KVM: x86 emulator: group decoding for group 1 instructions
Date: Mon, 31 Mar 2008 17:36:54 +0300
Message-Id: <1206974244-9716-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opcodes 0x80-0x83

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ef6de16..22900f7 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -70,6 +70,7 @@
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 
 enum {
+	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
 };
 
@@ -130,8 +131,8 @@ static u16 opcode_table[256] = {
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x80 - 0x87 */
-	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
-	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
+	Group | Group1_80, Group | Group1_81,
+	Group | Group1_82, Group | Group1_83,
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	/* 0x88 - 0x8F */
@@ -236,6 +237,26 @@ static u16 twobyte_table[256] = {
 };
 
 static u16 group_table[] = {
+	[Group1_80*8] =
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	[Group1_81*8] =
+	DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
+	DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
+	DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
+	DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
+	[Group1_82*8] =
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
+	[Group1_83*8] =
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 	[Group1A*8] =
 	DstMem | SrcNone | ModRM | Mov | Stack, 0, 0, 0, 0, 0, 0, 0,
 	[Group3_Byte*8] =
-- 
1.5.4.5

