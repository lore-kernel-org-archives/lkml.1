Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYLIUYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYLIUYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYLIUXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbYLIUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 06/44] KVM: ppc: improve trap emulation
Date: Tue,  9 Dec 2008 22:22:21 +0200
Message-Id: <1228854179-23002-7-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

set ESR[PTR] when emulating a guest trap. This allows Linux guests to
properly handle WARN_ON() (i.e. detect that it's a non-fatal trap).

Also remove debugging printk in trap emulation.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/emulate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 814f1e6..4c30fa0 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -74,8 +74,8 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	int advance = 1;
 
 	switch (get_op(inst)) {
-	case 3:                                                 /* trap */
-		printk("trap!\n");
+	case 3:                                             /* trap */
+		vcpu->arch.esr |= ESR_PTR;
 		kvmppc_core_queue_program(vcpu);
 		advance = 0;
 		break;
-- 
1.6.0.3

