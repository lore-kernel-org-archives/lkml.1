Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbXLBLTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbXLBLTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXLBLSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:41438 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXLBLSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Amit Shah <amit.shah@qumranet.com>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/10] KVM: x86 emulator: Use emulator_write_emulated and not emulator_write_std
Date: Sun,  2 Dec 2007 13:18:42 +0200
Message-Id: <11965943272386-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

emulator_write_std() is not implemented, and calling write_emulated should
work just as well in place of write_std.

Fixes emulator failures with the push r/m instruction.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 14ad4b4..9fce95b 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1066,7 +1066,7 @@ done_prefixes:
 			}
 			register_address_increment(_regs[VCPU_REGS_RSP],
 						   -dst.bytes);
-			if ((rc = ops->write_std(
+			if ((rc = ops->write_emulated(
 				     register_address(ctxt->ss_base,
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt)) != 0)
-- 
1.5.3

