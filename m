Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbXFQJuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbXFQJuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbXFQJoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:55190 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758535AbXFQJoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 16/58] KVM: Set cr0.mp for guests
Date: Sun, 17 Jun 2007 12:43:57 +0300
Message-Id: <11820734802984-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows fwait instructions to be trapped when the guest fpu is not
loaded.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 4724087..5e6dac5 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_para.h>
 
 #define CR0_PE_MASK (1ULL << 0)
+#define CR0_MP_MASK (1ULL << 1)
 #define CR0_TS_MASK (1ULL << 3)
 #define CR0_NE_MASK (1ULL << 5)
 #define CR0_WP_MASK (1ULL << 16)
@@ -42,7 +43,8 @@
 	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK \
 	 | CR0_NW_MASK | CR0_CD_MASK)
 #define KVM_VM_CR0_ALWAYS_ON \
-	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK | CR0_TS_MASK)
+	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK | CR0_TS_MASK \
+	 | CR0_MP_MASK)
 #define KVM_GUEST_CR4_MASK \
 	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
-- 
1.5.0.6

