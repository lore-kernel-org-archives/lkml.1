Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYLNITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYLNITX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYLNIIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59953 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYLNIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:23 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 26/36] KVM: x86 emulator: Extend the opcode descriptor
Date: Sun, 14 Dec 2008 10:06:59 +0200
Message-Id: <1229242029-13410-27-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Extend the opcode descriptor to 32 bits. This is needed by the
introduction of a new Src2 operand type.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 69b330b..7a07ca4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -76,7 +76,7 @@ enum {
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
 };
 
-static u16 opcode_table[256] = {
+static u32 opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -195,7 +195,7 @@ static u16 opcode_table[256] = {
 	ImplicitOps, ImplicitOps, Group | Group4, Group | Group5,
 };
 
-static u16 twobyte_table[256] = {
+static u32 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, Group | GroupDual | Group7, 0, 0, 0, 0, ImplicitOps, 0,
 	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
@@ -253,7 +253,7 @@ static u16 twobyte_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-static u16 group_table[] = {
+static u32 group_table[] = {
 	[Group1_80*8] =
 	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
 	ByteOp | DstMem | SrcImm | ModRM, ByteOp | DstMem | SrcImm | ModRM,
@@ -297,7 +297,7 @@ static u16 group_table[] = {
 	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
 };
 
-static u16 group2_table[] = {
+static u32 group2_table[] = {
 	[Group7*8] =
 	SrcNone | ModRM, 0, 0, 0,
 	SrcNone | ModRM | DstMem | Mov, 0,
-- 
1.6.0.3

