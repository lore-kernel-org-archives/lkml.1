Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbYFZMnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbYFZMnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYFZM3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:44 -0400
Received: from il.qumranet.com ([212.179.150.194]:32349 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 23/50] KVM: x86 emulator: Update c->dst.bytes in decode instruction
Date: Thu, 26 Jun 2008 15:28:05 +0300
Message-Id: <1214483312-9265-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Update c->dst.bytes in decode instruction instead of instruction
itself.  It's needed because if c->dst.bytes is equal to 0, the
instruction is not emulated.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 932f216..a928aa6 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1049,6 +1049,7 @@ done_prefixes:
 		break;
 	case DstMem:
 		if ((c->d & ModRM) && c->modrm_mod == 3) {
+			c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 			c->dst.type = OP_REG;
 			c->dst.val = c->dst.orig_val = c->modrm_val;
 			c->dst.ptr = c->modrm_ptr;
-- 
1.5.6

