Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZETLW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZETLW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZETLTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 22/46] KVM: x86 emulator: Add decoding of 16bit second immediate argument
Date: Wed, 20 May 2009 14:18:19 +0300
Message-Id: <1242818323-10413-23-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Such as segment number in lcall/ljmp

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d7c9f6f..c015063 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -76,6 +76,7 @@
 #define Src2CL      (1<<29)
 #define Src2ImmByte (2<<29)
 #define Src2One     (3<<29)
+#define Src2Imm16   (4<<29)
 #define Src2Mask    (7<<29)
 
 enum {
@@ -1072,6 +1073,12 @@ done_prefixes:
 		c->src2.bytes = 1;
 		c->src2.val = insn_fetch(u8, 1, c->eip);
 		break;
+	case Src2Imm16:
+		c->src2.type = OP_IMM;
+		c->src2.ptr = (unsigned long *)c->eip;
+		c->src2.bytes = 2;
+		c->src2.val = insn_fetch(u16, 2, c->eip);
+		break;
 	case Src2One:
 		c->src2.bytes = 1;
 		c->src2.val = 1;
-- 
1.6.0.6

