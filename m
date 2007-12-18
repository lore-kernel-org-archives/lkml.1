Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXLRMKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXLRMKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXLRMKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:10:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:13778 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXLRMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=enT+H3uonQYGD067Zj0MnEBo5MIIzZ7+dqxjCB7oje/sDMSXuKPzWtFUbQAggfklWC8JO8XUKBLCAqJeFkSHvxpo/0Q/EtQQbWolDzIz4BBkWGlMvFfUnEzKY0uBHXsJ4ZqYr0hWLYWgy6nDRVcCKPGfVmbeeJWf80mQzmEvjUc=
Subject: [PATCH v2] x86: unify module_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 04:10:29 -0800
Message-Id: <1197979829.7734.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5be3fc6a0e28d82a05487a8fb1a86532fb0ad4e8 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 18 Dec 2007 03:58:10 -0800
Subject: [PATCH] x86: unify module_{32|64}.h

This adds one case to the MODULE_PROC_FAMILY block testing
for X86_64.  There are no new things defined on X86_64 than
there were before.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, let a single checkpatch warning go by in the first one,
fixed in this version.

 include/asm-x86/module.h    |   81 +++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/module_32.h |   75 ---------------------------------------
 include/asm-x86/module_64.h |   10 -----
 3 files changed, 79 insertions(+), 87 deletions(-)

diff --git a/include/asm-x86/module.h b/include/asm-x86/module.h
index 2b2f18d..bfedb24 100644
--- a/include/asm-x86/module.h
+++ b/include/asm-x86/module.h
@@ -1,5 +1,82 @@
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+/* x86_32/64 are simple */
+struct mod_arch_specific {};
+
 #ifdef CONFIG_X86_32
-# include "module_32.h"
+# define Elf_Shdr Elf32_Shdr
+# define Elf_Sym Elf32_Sym
+# define Elf_Ehdr Elf32_Ehdr
 #else
-# include "module_64.h"
+# define Elf_Shdr Elf64_Shdr
+# define Elf_Sym Elf64_Sym
+# define Elf_Ehdr Elf64_Ehdr
 #endif
