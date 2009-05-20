Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZETL1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZETL1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZETLUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 28/46] KVM: x86 emulator: Completely decode in/out at decoding stage
Date: Wed, 20 May 2009 14:18:25 +0300
Message-Id: <1242818323-10413-29-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 0988a13..c2f55ca 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -190,8 +190,8 @@ static u32 opcode_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xE7 */
 	0, 0, 0, 0,
-	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
-	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
+	ByteOp | SrcImmUByte, SrcImmUByte,
+	ByteOp | SrcImmUByte, SrcImmUByte,
 	/* 0xE8 - 0xEF */
 	SrcImm | Stack, SrcImm | ImplicitOps,
 	SrcImm | Src2Imm16, SrcImmByte | ImplicitOps,
@@ -1777,12 +1777,12 @@ special_insn:
 		break;
 	case 0xe4: 	/* inb */
 	case 0xe5: 	/* in */
-		port = insn_fetch(u8, 1, c->eip);
+		port = c->src.val;
 		io_dir_in = 1;
 		goto do_io;
 	case 0xe6: /* outb */
 	case 0xe7: /* out */
-		port = insn_fetch(u8, 1, c->eip);
+		port = c->src.val;
 		io_dir_in = 0;
 		goto do_io;
 	case 0xe8: /* call (near) */ {
-- 
1.6.0.6

