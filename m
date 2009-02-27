Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbZB0Kam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbZB0Kam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZB0K13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/37] KVM: ppc: distinguish between interrupts and priorities
Date: Fri, 27 Feb 2009 12:26:33 +0200
Message-Id: <1235730420-7929-11-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Although BOOKE_MAX_INTERRUPT has the right value, the meaning is not match.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |    2 +-
 arch/powerpc/kvm/booke.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 933c406..f192fbe 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -163,7 +163,7 @@ void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 	unsigned int priority;
 
 	priority = __ffs(*pending);
-	while (priority <= BOOKE_MAX_INTERRUPT) {
+	while (priority <= BOOKE_IRQPRIO_MAX) {
 		if (kvmppc_booke_irqprio_deliver(vcpu, priority))
 			break;
 
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 311fdbc..7ceeb3e 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -42,6 +42,7 @@
 #define BOOKE_IRQPRIO_EXTERNAL 13
 #define BOOKE_IRQPRIO_FIT 14
 #define BOOKE_IRQPRIO_DECREMENTER 15
+#define BOOKE_IRQPRIO_MAX 15
 
 /* Helper function for "full" MSR writes. No need to call this if only EE is
  * changing. */
-- 
1.6.0.6

