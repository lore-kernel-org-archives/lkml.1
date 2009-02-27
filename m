Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbZB0Kk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbZB0Kk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZB0K2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/37] KVM: ppc: ifdef iccci with CONFIG_44x
Date: Fri, 27 Feb 2009 12:26:30 +0200
Message-Id: <1235730420-7929-8-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

E500 deosn't support this instruction.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke_interrupts.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 084ebcd..4679ec2 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -347,7 +347,9 @@ lightweight_exit:
 	lwz	r3, VCPU_SHADOW_PID(r4)
 	mtspr	SPRN_PID, r3
 
+#ifdef CONFIG_44x
 	iccci	0, 0 /* XXX hack */
+#endif
 
 	/* Load some guest volatiles. */
 	lwz	r0, VCPU_GPR(r0)(r4)
-- 
1.6.0.6

