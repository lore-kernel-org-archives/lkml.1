Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab0BQNuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:50:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933885Ab0BQNpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] KVM: x86 emulator: Add group8 instruction decoding
Date: Wed, 17 Feb 2010 15:45:20 +0200
Message-Id: <1266414330-27444-11-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use groups mechanism to decode 0F BA instructions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 645b245..435b1e4 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -88,6 +88,7 @@
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
+	Group8,
 };
 
 static u32 opcode_table[256] = {
@@ -267,7 +268,7 @@ static u32 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xB8 - 0xBF */
-	0, 0, DstMem | SrcImmByte | ModRM, DstMem | SrcReg | ModRM | BitOp,
+	0, 0, Group | Group8, DstMem | SrcReg | ModRM | BitOp,
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
@@ -323,6 +324,10 @@ static u32 group_table[] = {
 	0, 0, ModRM | SrcMem, ModRM | SrcMem,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
+	[Group8*8] =
+	0, 0, 0, 0,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 };
 
 static u32 group2_table[] = {
-- 
1.6.5.3

