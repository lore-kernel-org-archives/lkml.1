Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXGaHRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXGaHRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXGaHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:17:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:52481 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXGaHRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:17:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: commit 80917728e43e248155c019f743655806b582b099
Date: Tue, 31 Jul 2007 10:17:20 +0300
Message-Id: <118586624088-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    KVM: x86 emulator: disable writeback for debug register instructions
    
    These are handled internally by the instruction.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1a90ba0..2136da5 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1222,11 +1222,13 @@ twobyte_insn:
 		}
 		break;
 	case 0x21: /* mov from dr to reg */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_get_dr(ctxt, modrm_reg, &_regs[modrm_rm]);
 		break;
 	case 0x23: /* mov from reg to dr */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_set_dr(ctxt, modrm_reg, _regs[modrm_rm]);
