Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYDUKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYDUKfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbYDUKaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:22 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37946
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbYDUKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:07 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/31] KVM: x86 emulator: initialize src.val and dst.val for register operands
Date: Mon, 21 Apr 2008 13:29:42 +0300
Message-Id: <1208773797-7829-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us treat the case where mod == 3 in the same manner as other cases.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index f59ed93..8e1b32f 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1001,6 +1001,7 @@ done_prefixes:
 		 */
 		if ((c->d & ModRM) && c->modrm_mod == 3) {
 			c->src.type = OP_REG;
+			c->src.val = c->modrm_val;
 			break;
 		}
 		c->src.type = OP_MEM;
@@ -1044,6 +1045,7 @@ done_prefixes:
 	case DstMem:
 		if ((c->d & ModRM) && c->modrm_mod == 3) {
 			c->dst.type = OP_REG;
+			c->dst.val = c->dst.orig_val = c->modrm_val;
 			break;
 		}
 		c->dst.type = OP_MEM;
-- 
1.5.5

