Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZHZGiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZHZGiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZHZGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:38:09 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:43383 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZHZGiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:38:08 -0400
Subject: Subject: [PATCH 21/33] score: create head files linkage.h local.h
	module.h socket.h sockios.h unaligned.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:27:41 +0800
Message-Id: <1251268061.3153.9.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a805a33bbf82bbb6371fcdad5a7834c11d1672a3 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:07 +0800
Subject: [PATCH 21/33] score: create head files linkage.h local.h module.h socket.h sockios.h unaligned.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/linkage.h   |    7 ++++++
 arch/score/include/asm/local.h     |    6 +++++
 arch/score/include/asm/module.h    |   39 ++++++++++++++++++++++++++++++++++++
 arch/score/include/asm/socket.h    |    6 +++++
 arch/score/include/asm/sockios.h   |    6 +++++
 arch/score/include/asm/unaligned.h |    6 +++++
 6 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/linkage.h
 create mode 100644 arch/score/include/asm/local.h
 create mode 100644 arch/score/include/asm/module.h
 create mode 100644 arch/score/include/asm/socket.h
 create mode 100644 arch/score/include/asm/sockios.h
 create mode 100644 arch/score/include/asm/unaligned.h

diff --git a/arch/score/include/asm/linkage.h b/arch/score/include/asm/linkage.h
new file mode 100644
index 0000000..2323a8e
--- /dev/null
+++ b/arch/score/include/asm/linkage.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_SCORE_LINKAGE_H
+#define _ASM_SCORE_LINKAGE_H
+
+#define __ALIGN .align 2
+#define __ALIGN_STR ".align 2"
+
+#endif /* _ASM_SCORE_LINKAGE_H */
diff --git a/arch/score/include/asm/local.h b/arch/score/include/asm/local.h
new file mode 100644
index 0000000..7e02f13
--- /dev/null
+++ b/arch/score/include/asm/local.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_LOCAL_H
+#define _ASM_SCORE_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_SCORE_LOCAL_H */
diff --git a/arch/score/include/asm/module.h b/arch/score/include/asm/module.h
new file mode 100644
index 0000000..f0b5dc0
--- /dev/null
+++ b/arch/score/include/asm/module.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_SCORE_MODULE_H
+#define _ASM_SCORE_MODULE_H
+
+#include <linux/list.h>
+#include <asm/uaccess.h>
+
+struct mod_arch_specific {
+	/* Data Bus Error exception tables */
+	struct list_head dbe_list;
+	const struct exception_table_entry *dbe_start;
+	const struct exception_table_entry *dbe_end;
+};
+
+typedef uint8_t Elf64_Byte;		/* Type for a 8-bit quantity. */
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Addr	Elf32_Addr
+
+/* Given an address, look for it in the exception tables. */
+#ifdef CONFIG_MODULES
+const struct exception_table_entry *search_module_dbetables(unsigned long addr);
+#else
+static inline const struct exception_table_entry
+*search_module_dbetables(unsigned long addr)
+{
+	return NULL;
+}
+#endif
+
+#define MODULE_PROC_FAMILY "SCORE7"
+#define MODULE_KERNEL_TYPE "32BIT "
+#define MODULE_KERNEL_SMTC ""
+
+#define MODULE_ARCH_VERMAGIC \
+	MODULE_PROC_FAMILY MODULE_KERNEL_TYPE MODULE_KERNEL_SMTC
+
+#endif /* _ASM_SCORE_MODULE_H */
diff --git a/arch/score/include/asm/socket.h b/arch/score/include/asm/socket.h
new file mode 100644
index 0000000..612a70e
--- /dev/null
+++ b/arch/score/include/asm/socket.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SOCKET_H
+#define _ASM_SCORE_SOCKET_H
+
+#include <asm-generic/socket.h>
+
+#endif /* _ASM_SCORE_SOCKET_H */
diff --git a/arch/score/include/asm/sockios.h b/arch/score/include/asm/sockios.h
new file mode 100644
index 0000000..ba82564
--- /dev/null
+++ b/arch/score/include/asm/sockios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SOCKIOS_H
+#define _ASM_SCORE_SOCKIOS_H
+
+#include <asm-generic/sockios.h>
+
+#endif /* _ASM_SCORE_SOCKIOS_H */
diff --git a/arch/score/include/asm/unaligned.h b/arch/score/include/asm/unaligned.h
new file mode 100644
index 0000000..2fc06de
--- /dev/null
+++ b/arch/score/include/asm/unaligned.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_UNALIGNED_H
+#define _ASM_SCORE_UNALIGNED_H
+
+#include <asm-generic/unaligned.h>
+
+#endif /* _ASM_SCORE_UNALIGNED_H */
-- 
1.6.2



