Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYLNIKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYLNIKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYLNIH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59909 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/36] KVM: x86 emulator: fix ret emulation
Date: Sun, 14 Dec 2008 10:06:42 +0200
Message-Id: <1229242029-13410-10-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ret' did not set the operand type or size for the destination, so
writeback ignored it.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 702de98..72ae86b 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1650,7 +1650,9 @@ special_insn:
 		emulate_grp2(ctxt);
 		break;
 	case 0xc3: /* ret */
+		c->dst.type = OP_REG;
 		c->dst.ptr = &c->eip;
+		c->dst.bytes = c->op_bytes;
 		goto pop_instruction;
 	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
 	mov:
-- 
1.6.0.3

