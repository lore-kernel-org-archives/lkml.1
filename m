Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXLBLSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXLBLSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXLBLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:41423 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXLBLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/10] KVM: x86 emulator: invd instruction
Date: Sun,  2 Dec 2007 13:18:40 +0200
Message-Id: <1196594327589-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulate the 'invd' instruction (opcode 0f 08).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 08cd4a3..14ad4b4 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -156,7 +156,7 @@ static u8 opcode_table[256] = {
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
-	0, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
@@ -1353,6 +1353,8 @@ twobyte_special_insn:
 	/* Disable writeback. */
 	no_wb = 1;
 	switch (b) {
+	case 0x08:		/* invd */
+		break;
 	case 0x09:		/* wbinvd */
 		break;
 	case 0x0d:		/* GrpP (prefetch) */
-- 
1.5.3

