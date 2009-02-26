Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbZBZO1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbZBZO1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbZBZORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbZBZOPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:45 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 36/40] KVM: ppc: move struct kvmppc_44x_tlbe into 44x-specific header
Date: Thu, 26 Feb 2009 16:15:26 +0200
Message-Id: <1235657730-27683-37-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_44x.h  |    7 +++++++
 arch/powerpc/include/asm/kvm_host.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_44x.h b/arch/powerpc/include/asm/kvm_44x.h
index f49031b..d22d399 100644
--- a/arch/powerpc/include/asm/kvm_44x.h
+++ b/arch/powerpc/include/asm/kvm_44x.h
@@ -28,6 +28,13 @@
  * need to find some way of advertising it. */
 #define KVM44x_GUEST_TLB_SIZE 64
 
+struct kvmppc_44x_tlbe {
+	u32 tid; /* Only the low 8 bits are used. */
+	u32 word0;
+	u32 word1;
+	u32 word2;
+};
+
 struct kvmppc_44x_shadow_ref {
 	struct page *page;
 	u16 gtlb_index;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index a226005..65c4d49 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -64,13 +64,6 @@ struct kvm_vcpu_stat {
 	u32 halt_wakeup;
 };
 
-struct kvmppc_44x_tlbe {
-	u32 tid; /* Only the low 8 bits are used. */
-	u32 word0;
-	u32 word1;
-	u32 word2;
-};
-
 enum kvm_exit_types {
 	MMIO_EXITS,
 	DCR_EXITS,
-- 
1.6.0.6

