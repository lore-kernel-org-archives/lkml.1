Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYCaOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYCaOho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYCaOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:30 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51281
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYCaOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/40] KVM: x86 emulator: group decoding for group 1A
Date: Mon, 31 Mar 2008 17:36:48 +0300
Message-Id: <1206974244-9716-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds group decode support for opcode 0x8f.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 46ecf34..cf1ce7c 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -69,6 +69,10 @@
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 
+enum {
+	Group1A,
+};
+
 static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
@@ -133,7 +137,7 @@ static u16 opcode_table[256] = {
 	/* 0x88 - 0x8F */
 	ByteOp | DstMem | SrcReg | ModRM | Mov, DstMem | SrcReg | ModRM | Mov,
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
-	0, ModRM | DstReg, 0, DstMem | SrcNone | ModRM | Mov | Stack,
+	0, ModRM | DstReg, 0, Group | Group1A,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
@@ -233,6 +237,8 @@ static u16 twobyte_table[256] = {
 };
 
 static u16 group_table[] = {
+	[Group1A*8] =
+	DstMem | SrcNone | ModRM | Mov | Stack, 0, 0, 0, 0, 0, 0, 0,
 };
 
 static u16 group2_table[] = {
-- 
1.5.4.5

