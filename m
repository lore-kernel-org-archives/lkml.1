Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXIQIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXIQIny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXIQIc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:45297 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbXIQIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:31 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 058/104] KVM: x86 emulator: Implement 'jmp rel short' instruction (opcode 0xeb)
Date: Mon, 17 Sep 2007 10:31:40 +0200
Message-Id: <11900179482556-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index fa7aa27..1036e02 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -148,7 +148,7 @@ static u8 opcode_table[256] = {
 	/* 0xE0 - 0xE7 */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE8 - 0xEF */
-	0, SrcImm|ImplicitOps, 0, 0, 0, 0, 0, 0,
+	0, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps, 0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
 	ImplicitOps, 0,
@@ -1032,6 +1032,7 @@ done_prefixes:
 		src.val = _regs[VCPU_REGS_RCX];
 		goto grp2;
 	case 0xe9: /* jmp rel */
+	case 0xeb: /* jmp rel short */
 		JMP_REL(src.val);
 		no_wb = 1; /* Disable writeback. */
 		break;
-- 
1.5.3

