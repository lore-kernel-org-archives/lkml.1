Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYLHLpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYLHLpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYLHLiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbYLHLhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:34 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 01/45] KVM: x86 emulator: consolidate push reg
Date: Mon,  8 Dec 2008 13:36:12 +0200
Message-Id: <1228736216-15787-2-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

This patch consolidate the emulation of push reg instruction.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ea05117..a391e21 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1415,13 +1415,7 @@ special_insn:
 		emulate_1op("dec", c->dst, ctxt->eflags);
 		break;
 	case 0x50 ... 0x57:  /* push reg */
-		c->dst.type  = OP_MEM;
-		c->dst.bytes = c->op_bytes;
-		c->dst.val = c->src.val;
-		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
-					   -c->op_bytes);
-		c->dst.ptr = (void *) register_address(
-			c, ss_base(ctxt), c->regs[VCPU_REGS_RSP]);
+		emulate_push(ctxt);
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
 	pop_instruction:
-- 
1.6.0.3

