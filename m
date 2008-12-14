Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYLNIKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYLNIKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYLNIH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59913 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/36] KVM: x86 emulator: allow pop from mmio
Date: Sun, 14 Dec 2008 10:06:40 +0200
Message-Id: <1229242029-13410-8-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 2555762..70242f5 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1063,9 +1063,9 @@ static int emulate_pop(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	rc = ops->read_std(register_address(c, ss_base(ctxt),
-					    c->regs[VCPU_REGS_RSP]),
-			   &c->src.val, c->src.bytes, ctxt->vcpu);
+	rc = ops->read_emulated(register_address(c, ss_base(ctxt),
+						 c->regs[VCPU_REGS_RSP]),
+				&c->src.val, c->src.bytes, ctxt->vcpu);
 	if (rc != 0)
 		return rc;
 
-- 
1.6.0.3

