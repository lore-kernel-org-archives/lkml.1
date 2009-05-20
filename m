Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZETL2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZETL2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZETLUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 23/46] KVM: x86 emulator: Add lcall decoding
Date: Wed, 20 May 2009 14:18:20 +0300
Message-Id: <1242818323-10413-24-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

No emulation yet.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index c015063..71b4bee 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -154,7 +154,8 @@ static u32 opcode_table[256] = {
 	/* 0x90 - 0x97 */
 	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
 	/* 0x98 - 0x9F */
-	0, 0, 0, 0, ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
+	0, 0, SrcImm | Src2Imm16, 0,
+	ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
 	ByteOp | DstMem | SrcReg | Mov | MemAbs, DstMem | SrcReg | Mov | MemAbs,
-- 
1.6.0.6

