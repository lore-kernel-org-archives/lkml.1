Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZKPMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZKPMUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZKPMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/42] KVM: x86 emulator: Add missing decoder flags for 'or' instructions
Date: Mon, 16 Nov 2009 14:19:20 +0200
Message-Id: <1258373983-8693-20-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Add missing decoder flags for or instructions (0xc-0xd).

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0644d3d..db0820d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -99,7 +99,8 @@ static u32 opcode_table[256] = {
 	/* 0x08 - 0x0F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, ImplicitOps | Stack | No64, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
+	ImplicitOps | Stack | No64, 0,
 	/* 0x10 - 0x17 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-- 
1.6.5.2

