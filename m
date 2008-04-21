Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbYDUKiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbYDUKiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYDUKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:30 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37950
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbYDUKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/31] KVM: x86 emulator: fix lea to really get the effective address
Date: Mon, 21 Apr 2008 13:29:44 +0300
Message-Id: <1208773797-7829-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never hit this, since there is currently no reason to emulate lea.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 46ef78f..2ca0838 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1512,7 +1512,7 @@ special_insn:
 	case 0x88 ... 0x8b:	/* mov */
 		goto mov;
 	case 0x8d: /* lea r16/r32, m */
-		c->dst.val = c->modrm_val;
+		c->dst.val = c->modrm_ea;
 		break;
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		rc = emulate_grp1a(ctxt, ops);
-- 
1.5.5

