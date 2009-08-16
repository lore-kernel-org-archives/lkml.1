Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZHPJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZHPJja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZHPJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/48] KVM: x86 emulator: fix jmp far decoding (opcode 0xea)
Date: Sun, 16 Aug 2009 12:29:27 +0300
Message-Id: <1250415008-17175-8-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jump target should not be sign extened; use an unsigned decode flag.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index a30d5fc..ef4dfca 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -196,7 +196,7 @@ static u32 opcode_table[256] = {
 	ByteOp | SrcImmUByte, SrcImmUByte,
 	/* 0xE8 - 0xEF */
 	SrcImm | Stack, SrcImm | ImplicitOps,
-	SrcImm | Src2Imm16, SrcImmByte | ImplicitOps,
+	SrcImmU | Src2Imm16, SrcImmByte | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
-- 
1.6.3.3

