Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYFZMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYFZMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYFZM3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:22 -0400
Received: from il.qumranet.com ([212.179.150.194]:32348 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYFZM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/50] KVM: x86 emulator: handle undecoded rex.b with r/m = 5 in certain cases
Date: Thu, 26 Jun 2008 15:28:25 +0300
Message-Id: <1214483312-9265-44-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 does not decode rex.b in certain cases, where the r/m field = 5.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 2808291..3721cfd 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -750,6 +750,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 
 			switch (base_reg) {
 			case 5:
+			case 13:
 				if (c->modrm_mod != 0)
 					c->modrm_ea += c->regs[base_reg];
 				else
@@ -767,6 +768,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			}
 			break;
 		case 5:
+		case 13:
 			if (c->modrm_mod != 0)
 				c->modrm_ea += c->regs[c->modrm_rm];
 			else if (ctxt->mode == X86EMUL_MODE_PROT64)
-- 
1.5.6

