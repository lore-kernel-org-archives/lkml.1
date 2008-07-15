Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYGOMQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYGOMQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYGOMMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:55 -0400
Received: from il.qumranet.com ([212.179.150.194]:30368 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 13/19] KVM: x86 emulator: Fix HLT instruction
Date: Tue, 15 Jul 2008 15:12:32 +0300
Message-Id: <1216123958-10717-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This patch fixes issue encountered with HLT instruction
under FreeDOS's HIMEM XMS Driver.

The HLT instruction jumped directly to the done label and
skips updating the EIP value, therefore causing the guest
to spin endlessly on the same instruction.

The patch changes the instruction so that it writes back
the updated EIP value.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 18ca25c..8bc63f6 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1731,7 +1731,7 @@ special_insn:
 		break;
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->arch.halt_request = 1;
-		goto done;
+		break;
 	case 0xf5:	/* cmc */
 		/* complement carry flag from eflags reg */
 		ctxt->eflags ^= EFLG_CF;
-- 
1.5.6.1

