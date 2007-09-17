Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXIQIws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXIQIws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbXIQId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbXIQIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 101/104] KVM: x86 emulator: jmp abs
Date: Mon, 17 Sep 2007 10:32:23 +0200
Message-Id: <11900179491113-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction:
    jump absolute r/m
    opcode: 0xff /4

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 4c78a4f..cf8db67 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1148,6 +1148,12 @@ push:
 		case 1:	/* dec */
 			emulate_1op("dec", dst, _eflags);
 			break;
+		case 4: /* jmp abs */
+			if (b == 0xff)
+				_eip = dst.val;
+			else
+				goto cannot_emulate;
+			break;
 		case 6:	/* push */
 			/* 64-bit mode: PUSH always pushes a 64-bit operand. */
 			if (mode == X86EMUL_MODE_PROT64) {
-- 
1.5.3

