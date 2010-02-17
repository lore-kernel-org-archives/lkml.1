Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab0BQNpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934090Ab0BQNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] KVM: x86 emulator: disallow opcode 82 in 64-bit mode
Date: Wed, 17 Feb 2010 15:45:30 +0200
Message-Id: <1266414330-27444-21-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Instructions with opcode 82 are not valid in 64 bit mode.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd1b935..c280c23 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -310,14 +310,14 @@ static u32 group_table[] = {
 	DstMem | SrcImm | ModRM | Lock,
 	DstMem | SrcImm | ModRM,
 	[Group1_82*8] =
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM | Lock,
-	ByteOp | DstMem | SrcImm | ModRM,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64 | Lock,
+	ByteOp | DstMem | SrcImm | ModRM | No64,
 	[Group1_83*8] =
 	DstMem | SrcImmByte | ModRM | Lock,
 	DstMem | SrcImmByte | ModRM | Lock,
-- 
1.6.5.3

