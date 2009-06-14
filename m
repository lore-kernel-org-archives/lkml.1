Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZFNMDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZFNMDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbZFNMBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52665 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbZFNMBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 09/17] Blackfin: convert simple headers to asm-generic
Date: Sun, 14 Jun 2009 08:01:10 -0400
Message-Id: <1244980878-2124-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/auxvec.h            |    5 +----
 arch/blackfin/include/asm/bugs.h              |   17 +----------------
 arch/blackfin/include/asm/cputime.h           |    5 -----
 arch/blackfin/include/asm/current.h           |   24 +-----------------------
 arch/blackfin/include/asm/device.h            |    6 ------
 arch/blackfin/include/asm/emergency-restart.h |    5 -----
 arch/blackfin/include/asm/errno.h             |    7 +------
 arch/blackfin/include/asm/fb.h                |   13 +------------
 arch/blackfin/include/asm/futex.h             |    5 -----
 arch/blackfin/include/asm/hw_irq.h            |    7 +------
 arch/blackfin/include/asm/kmap_types.h        |   22 +---------------------
 arch/blackfin/include/asm/local.h             |    5 -----
 arch/blackfin/include/asm/param.h             |   23 +----------------------
 arch/blackfin/include/asm/percpu.h            |    5 -----
 arch/blackfin/include/asm/pgalloc.h           |    9 +--------
 arch/blackfin/include/asm/resource.h          |    5 -----
 arch/blackfin/include/asm/serial.h            |    6 +-----
 arch/blackfin/include/asm/setup.h             |   18 +-----------------
 arch/blackfin/include/asm/statfs.h            |    5 -----
 arch/blackfin/include/asm/topology.h          |    5 -----
 20 files changed, 11 insertions(+), 186 deletions(-)

diff --git a/arch/blackfin/include/asm/auxvec.h b/arch/blackfin/include/asm/auxvec.h
index 215506c..41fa68b 100644
--- a/arch/blackfin/include/asm/auxvec.h
+++ b/arch/blackfin/include/asm/auxvec.h
@@ -1,4 +1 @@
-#ifndef __ASMBFIN_AUXVEC_H
-#define __ASMBFIN_AUXVEC_H
-
-#endif
+#include <asm-generic/auxvec.h>
diff --git a/arch/blackfin/include/asm/bugs.h b/arch/blackfin/include/asm/bugs.h
index 9093c9c..61791e1 100644
--- a/arch/blackfin/include/asm/bugs.h
+++ b/arch/blackfin/include/asm/bugs.h
@@ -1,16 +1 @@
-/*
- *  include/asm-blackfin/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- */
-
-/*
- * This is included by init/main.c to check for architecture-dependent bugs.
- *
- * Needs:
- *	void check_bugs(void);
- */
-
-static void check_bugs(void)
-{
-}
+#include <asm-generic/bugs.h>
diff --git a/arch/blackfin/include/asm/cputime.h b/arch/blackfin/include/asm/cputime.h
index 2b19705..6d68ad7 100644
--- a/arch/blackfin/include/asm/cputime.h
+++ b/arch/blackfin/include/asm/cputime.h
@@ -1,6 +1 @@
-#ifndef __BLACKFIN_CPUTIME_H
-#define __BLACKFIN_CPUTIME_H
-
 #include <asm-generic/cputime.h>
-
-#endif				/* __BLACKFIN_CPUTIME_H */
diff --git a/arch/blackfin/include/asm/current.h b/arch/blackfin/include/asm/current.h
index 31918d2..4c51401 100644
--- a/arch/blackfin/include/asm/current.h
+++ b/arch/blackfin/include/asm/current.h
@@ -1,23 +1 @@
-#ifndef _BLACKFIN_CURRENT_H
-#define _BLACKFIN_CURRENT_H
-/*
- *	current.h
- *	(C) Copyright 2000, Lineo, David McCullough <davidm@lineo.com>
- *
- *	rather than dedicate a register (as the m68k source does), we
- *	just keep a global,  we should probably just change it all to be
- *	current and lose _current_task.
- */
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct *get_current(void) __attribute__ ((__const__));
-static inline struct task_struct *get_current(void)
-{
-	return (current_thread_info()->task);
-}
-
-#define	current	(get_current())
-
-#endif				/* _BLACKFIN_CURRENT_H */
+#include <asm-generic/current.h>
diff --git a/arch/blackfin/include/asm/device.h b/arch/blackfin/include/asm/device.h
index d8f9872..f0a4c25 100644
--- a/arch/blackfin/include/asm/device.h
+++ b/arch/blackfin/include/asm/device.h
@@ -1,7 +1 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
 #include <asm-generic/device.h>
