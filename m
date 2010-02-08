Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0BHIGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:06:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:14598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab0BHIGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:06:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,427,1262592000"; 
   d="scan'208";a="490500361"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Keir Fraser <keir.fraser@citrix.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 2/7] xen: Import cpuid.h from Xen
Date: Mon,  8 Feb 2010 16:05:49 +0800
Message-Id: <1265616354-7384-3-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keir Fraser <keir.fraser@citrix.com>

Which would be used by CPUID detection later

Signed-off-by: Keir Fraser <keir.fraser@citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/xen/cpuid.h |   68 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/cpuid.h

diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
new file mode 100644
index 0000000..8787f03
--- /dev/null
+++ b/arch/x86/include/asm/xen/cpuid.h
@@ -0,0 +1,68 @@
+/******************************************************************************
+ * arch/include/asm/xen/cpuid.h
+ *
+ * CPUID interface to Xen.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (c) 2007 Citrix Systems, Inc.
+ *
+ * Authors:
+ *    Keir Fraser <keir.fraser@citrix.com>
+ */
+
+#ifndef __ASM_X86_XEN_CPUID_H__
+#define __ASM_X86_XEN_CPUID_H__
+
+/* Xen identification leaves start at 0x40000000. */
+#define XEN_CPUID_FIRST_LEAF 0x40000000
+#define XEN_CPUID_LEAF(i)    (XEN_CPUID_FIRST_LEAF + (i))
+
+/*
+ * Leaf 1 (0x40000000)
+ * EAX: Largest Xen-information leaf. All leaves up to an including @EAX
+ *      are supported by the Xen host.
+ * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
+ *      of a Xen host.
+ */
+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
+
+/*
+ * Leaf 2 (0x40000001)
+ * EAX[31:16]: Xen major version.
+ * EAX[15: 0]: Xen minor version.
+ * EBX-EDX: Reserved (currently all zeroes).
+ */
+
+/*
+ * Leaf 3 (0x40000002)
+ * EAX: Number of hypercall transfer pages. This register is always guaranteed
+ *      to specify one hypercall page.
+ * EBX: Base address of Xen-specific MSRs.
+ * ECX: Features 1. Unused bits are set to zero.
+ * EDX: Features 2. Unused bits are set to zero.
+ */
+
+/* Does the host support MMU_PT_UPDATE_PRESERVE_AD for this guest? */
+#define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
+#define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
+
+#endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
-- 
1.5.4.5

