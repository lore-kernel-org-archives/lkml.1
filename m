Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbZFIGy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbZFIGy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbZFIGyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:54:16 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:35664 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbZFIGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:54:14 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 08/27] score: create head files fb.h fcntl.h fixmap.h ftrace.h
 futex.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF7A6C7D8F.B4BC990D-ON482575D0.00236CE1-482575D0.0023DDA8@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:27:27 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:27:28,
	Serialize complete at 2009/06/09 ?? 02:27:28
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 248ffc1b9fd814a746009a69bec13cbd28e0f332 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:08 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/fb.h     |   15 +++++++
 arch/score/include/asm/fcntl.h  |    6 +++
 arch/score/include/asm/fixmap.h |   82 
+++++++++++++++++++++++++++++++++++++++
 arch/score/include/asm/ftrace.h |    4 ++
 arch/score/include/asm/futex.h  |    6 +++
 5 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/fb.h
 create mode 100644 arch/score/include/asm/fcntl.h
 create mode 100644 arch/score/include/asm/fixmap.h
 create mode 100644 arch/score/include/asm/ftrace.h
 create mode 100644 arch/score/include/asm/futex.h

diff --git a/arch/score/include/asm/fb.h b/arch/score/include/asm/fb.h
new file mode 100644
index 0000000..6bb525e
--- /dev/null
+++ b/arch/score/include/asm/fb.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_SCORE_FB_H
+#define _ASM_SCORE_FB_H
+
+#include <linux/device.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct 
*vma,
+                               unsigned long off)
+{}
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+       return 0;
+}
+
+#endif /* _ASM_SCORE_FB_H */
diff --git a/arch/score/include/asm/fcntl.h 
b/arch/score/include/asm/fcntl.h
new file mode 100644
index 0000000..03968a3
--- /dev/null
+++ b/arch/score/include/asm/fcntl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_FCNTL_H
+#define _ASM_SCORE_FCNTL_H
+
+#include <asm-generic/fcntl.h>
+
+#endif /* _ASM_SCORE_FCNTL_H */
diff --git a/arch/score/include/asm/fixmap.h 
b/arch/score/include/asm/fixmap.h
new file mode 100644
index 0000000..ee16766
--- /dev/null
+++ b/arch/score/include/asm/fixmap.h
@@ -0,0 +1,82 @@
+#ifndef _ASM_SCORE_FIXMAP_H
+#define _ASM_SCORE_FIXMAP_H
+
+#include <asm/page.h>
+
+#define PHY_RAM_BASE           0x00000000
+#define PHY_IO_BASE            0x10000000
+
+#define VIRTUAL_RAM_BASE       0xa0000000
+#define VIRTUAL_IO_BASE                0xb0000000
+
+#define RAM_SPACE_SIZE         0x10000000
+#define IO_SPACE_SIZE          0x10000000
+
+/* Kernel unmapped, cached 512MB */
+#define KSEG1                  0xa0000000
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special addresses
+ * from the end of virtual memory (0xfffff000) backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * highger than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+
+/*
+ * on UP currently we will have no trace of the fixmap mechanizm,
+ * no page table allocations, etc. This might change in the
+ * future, say framebuffers for the console driver(s) could be
+ * fix-mapped?
+ */
+enum fixed_addresses {
+#define FIX_N_COLOURS 8
+       FIX_CMAP_BEGIN,
+       FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
+       __end_of_fixed_addresses
+};
+
+/*
+ * used by vmalloc.c.
+ *
+ * Leave one empty page between vmalloc'ed areas and
+ * the start of the fixmap, and leave one page empty
+ * at the top of mem..
+ */
+#define FIXADDR_TOP    ((unsigned long)(long)(int)0xfefe0000)
+#define FIXADDR_SIZE   (__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START  (FIXADDR_TOP - FIXADDR_SIZE)
+
+#define __fix_to_virt(x)       (FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)       \
+       ((FIXADDR_TOP - ((x) & PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+       return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+       return __virt_to_fix(vaddr);
+}
+
+#endif /* _ASM_SCORE_FIXMAP_H */
diff --git a/arch/score/include/asm/ftrace.h 
b/arch/score/include/asm/ftrace.h
new file mode 100644
index 0000000..79d6f10
--- /dev/null
+++ b/arch/score/include/asm/ftrace.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_FTRACE_H
+#define _ASM_SCORE_FTRACE_H
+
+#endif /* _ASM_SCORE_FTRACE_H */
diff --git a/arch/score/include/asm/futex.h 
b/arch/score/include/asm/futex.h
new file mode 100644
index 0000000..1dca242
--- /dev/null
+++ b/arch/score/include/asm/futex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_FUTEX_H
+#define _ASM_SCORE_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_SCORE_FUTEX_H */
-- 
1.6.2

