Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbZA2AMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbZA2AMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbZA1XqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:53147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbZA1Xp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:56 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 070/114] x86: remove mach_mpspec.h
Date: Wed, 28 Jan 2009 23:42:16 +0000
Message-Id: <1233186180-29883-71-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move its definitions into mpspec.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach-default/mach_mpspec.h |   12 -----------
 arch/x86/include/asm/mach-generic/mach_mpspec.h |   12 -----------
 arch/x86/include/asm/mpspec.h                   |   25 +++++++++++++++++-----
 3 files changed, 19 insertions(+), 30 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_mpspec.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_mpspec.h

diff --git a/arch/x86/include/asm/mach-default/mach_mpspec.h b/arch/x86/include/asm/mach-default/mach_mpspec.h
deleted file mode 100644
index e85ede6..0000000
--- a/arch/x86/include/asm/mach-default/mach_mpspec.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_MPSPEC_H
-#define _ASM_X86_MACH_DEFAULT_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 256
-
-#if CONFIG_BASE_SMALL == 0
-#define MAX_MP_BUSSES 256
-#else
-#define MAX_MP_BUSSES 32
-#endif
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_MPSPEC_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_mpspec.h b/arch/x86/include/asm/mach-generic/mach_mpspec.h
deleted file mode 100644
index 3bc4072..0000000
--- a/arch/x86/include/asm/mach-generic/mach_mpspec.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_MPSPEC_H
-#define _ASM_X86_MACH_GENERIC_MACH_MPSPEC_H
-
-#define MAX_IRQ_SOURCES 256
-
-/* Summit or generic (i.e. installer) kernels need lots of bus entries. */
-/* Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets. */
-#define MAX_MP_BUSSES 260
-
-extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_MPSPEC_H */
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 432e9cb..03fb0d3 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -9,7 +9,18 @@ extern int apic_version[MAX_APICS];
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
-#include <mach_mpspec.h>
+
+/*
+ * Summit or generic (i.e. installer) kernels need lots of bus entries.
+ * Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets.
+ */
+#if CONFIG_BASE_SMALL == 0
+# define MAX_MP_BUSSES		260
+#else
+# define MAX_MP_BUSSES		32
+#endif
+
+#define MAX_IRQ_SOURCES		256
 
 extern unsigned int def_to_bigsmp;
 extern u8 apicid_2_node[];
@@ -20,15 +31,15 @@ extern int mp_bus_id_to_local[MAX_MP_BUSSES];
 extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #endif
 
-#define MAX_APICID 256
+#define MAX_APICID		256
 
-#else
+#else /* CONFIG_X86_64: */
 
-#define MAX_MP_BUSSES 256
+#define MAX_MP_BUSSES		256
 /* Each PCI slot may be a combo card with its own bus.  4 IRQ pins per slot. */
-#define MAX_IRQ_SOURCES (MAX_MP_BUSSES * 4)
+#define MAX_IRQ_SOURCES		(MAX_MP_BUSSES * 4)
 
-#endif
+#endif /* CONFIG_X86_64 */
 
 extern void early_find_smp_config(void);
 extern void early_get_smp_config(void);
@@ -146,4 +157,6 @@ extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
 
 extern int default_acpi_madt_oem_check(char *, char *);
 
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
+
 #endif /* _ASM_X86_MPSPEC_H */
-- 
1.6.0.2

