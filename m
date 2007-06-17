Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXFQJxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXFQJxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbXFQJpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:55152 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759015AbXFQJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 29/58] KVM: x86 emulator: implement wbinvd
Date: Sun, 17 Jun 2007 12:44:10 +0300
Message-Id: <11820734801188-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vista seems to trigger it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7ade090..6123c02 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -152,7 +152,7 @@ static u8 opcode_table[256] = {
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
-	0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	0, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
@@ -1304,6 +1304,8 @@ twobyte_special_insn:
 	/* Disable writeback. */
 	dst.orig_val = dst.val;
 	switch (b) {
+	case 0x09:		/* wbinvd */
+		break;
 	case 0x0d:		/* GrpP (prefetch) */
 	case 0x18:		/* Grp16 (prefetch/nop) */
 		break;
-- 
1.5.0.6

