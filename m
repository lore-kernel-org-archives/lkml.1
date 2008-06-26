Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYFZMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYFZMgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYFZM3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:16 -0400
Received: from il.qumranet.com ([212.179.150.194]:32362 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYFZM2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 47/50] KVM: x86 emulator: avoid segment base adjust for lea
Date: Thu, 26 Jun 2008 15:28:29 +0300
Message-Id: <1214483312-9265-48-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 20b6044..38926b7 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -940,7 +940,7 @@ done_prefixes:
 	    c->override_base != &ctxt->gs_base)
 		c->override_base = NULL;
 
-	if (c->override_base)
+	if (c->override_base && !(!c->twobyte && c->b == 0x8d))
 		c->modrm_ea += *c->override_base;
 
 	if (c->ad_bytes != 8)
-- 
1.5.6

