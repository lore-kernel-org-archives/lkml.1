Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYLNITm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYLNITm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYLNIIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59955 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYLNIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:23 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 28/36] KVM: x86 emulator: add a new "implied 1" Src decode type
Date: Sun, 14 Dec 2008 10:07:01 +0200
Message-Id: <1229242029-13410-29-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add SrcOne operand type when we need to decode an implied '1' like with
regular shift instruction

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7f5cd62..0c75306 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -58,6 +58,7 @@
 #define SrcMem32    (4<<4)	/* Memory operand (32-bit). */
 #define SrcImm      (5<<4)	/* Immediate operand. */
 #define SrcImmByte  (6<<4)	/* 8-bit sign-extended immediate operand. */
+#define SrcOne      (7<<4)	/* Implied '1' */
 #define SrcMask     (7<<4)
 /* Generic ModRM decode. */
 #define ModRM       (1<<7)
@@ -1004,6 +1005,10 @@ done_prefixes:
 		c->src.bytes = 1;
 		c->src.val = insn_fetch(s8, 1, c->eip);
 		break;
+	case SrcOne:
+		c->src.bytes = 1;
+		c->src.val = 1;
+		break;
 	}
 
 	/*
-- 
1.6.0.3

