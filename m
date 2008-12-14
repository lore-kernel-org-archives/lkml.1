Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYLNIMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYLNIMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYLNIHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59914 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/36] KVM: x86 emulator: fix popf emulation
Date: Sun, 14 Dec 2008 10:06:43 +0200
Message-Id: <1229242029-13410-11-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set operand type and size to get correct writeback behavior.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 72ae86b..e8c87cc 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1552,7 +1552,9 @@ special_insn:
 		emulate_push(ctxt);
 		break;
 	case 0x9d: /* popf */
+		c->dst.type = OP_REG;
 		c->dst.ptr = (unsigned long *) &ctxt->eflags;
+		c->dst.bytes = c->op_bytes;
 		goto pop_instruction;
 	case 0xa0 ... 0xa1:	/* mov */
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-- 
1.6.0.3