-
diff --git a/arch/blackfin/include/asm/emergency-restart.h b/arch/blackfin/include/asm/emergency-restart.h
index 27f6c78..3711bd9 100644
--- a/arch/blackfin/include/asm/emergency-restart.h
+++ b/arch/blackfin/include/asm/emergency-restart.h
@@ -1,6 +1 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
 #include <asm-generic/emergency-restart.h>
-
-#endif				/* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/blackfin/include/asm/errno.h b/arch/blackfin/include/asm/errno.h
index 164e4f3..4c82b50 100644
--- a/arch/blackfin/include/asm/errno.h
+++ b/arch/blackfin/include/asm/errno.h
@@ -1,6 +1 @@
-#ifndef _BFIN_ERRNO_H
-#define _BFIN_ERRNO_H
-
-#include<asm-generic/errno.h>
-
-#endif				/* _BFIN_ERRNO_H */
+#include <asm-generic/errno.h>
diff --git a/arch/blackfin/include/asm/fb.h b/arch/blackfin/include/asm/fb.h
index c7df380..3a4988e 100644
--- a/arch/blackfin/include/asm/fb.h
+++ b/arch/blackfin/include/asm/fb.h
@@ -1,12 +1 @@
-#ifndef _ASM_FB_H_
-#define _ASM_FB_H_
-#include <linux/fb.h>
-
-#define fb_pgprotect(...) do {} while (0)
-
-static inline int fb_is_primary_device(struct fb_info *info)
-{
-	return 0;
-}
-
-#endif /* _ASM_FB_H_ */
+#include <asm-generic/fb.h>
diff --git a/arch/blackfin/include/asm/futex.h b/arch/blackfin/include/asm/futex.h
index 6a332a9..0b74582 100644
--- a/arch/blackfin/include/asm/futex.h
+++ b/arch/blackfin/include/asm/futex.h
@@ -1,6 +1 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
 #include <asm-generic/futex.h>
-
-#endif
diff --git a/arch/blackfin/include/asm/hw_irq.h b/arch/blackfin/include/asm/hw_irq.h
index 5b51eae..1f5ef7d 100644
--- a/arch/blackfin/include/asm/hw_irq.h
+++ b/arch/blackfin/include/asm/hw_irq.h
@@ -1,6 +1 @@
-#ifndef __ASM_BFIN_HW_IRQ_H
-#define __ASM_BFIN_HW_IRQ_H
-
-/* Dummy include. */
-
-#endif
+#include <asm-generic/hw_irq.h>
diff --git a/arch/blackfin/include/asm/kmap_types.h b/arch/blackfin/include/asm/kmap_types.h
index e215f71..3575c64 100644
--- a/arch/blackfin/include/asm/kmap_types.h
+++ b/arch/blackfin/include/asm/kmap_types.h
@@ -1,21 +1 @@
-#ifndef _ASM_KMAP_TYPES_H
-#define _ASM_KMAP_TYPES_H
-
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
-
-#endif
+#include <asm-generic/kmap_types.h>
diff --git a/arch/blackfin/include/asm/local.h b/arch/blackfin/include/asm/local.h
index 75afffb..c11c530 100644
--- a/arch/blackfin/include/asm/local.h
+++ b/arch/blackfin/include/asm/local.h
@@ -1,6 +1 @@
-#ifndef __BLACKFIN_LOCAL_H
-#define __BLACKFIN_LOCAL_H
-
 #include <asm-generic/local.h>
-
-#endif				/* __BLACKFIN_LOCAL_H */
diff --git a/arch/blackfin/include/asm/param.h b/arch/blackfin/include/asm/param.h
index 41564a6..965d454 100644
--- a/arch/blackfin/include/asm/param.h
+++ b/arch/blackfin/include/asm/param.h
@@ -1,22 +1 @@
-#ifndef _BLACKFIN_PARAM_H
-#define _BLACKFIN_PARAM_H
-
-#ifdef __KERNEL__
-#define HZ 		CONFIG_HZ
-#define	USER_HZ		100
-#define	CLOCKS_PER_SEC	(USER_HZ)
-#endif
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#define EXEC_PAGESIZE	4096
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
-
-#endif				/* _BLACKFIN_PARAM_H */
+#include <asm-generic/param.h>
diff --git a/arch/blackfin/include/asm/percpu.h b/arch/blackfin/include/asm/percpu.h
index c94c7bc..06a959d 100644
--- a/arch/blackfin/include/asm/percpu.h
+++ b/arch/blackfin/include/asm/percpu.h
@@ -1,6 +1 @@
-#ifndef __ARCH_BLACKFIN_PERCPU__
-#define __ARCH_BLACKFIN_PERCPU__
-
 #include <asm-generic/percpu.h>
