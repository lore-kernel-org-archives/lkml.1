Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbXDZJ1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbXDZJ1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXDZJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:53035 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933781AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/18] KVM: Fold drivers/kvm/kvm_vmx.h into drivers/kvm/vmx.c
Date: Thu, 26 Apr 2007 12:22:11 +0300
Message-Id: <11775793382820-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No meat in that file.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_vmx.h |   14 --------------
 drivers/kvm/vmx.c     |    7 ++++++-
 2 files changed, 6 insertions(+), 15 deletions(-)
 delete mode 100644 drivers/kvm/kvm_vmx.h

diff --git a/drivers/kvm/kvm_vmx.h b/drivers/kvm/kvm_vmx.h
deleted file mode 100644
index d139f73..0000000
--- a/drivers/kvm/kvm_vmx.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef __KVM_VMX_H
-#define __KVM_VMX_H
-
-#ifdef CONFIG_X86_64
-/*
- * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
- * mechanism (cpu bug AA24)
- */
-#define NR_BAD_MSRS 2
-#else
-#define NR_BAD_MSRS 0
-#endif
-
-#endif
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 6270df5..b61d4dd 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -17,7 +17,6 @@
 
 #include "kvm.h"
 #include "vmx.h"
-#include "kvm_vmx.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -81,8 +80,14 @@ static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
 static unsigned msr_offset_kernel_gs_base;
 #define NR_64BIT_MSRS 4
+/*
+ * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
+ * mechanism (cpu bug AA24)
+ */
+#define NR_BAD_MSRS 2
 #else
 #define NR_64BIT_MSRS 0
+#define NR_BAD_MSRS 0
 #endif
 
 static inline int is_page_fault(u32 intr_info)
-- 
1.5.0.6

