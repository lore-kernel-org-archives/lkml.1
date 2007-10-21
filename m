Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXJULIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXJULIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXJULHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:58415 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXJULHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:53 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/11] KVM: x86 emulator: fix merge screwup due to emulator split
Date: Sun, 21 Oct 2007 13:08:02 +0200
Message-Id: <11929648921865-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

This code has gone to wrong place in the file. Moving it back to
right location.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   51 +++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9737c3b..b1026d2 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1083,31 +1083,6 @@ push:
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		src.val = _regs[VCPU_REGS_RCX];
 		goto grp2;
-	case 0xe8: /* call (near) */ {
-		long int rel;
-		switch (op_bytes) {
-		case 2:
-			rel = insn_fetch(s16, 2, _eip);
-			break;
-		case 4:
-			rel = insn_fetch(s32, 4, _eip);
-			break;
-		case 8:
-			rel = insn_fetch(s64, 8, _eip);
-			break;
-		default:
-			DPRINTF("Call: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
-		src.val = (unsigned long) _eip;
-		JMP_REL(rel);
-		goto push;
-	}
-	case 0xe9: /* jmp rel */
-	case 0xeb: /* jmp rel short */
-		JMP_REL(src.val);
-		no_wb = 1; /* Disable writeback. */
-		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
 		switch (modrm_reg) {
 		case 0 ... 1:	/* test */
@@ -1350,6 +1325,32 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xe8: /* call (near) */ {
+		long int rel;
+		switch (op_bytes) {
+		case 2:
+			rel = insn_fetch(s16, 2, _eip);
+			break;
+		case 4:
+			rel = insn_fetch(s32, 4, _eip);
+			break;
+		case 8:
+			rel = insn_fetch(s64, 8, _eip);
+			break;
+		default:
+			DPRINTF("Call: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		src.val = (unsigned long) _eip;
+		JMP_REL(rel);
+		goto push;
+	}
+	case 0xe9: /* jmp rel */
+	case 0xeb: /* jmp rel short */
+		JMP_REL(src.val);
+		no_wb = 1; /* Disable writeback. */
+		break;
+
 
 	}
 	goto writeback;
-- 
1.5.3