+
+#ifdef CONFIG_X86_64
+/* X86_64 does not define MODULE_PROC_FAMILY */
+#elif defined CONFIG_M386
+#define MODULE_PROC_FAMILY "386 "
+#elif defined CONFIG_M486
+#define MODULE_PROC_FAMILY "486 "
+#elif defined CONFIG_M586
+#define MODULE_PROC_FAMILY "586 "
+#elif defined CONFIG_M586TSC
+#define MODULE_PROC_FAMILY "586TSC "
+#elif defined CONFIG_M586MMX
+#define MODULE_PROC_FAMILY "586MMX "
+#elif defined CONFIG_MCORE2
+#define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_M686
+#define MODULE_PROC_FAMILY "686 "
+#elif defined CONFIG_MPENTIUMII
+#define MODULE_PROC_FAMILY "PENTIUMII "
+#elif defined CONFIG_MPENTIUMIII
+#define MODULE_PROC_FAMILY "PENTIUMIII "
+#elif defined CONFIG_MPENTIUMM
+#define MODULE_PROC_FAMILY "PENTIUMM "
+#elif defined CONFIG_MPENTIUM4
+#define MODULE_PROC_FAMILY "PENTIUM4 "
+#elif defined CONFIG_MK6
+#define MODULE_PROC_FAMILY "K6 "
+#elif defined CONFIG_MK7
+#define MODULE_PROC_FAMILY "K7 "
+#elif defined CONFIG_MK8
+#define MODULE_PROC_FAMILY "K8 "
+#elif defined CONFIG_X86_ELAN
+#define MODULE_PROC_FAMILY "ELAN "
+#elif defined CONFIG_MCRUSOE
+#define MODULE_PROC_FAMILY "CRUSOE "
+#elif defined CONFIG_MEFFICEON
+#define MODULE_PROC_FAMILY "EFFICEON "
+#elif defined CONFIG_MWINCHIPC6
+#define MODULE_PROC_FAMILY "WINCHIPC6 "
+#elif defined CONFIG_MWINCHIP2
+#define MODULE_PROC_FAMILY "WINCHIP2 "
+#elif defined CONFIG_MWINCHIP3D
+#define MODULE_PROC_FAMILY "WINCHIP3D "
+#elif defined CONFIG_MCYRIXIII
+#define MODULE_PROC_FAMILY "CYRIXIII "
+#elif defined CONFIG_MVIAC3_2
+#define MODULE_PROC_FAMILY "VIAC3-2 "
+#elif defined CONFIG_MVIAC7
+#define MODULE_PROC_FAMILY "VIAC7 "
+#elif defined CONFIG_MGEODEGX1
+#define MODULE_PROC_FAMILY "GEODEGX1 "
+#elif defined CONFIG_MGEODE_LX
+#define MODULE_PROC_FAMILY "GEODE "
+#else
+#error unknown processor family
+#endif
+
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_4KSTACKS
+#  define MODULE_STACKSIZE "4KSTACKS "
+# else
+#  define MODULE_STACKSIZE ""
+# endif
+# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+#endif
+
+#endif /* _ASM_MODULE_H */
diff --git a/include/asm-x86/module_32.h b/include/asm-x86/module_32.h
deleted file mode 100644
index 7e5fda6..0000000
--- a/include/asm-x86/module_32.h
+++ /dev/null
@@ -1,75 +0,0 @@
-#ifndef _ASM_I386_MODULE_H
-#define _ASM_I386_MODULE_H
-
-/* x86 is simple */
-struct mod_arch_specific
-{
-};
-
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Ehdr Elf32_Ehdr
-
-#ifdef CONFIG_M386
-#define MODULE_PROC_FAMILY "386 "
-#elif defined CONFIG_M486
-#define MODULE_PROC_FAMILY "486 "
-#elif defined CONFIG_M586
-#define MODULE_PROC_FAMILY "586 "
-#elif defined CONFIG_M586TSC
-#define MODULE_PROC_FAMILY "586TSC "
-#elif defined CONFIG_M586MMX
-#define MODULE_PROC_FAMILY "586MMX "
-#elif defined CONFIG_MCORE2
-#define MODULE_PROC_FAMILY "CORE2 "
-#elif defined CONFIG_M686
-#define MODULE_PROC_FAMILY "686 "
-#elif defined CONFIG_MPENTIUMII
-#define MODULE_PROC_FAMILY "PENTIUMII "
-#elif defined CONFIG_MPENTIUMIII
-#define MODULE_PROC_FAMILY "PENTIUMIII "
-#elif defined CONFIG_MPENTIUMM
-#define MODULE_PROC_FAMILY "PENTIUMM "
-#elif defined CONFIG_MPENTIUM4
-#define MODULE_PROC_FAMILY "PENTIUM4 "
-#elif defined CONFIG_MK6
-#define MODULE_PROC_FAMILY "K6 "
-#elif defined CONFIG_MK7
-#define MODULE_PROC_FAMILY "K7 "
-#elif defined CONFIG_MK8
-#define MODULE_PROC_FAMILY "K8 "
-#elif defined CONFIG_X86_ELAN
-#define MODULE_PROC_FAMILY "ELAN "
-#elif defined CONFIG_MCRUSOE
-#define MODULE_PROC_FAMILY "CRUSOE "
-#elif defined CONFIG_MEFFICEON
-#define MODULE_PROC_FAMILY "EFFICEON "
-#elif defined CONFIG_MWINCHIPC6
-#define MODULE_PROC_FAMILY "WINCHIPC6 "
-#elif defined CONFIG_MWINCHIP2
-#define MODULE_PROC_FAMILY "WINCHIP2 "
-#elif defined CONFIG_MWINCHIP3D
-#define MODULE_PROC_FAMILY "WINCHIP3D "
-#elif defined CONFIG_MCYRIXIII
-#define MODULE_PROC_FAMILY "CYRIXIII "
-#elif defined CONFIG_MVIAC3_2
-#define MODULE_PROC_FAMILY "VIAC3-2 "
-#elif defined CONFIG_MVIAC7
-#define MODULE_PROC_FAMILY "VIAC7 "
-#elif defined CONFIG_MGEODEGX1
-#define MODULE_PROC_FAMILY "GEODEGX1 "
-#elif defined CONFIG_MGEODE_LX
-#define MODULE_PROC_FAMILY "GEODE "
-#else
-#error unknown processor family
-#endif
-
-#ifdef CONFIG_4KSTACKS
-#define MODULE_STACKSIZE "4KSTACKS "
-#else
-#define MODULE_STACKSIZE ""
-#endif
-
-#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
-
-#endif /* _ASM_I386_MODULE_H */
diff --git a/include/asm-x86/module_64.h b/include/asm-x86/module_64.h
deleted file mode 100644
index 67f8f69..0000000
--- a/include/asm-x86/module_64.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _ASM_X8664_MODULE_H
-#define _ASM_X8664_MODULE_H
-
-struct mod_arch_specific {}; 
-
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Ehdr Elf64_Ehdr
-
-#endif 
-- 
1.5.4.rc0.1143.g1a8a



