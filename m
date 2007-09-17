Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXIQI7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXIQI7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbXIQIdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 062/104] KVM: X86 emulator: fix 'push reg' writeback
Date: Mon, 17 Sep 2007 10:31:44 +0200
Message-Id: <11900179484159-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by Rusty Russell.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index cf895aa..7439b34 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1163,7 +1163,6 @@ special_insn:
 		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
 		dst.ptr = (void *) register_address(
 			ctxt->ss_base, _regs[VCPU_REGS_RSP]);
-		no_wb = 1; /* force writeback */
 		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
-- 
1.5.3

