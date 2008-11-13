Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYKMRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYKMRq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYKMRpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbYKMRpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:17 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 06/11] kvm: svm: move some SVM_* #defines to asm/virtext.h
Date: Thu, 13 Nov 2008 15:43:46 -0200
Message-Id: <1226598231-18311-7-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   14 ++++++++++++++
 arch/x86/kvm/svm.h             |   12 +++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 2d090f3..f6adf9d 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -81,4 +81,18 @@ static inline void cpu_emergency_vmxoff(void)
 		__cpu_emergency_vmxoff();
 }
 
+
+/*
+ * SVM functions:
+ */
+
+#define SVM_CPUID_FEATURE_SHIFT 2
+#define SVM_CPUID_FUNC 0x8000000a
+
+#define MSR_EFER_SVME_MASK (1ULL << 12)
+#define MSR_VM_CR       0xc0010114
+#define MSR_VM_HSAVE_PA 0xc0010117ULL
+
+#define SVM_VM_CR_SVM_DISABLE 4
+
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kvm/svm.h b/arch/x86/kvm/svm.h
index 1b8afa7..4649f5c 100644
--- a/arch/x86/kvm/svm.h
+++ b/arch/x86/kvm/svm.h
@@ -1,6 +1,9 @@
 #ifndef __SVM_H
 #define __SVM_H
 
+#include <asm/virtext.h>
+
+
 enum {
 	INTERCEPT_INTR,
 	INTERCEPT_NMI,
@@ -171,15 +174,6 @@ struct __attribute__ ((__packed__)) vmcb {
 	struct vmcb_save_area save;
 };
 
-#define SVM_CPUID_FEATURE_SHIFT 2
-#define SVM_CPUID_FUNC 0x8000000a
-
-#define MSR_EFER_SVME_MASK (1ULL << 12)
-#define MSR_VM_CR       0xc0010114
-#define MSR_VM_HSAVE_PA 0xc0010117ULL
-
-#define SVM_VM_CR_SVM_DISABLE 4
-
 #define SVM_SELECTOR_S_SHIFT 4
 #define SVM_SELECTOR_DPL_SHIFT 5
 #define SVM_SELECTOR_P_SHIFT 7
-- 
1.5.5.GIT

