Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbXKHKf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbXKHKf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbXKHKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:52466 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbXKHKfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 4/5] KVM: x86 emulator: invd instruction
Date: Thu,  8 Nov 2007 12:35:29 +0200
Message-Id: <11945181303753-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11945181301744-git-send-email-avi@qumranet.com>
References: <11945181301744-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emulate the 'invd' instruction (opcode 0f 08).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index da0cdd5..33b1814 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -167,7 +167,7 @@ static u8 opcode_table[256] = {
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
-	0, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
@@ -1532,6 +1532,8 @@ twobyte_special_insn:
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
 		break;
+	case 0x08:		/* invd */
+		break;
 	case 0x09:		/* wbinvd */
 		break;
 	case 0x0d:		/* GrpP (prefetch) */
-- 
1.5.3

