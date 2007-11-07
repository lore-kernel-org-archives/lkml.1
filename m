Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbXKGOV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbXKGOV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbXKGOUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:50633 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbXKGOUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:40 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 2/8] KVM: Move #include asm/kvm_para.h outside of __KERNEL__
Date: Wed,  7 Nov 2007 16:21:03 +0200
Message-Id: <11944452692774-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11944452691714-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
Message-Id: <6d486436cf50e269d8914229d10ff60f3d646795.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have some structures defined which are going to be
used by userspace for ioctls.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 include/linux/kvm_para.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index e4db25f..ff6ac27 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -12,12 +12,12 @@
 /* Return values for hypercalls */
 #define KVM_ENOSYS		1000
 
-#ifdef __KERNEL__
 /*
  * hypercalls use architecture specific
  */
 #include <asm/kvm_para.h>
 
+#ifdef __KERNEL__
 static inline int kvm_para_has_feature(unsigned int feature)
 {
 	if (kvm_arch_para_features() & (1UL << feature))
@@ -26,4 +26,3 @@ static inline int kvm_para_has_feature(unsigned int feature)
 }
 #endif /* __KERNEL__ */
 #endif /* __LINUX_KVM_PARA_H */
-
-- 
1.5.3

