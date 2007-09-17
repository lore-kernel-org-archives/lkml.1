Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXIQIgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXIQIgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXIQIcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 017/104] KVM: x86 emulator: fix faulty check for two-byte opcode
Date: Mon, 17 Sep 2007 10:30:59 +0200
Message-Id: <11900179472650-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, the bug is harmless as we never emulate one-byte 0xb6 or 0xb7.
But things may change.

Noted by the mysterious Gabriel C.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 82b4ea6..ef7518a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -819,7 +819,7 @@ done_prefixes:
 	case DstReg:
 		dst.type = OP_REG;
 		if ((d & ByteOp)
-		    && !(twobyte_table && (b == 0xb6 || b == 0xb7))) {
+		    && !(twobyte && (b == 0xb6 || b == 0xb7))) {
 			dst.ptr = decode_register(modrm_reg, _regs,
 						  (rex_prefix == 0));
 			dst.val = *(u8 *) dst.ptr;
-- 
1.5.3

