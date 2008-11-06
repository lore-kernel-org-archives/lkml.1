Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZD3Py5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZD3Py5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbZD3PnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:43:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbZD3PmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:03 -0400
Message-Id: <662fc2e2dc981c53544310df306ae7ed5d1d965e.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Nov 2008 16:10:47 +0100
Subject: [PATCH 09/27] asm-generic: add generic NOMMU versions of some headers
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX18PSwAha5B7eq5NVlNDFa/Sa9VKZ5se5tgb8n5
 NCD09ih6h5/yGNXyN/s14OB5RqMFfNBnVwW4bgnxl93rGiKnkd
 /3Ufb+Pt0TlX7m44haUPQ==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory management in generic is highly architecture specific,
but on NOMMU architectures, it is mostly trivial, so just
add a default implementation in asm-generic that applies
to all NOMMU architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/mmu.h         |   14 +++++++++++
 include/asm-generic/mmu_context.h |   45 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/pgalloc.h     |   12 ++++++++++
 include/asm-generic/segment.h     |    9 +++++++
 include/asm-generic/tlbflush.h    |   18 ++++++++++++++
 5 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/tlbflush.h

diff --git a/include/asm-generic/mmu.h b/include/asm-generic/mmu.h
new file mode 100644
index 0000000..eb34fb0
--- /dev/null
+++ b/include/asm-generic/mmu.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_GENERIC_MMU_H
+#define __ASM_GENERIC_MMU_H
+
+/*
+ * This is the mmu.h header for nommu implementations.
+ * Architectures with an MMU need something more complex.
+ */
+
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* __ASM_GENERIC_MMU_H */
diff --git a/include/asm-generic/mmu_context.h b/include/asm-generic/mmu_context.h
new file mode 100644
index 0000000..a7eec91
--- /dev/null
+++ b/include/asm-generic/mmu_context.h
@@ -0,0 +1,45 @@
+#ifndef __ASM_GENERIC_MMU_CONTEXT_H
+#define __ASM_GENERIC_MMU_CONTEXT_H
+
+/*
+ * Generic hooks for NOMMU architectures, which do not need to do
+ * anything special here.
+ */
+
+#include <asm-generic/mm_hooks.h>
+
+struct task_struct;
+struct mm_struct;
+
+static inline void enter_lazy_tlb(struct mm_struct *mm,
+			struct task_struct *tsk)
+{
+}
+
+static inline int init_new_context(struct task_struct *tsk,
+			struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void destroy_context(struct mm_struct *mm)
+{
+}
+
+static inline void deactivate_mm(struct task_struct *task,
+			struct mm_struct *mm)
+{
+}
+
+static inline void switch_mm(struct mm_struct *prev,
+			struct mm_struct *next,
+			struct task_struct *tsk)
+{
+}
+
+static inline void activate_mm(struct mm_struct *prev_mm,
+			       struct mm_struct *next_mm)
+{
+}
+
+#endif /* __ASM_GENERIC_MMU_CONTEXT_H */
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
new file mode 100644
index 0000000..9e429d0
--- /dev/null
+++ b/include/asm-generic/pgalloc.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_PGALLOC_H
+#define __ASM_GENERIC_PGALLOC_H
+/*
+ * an empty file is enough for a nommu architecture
+ */
+#ifdef CONFIG_MMU
+#error need to implement an architecture specific asm/pgalloc.h
+#endif
+
+#define check_pgt_cache()          do { } while (0)
+
+#endif /* __ASM_GENERIC_PGALLOC_H */
diff --git a/include/asm-generic/segment.h b/include/asm-generic/segment.h
new file mode 100644
index 0000000..5580eac
--- /dev/null
+++ b/include/asm-generic/segment.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_SEGMENT_H
+#define __ASM_GENERIC_SEGMENT_H
+/*
+ * Only here because we have some old header files that expect it...
+ *
+ * New architectures probably don't want to have their own version.
+ */
+
+#endif /* __ASM_GENERIC_SEGMENT_H */
diff --git a/include/asm-generic/tlbflush.h b/include/asm-generic/tlbflush.h
new file mode 100644
index 0000000..c7af037
--- /dev/null
+++ b/include/asm-generic/tlbflush.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_GENERIC_TLBFLUSH_H
+#define __ASM_GENERIC_TLBFLUSH_H
+/*
+ * This is a dummy tlbflush implementation that can be used on all
+ * nommu architectures.
+ * If you have an MMU, you need to write your own functions.
+ */
+#ifdef CONFIG_MMU
+#error need to implement an architecture specific asm/tlbflush.h
+#endif
+
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+	BUG();
+}
+
+
+#endif /* __ASM_GENERIC_TLBFLUSH_H */
-- 
1.5.6.3


