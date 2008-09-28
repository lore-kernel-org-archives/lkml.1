Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYI1Pvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYI1Pvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYI1PqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:46:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50911 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYI1PqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:46:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 17/25] KVM: x86 emulator: Add cmp al, imm and cmp ax, imm instructions (ocodes 3c, 3d)
Date: Sun, 28 Sep 2008 18:44:53 +0300
Message-Id: <1222616701-1206-18-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add decode entries for these opcodes; execution is already implemented.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 4390ec8..2b43208 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -108,7 +108,8 @@ static u16 opcode_table[256] = {
 	/* 0x38 - 0x3F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
+	0, 0,
 	/* 0x40 - 0x47 */
 	DstReg, DstReg, DstReg, DstReg, DstReg, DstReg, DstReg, DstReg,
 	/* 0x48 - 0x4F */
-- 
1.6.0.1

