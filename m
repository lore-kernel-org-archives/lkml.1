Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZHZKbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZHZKbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbZHZKbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/47] KVM: x86 emulator: Add adc and sbb missing decoder flags
Date: Wed, 26 Aug 2009 13:30:05 +0300
Message-Id: <1251282609-12835-44-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Add missing decoder flags for adc and sbb instructions
(opcodes 0x14-0x15, 0x1c-0x1d)

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2eb807a..1be5cd6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -100,11 +100,11 @@ static u32 opcode_table[256] = {
 	/* 0x10 - 0x17 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
 	/* 0x18 - 0x1F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
 	/* 0x20 - 0x27 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-- 
1.6.4.1

