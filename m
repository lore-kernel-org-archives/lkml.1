Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbXIQIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbXIQIhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXIQIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:45296 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH 022/104] KVM: Remove dead code in the cmpxchg instruction emulation
Date: Mon, 17 Sep 2007 10:31:04 +0200
Message-Id: <11900179471824-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

The writeback fixes (02c03a326a5df825cc01de426f72e160db2b9538) let
some dead code in the cmpxchg instruction emulation. Remove it.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index ef7518a..2136da5 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1278,8 +1278,6 @@ twobyte_insn:
 		src.orig_val = src.val;
 		src.val = _regs[VCPU_REGS_RAX];
 		emulate_2op_SrcV("cmp", src, dst, _eflags);
-		/* Always write back. The question is: where to? */
-		d |= Mov;
 		if (_eflags & EFLG_ZF) {
 			/* Success: write back to memory. */
 			dst.val = src.orig_val;
-- 
1.5.3

