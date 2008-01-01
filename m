Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYAAPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYAAPoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYAAPgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:33803 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 26/54] KVM: Portability: Move address types to their own header file
Date: Tue,  1 Jan 2008 17:35:52 +0200
Message-Id: <1199201780-14001-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h   |   21 ++-------------------
 drivers/kvm/types.h |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 19 deletions(-)
 create mode 100644 drivers/kvm/types.h

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index be18620..3b0ba5a 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -20,6 +20,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
+#include "types.h"
+
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
@@ -39,25 +41,6 @@
  */
 #define KVM_REQ_TLB_FLUSH          0
 
-/*
- * Address types:
- *
- *  gva - guest virtual address
- *  gpa - guest physical address
- *  gfn - guest frame number
- *  hva - host virtual address
- *  hpa - host physical address
- *  hfn - host frame number
- */
-
-typedef unsigned long  gva_t;
-typedef u64            gpa_t;
-typedef unsigned long  gfn_t;
-
-typedef unsigned long  hva_t;
-typedef u64            hpa_t;
-typedef unsigned long  hfn_t;
-
 #define NR_PTE_CHAIN_ENTRIES 5
 
 struct kvm_pte_chain {
diff --git a/drivers/kvm/types.h b/drivers/kvm/types.h
new file mode 100644
index 0000000..6ad7623
--- /dev/null
+++ b/drivers/kvm/types.h
@@ -0,0 +1,41 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ */
+
+#ifndef __KVM_TYPES_H__
+#define __KVM_TYPES_H__
+
+#include <asm/types.h>
+
+/*
+ * Address types:
+ *
+ *  gva - guest virtual address
+ *  gpa - guest physical address
+ *  gfn - guest frame number
+ *  hva - host virtual address
+ *  hpa - host physical address
+ *  hfn - host frame number
+ */
+
+typedef unsigned long  gva_t;
+typedef u64            gpa_t;
+typedef unsigned long  gfn_t;
+
+typedef unsigned long  hva_t;
+typedef u64            hpa_t;
+typedef unsigned long  hfn_t;
+
+#endif /* __KVM_TYPES_H__ */
-- 
1.5.3.7

