Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYI1Pp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYI1Pp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYI1PpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYI1PpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 01/25] KVM: x86 emulator: Add std and cld instructions (opcodes 0xfc-0xfd)
Date: Sun, 28 Sep 2008 18:44:37 +0300
Message-Id: <1222616701-1206-2-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This adds the std and cld instructions to the emulator.

Encountered while running the BIOS with invalid guest
state emulation enabled.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 66e0bd6..944f1f4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -187,7 +187,7 @@ static u16 opcode_table[256] = {
 	ImplicitOps, ImplicitOps, Group | Group3_Byte, Group | Group3,
 	/* 0xF8 - 0xFF */
 	ImplicitOps, 0, ImplicitOps, ImplicitOps,
-	0, 0, Group | Group4, Group | Group5,
+	ImplicitOps, ImplicitOps, Group | Group4, Group | Group5,
 };
 
 static u16 twobyte_table[256] = {
@@ -1762,6 +1762,14 @@ special_insn:
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
+	case 0xfc: /* cld */
+		ctxt->eflags &= ~EFLG_DF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xfd: /* std */
+		ctxt->eflags |= EFLG_DF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
 	case 0xfe ... 0xff:	/* Grp4/Grp5 */
 		rc = emulate_grp45(ctxt, ops);
 		if (rc != 0)
-- 
1.6.0.1