-
-#endif	/* __ARCH_BLACKFIN_PERCPU__ */
diff --git a/arch/blackfin/include/asm/pgalloc.h b/arch/blackfin/include/asm/pgalloc.h
index c686e05..f261cb7 100644
--- a/arch/blackfin/include/asm/pgalloc.h
+++ b/arch/blackfin/include/asm/pgalloc.h
@@ -1,8 +1 @@
-#ifndef _BLACKFIN_PGALLOC_H
-#define _BLACKFIN_PGALLOC_H
-
-#include <asm/setup.h>
-
-#define check_pgt_cache()	do { } while (0)
-
-#endif				/* _BLACKFIN_PGALLOC_H */
+#include <asm-generic/pgalloc.h>
diff --git a/arch/blackfin/include/asm/resource.h b/arch/blackfin/include/asm/resource.h
index 091355a..04bc4db 100644
--- a/arch/blackfin/include/asm/resource.h
+++ b/arch/blackfin/include/asm/resource.h
@@ -1,6 +1 @@
-#ifndef _BFIN_RESOURCE_H
-#define _BFIN_RESOURCE_H
-
 #include <asm-generic/resource.h>
-
-#endif				/* _BFIN_RESOURCE_H */
diff --git a/arch/blackfin/include/asm/serial.h b/arch/blackfin/include/asm/serial.h
index 3a47606..94a4a12 100644
--- a/arch/blackfin/include/asm/serial.h
+++ b/arch/blackfin/include/asm/serial.h
@@ -1,6 +1,2 @@
-/*
- * include/asm-blackfin/serial.h
- */
-
+#include <asm-generic/serial.h>
 #define SERIAL_EXTRA_IRQ_FLAGS IRQF_TRIGGER_HIGH
-#define BASE_BAUD (1843200 / 16)
diff --git a/arch/blackfin/include/asm/setup.h b/arch/blackfin/include/asm/setup.h
index 01c8c6c..552df83 100644
--- a/arch/blackfin/include/asm/setup.h
+++ b/arch/blackfin/include/asm/setup.h
@@ -1,17 +1 @@
-/*
-** asm/setup.h -- Definition of the Linux/bfin setup information
-**
-** This file is subject to the terms and conditions of the GNU General Public
-** License.  See the file COPYING in the main directory of this archive
-** for more details.
-**
-** Copyright Lineo, Inc 2001          Tony Kou
-**
-*/
-
-#ifndef _BFIN_SETUP_H
-#define _BFIN_SETUP_H
-
-#define COMMAND_LINE_SIZE	512
-
-#endif				/* _BFIN_SETUP_H */
+#include <asm-generic/setup.h>
diff --git a/arch/blackfin/include/asm/statfs.h b/arch/blackfin/include/asm/statfs.h
index 3506720..0b91fe1 100644
--- a/arch/blackfin/include/asm/statfs.h
+++ b/arch/blackfin/include/asm/statfs.h
@@ -1,6 +1 @@
-#ifndef _BFIN_STATFS_H
-#define _BFIN_STATFS_H
-
 #include <asm-generic/statfs.h>
-
-#endif				/* _BFIN_STATFS_H */
diff --git a/arch/blackfin/include/asm/topology.h b/arch/blackfin/include/asm/topology.h
index acee239..5428f33 100644
--- a/arch/blackfin/include/asm/topology.h
+++ b/arch/blackfin/include/asm/topology.h
@@ -1,6 +1 @@
-#ifndef _ASM_BLACKFIN_TOPOLOGY_H
-#define _ASM_BLACKFIN_TOPOLOGY_H
-
 #include <asm-generic/topology.h>
-
-#endif				/* _ASM_BLACKFIN_TOPOLOGY_H */
-- 
1.6.3.1

