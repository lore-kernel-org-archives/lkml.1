Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab0BQNu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:50:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779Ab0BQNpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] KVM: x86 emulator: Add group9 instruction decoding
Date: Wed, 17 Feb 2010 15:45:21 +0200
Message-Id: <1266414330-27444-12-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use groups mechanism to decode 0F C7 instructions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 435b1e4..45a4f7c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -88,7 +88,7 @@
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
-	Group8,
+	Group8, Group9,
 };
 
 static u32 opcode_table[256] = {
@@ -272,7 +272,8 @@ static u32 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov,
+	0, 0, 0, Group | GroupDual | Group9,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -328,6 +329,8 @@ static u32 group_table[] = {
 	0, 0, 0, 0,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	[Group9*8] =
+	0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0,
 };
 
 static u32 group2_table[] = {
@@ -335,6 +338,8 @@ static u32 group2_table[] = {
 	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
+	[Group9*8] =
+	0, 0, 0, 0, 0, 0, 0, 0,
 };
 
 /* EFLAGS bit definitions. */
-- 
1.6.5.3

