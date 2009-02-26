Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbZBZOYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbZBZOYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbZBZOQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/40] KVM: Move struct kvm_pio_request into x86 kvm_host.h
Date: Thu, 26 Feb 2009 16:15:25 +0200
Message-Id: <1235657730-27683-36-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an x86 specific stucture and has no business living in common code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   12 ++++++++++++
 include/linux/kvm_types.h       |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b74576a..863ea73 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -227,6 +227,18 @@ struct kvm_pv_mmu_op_buffer {
 	char buf[512] __aligned(sizeof(long));
 };
 
+struct kvm_pio_request {
+	unsigned long count;
+	int cur_count;
+	gva_t guest_gva;
+	int in;
+	int port;
+	int size;
+	int string;
+	int down;
+	int rep;
+};
+
 /*
  * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
  * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 5f4a18c..2b8318c 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -40,16 +40,4 @@ typedef unsigned long  hfn_t;
 
 typedef hfn_t pfn_t;
 
-struct kvm_pio_request {
-	unsigned long count;
-	int cur_count;
-	gva_t guest_gva;
-	int in;
-	int port;
-	int size;
-	int string;
-	int down;
-	int rep;
-};
-
 #endif /* __KVM_TYPES_H__ */
-- 
1.6.0.6

