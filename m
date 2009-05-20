Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZETL3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZETL3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbZETLUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55269 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 17/46] KVM: x86 emulator: fix call near emulation
Date: Wed, 20 May 2009 14:18:14 +0300
Message-Id: <1242818323-10413-18-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

The length of pushed on to the stack return address depends on operand
size not address size.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ca91749..d7c9f6f 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1792,7 +1792,6 @@ special_insn:
 		}
 		c->src.val = (unsigned long) c->eip;
 		jmp_rel(c, rel);
-		c->op_bytes = c->ad_bytes;
 		emulate_push(ctxt);
 		break;
 	}
-- 
1.6.0.6

