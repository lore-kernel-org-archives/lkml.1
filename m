Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYLIUYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYLIUYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYLIUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYLIUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 04/44] KVM: ppc: optimize find first bit
Date: Tue,  9 Dec 2008 22:22:19 +0200
Message-Id: <1228854179-23002-5-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Since we use a unsigned long here anyway we can use the optimized __ffs.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b285e3d..0f06471 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -222,7 +222,7 @@ void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 	unsigned int exception;
 	unsigned int priority;
 
-	priority = find_first_bit(pending, BITS_PER_BYTE * sizeof(*pending));
+	priority = __ffs(*pending);
 	while (priority <= BOOKE_MAX_INTERRUPT) {
 		exception = priority_exception[priority];
 		if (kvmppc_can_deliver_interrupt(vcpu, exception)) {
-- 
1.6.0.3

