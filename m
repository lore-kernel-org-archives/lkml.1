Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYCaOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYCaOjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYCaOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:34 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51308
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYCaOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:31 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/40] KVM: x86 emulator: add group 7 decoding
Date: Mon, 31 Mar 2008 17:36:51 +0300
Message-Id: <1206974244-9716-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds group decoding for opcode 0x0f 0x01 (group 7).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7310368..ef6de16 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -70,7 +70,7 @@
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 
 enum {
-	Group1A, Group3_Byte, Group3, Group4, Group5,
+	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
 };
 
 static u16 opcode_table[256] = {
@@ -179,7 +179,7 @@ static u16 opcode_table[256] = {
 
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
-	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
+	0, Group | GroupDual | Group7, 0, 0, 0, 0, ImplicitOps, 0,
 	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
@@ -252,9 +252,14 @@ static u16 group_table[] = {
 	[Group5*8] =
 	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM, 0, 0,
 	SrcMem | ModRM, 0, SrcMem | ModRM | Stack, 0,
+	[Group7*8] =
+	0, 0, ModRM | SrcMem, ModRM | SrcMem,
+	SrcNone | ModRM | DstMem, 0, SrcMem | ModRM, SrcMem | ModRM | ByteOp,
 };
 
 static u16 group2_table[] = {
+	[Group7*8] =
+	SrcNone | ModRM, 0, 0, 0, SrcNone | ModRM | DstMem, 0, SrcMem | ModRM, 0,
 };
 
 /* EFLAGS bit definitions. */
-- 
1.5.4.5

