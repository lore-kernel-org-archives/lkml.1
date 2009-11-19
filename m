Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZKSNgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZKSNgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZKSNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 23/35] KVM: powerpc: Fix BUILD_BUG_ON condition
Date: Thu, 19 Nov 2009 15:34:59 +0200
Message-Id: <1258637711-11674-24-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

The old BUILD_BUG_ON implementation didn't work with __builtin_constant_p().
Fixing that revealed this test had been inverted for a long time without
anybody noticing...

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/timing.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 806ef67..8167d42 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -51,7 +51,7 @@ static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 
 	/* The BUILD_BUG_ON below breaks in funny ways, commented out
 	 * for now ... -BenH
-	BUILD_BUG_ON(__builtin_constant_p(type));
+	BUILD_BUG_ON(!__builtin_constant_p(type));
 	*/
 	switch (type) {
 	case EXT_INTR_EXITS:
-- 
1.6.5.2

