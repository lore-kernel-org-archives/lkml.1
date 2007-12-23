Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXLWO40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXLWO40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXLWOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:35893 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXLWOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Qing He <qing.he@intel.com>
Subject: [PATCH 15/50] KVM: x86_emulator: no writeback for bt
Date: Sun, 23 Dec 2007 16:51:00 +0200
Message-Id: <1198421495-31481-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing He <qing.he@intel.com>

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 8b0186f..fe50317 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1629,6 +1629,7 @@ twobyte_insn:
 		break;
 	case 0xa3:
 	      bt:		/* bt */
+		c->dst.type = OP_NONE;
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
 		emulate_2op_SrcV_nobyte("bt", c->src, c->dst, ctxt->eflags);
-- 
1.5.3.7

