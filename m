Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbZA2AJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbZA2AJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbZA1Xpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:53117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343AbZA1Xpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:50 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 069/114] x86: eliminate asm/mach-*/mach_mpparse.h
Date: Wed, 28 Jan 2009 23:42:15 +0000
Message-Id: <1233186180-29883-70-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition to mpparse.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach-default/mach_mpparse.h |   17 -----------------
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    8 --------
 arch/x86/include/asm/mpspec.h                    |    4 ++++
 arch/x86/kernel/acpi/boot.c                      |    1 -
 arch/x86/kernel/es7000_32.c                      |    1 -
 arch/x86/kernel/mpparse.c                        |    1 -
 arch/x86/mach-generic/bigsmp.c                   |    1 -
 arch/x86/mach-generic/default.c                  |    1 -
 8 files changed, 4 insertions(+), 30 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_mpparse.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_mpparse.h

diff --git a/arch/x86/include/asm/mach-default/mach_mpparse.h b/arch/x86/include/asm/mach-default/mach_mpparse.h
deleted file mode 100644
index af0da14..0000000
--- a/arch/x86/include/asm/mach-default/mach_mpparse.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
-#define _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
-
-static inline int
-generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
-{
-	return 0;
-}
-
-/* Hook from generic ACPI tables.c */
-static inline int default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	return 0;
-}
-
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_mpparse.h b/arch/x86/include/asm/mach-generic/mach_mpparse.h
deleted file mode 100644
index 22bfb56..0000000
--- a/arch/x86/include/asm/mach-generic/mach_mpparse.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
-#define _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
-
-extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
-
-extern int default_acpi_madt_oem_check(char *, char *);
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 62d14ce..432e9cb 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -142,4 +142,8 @@ static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 
 extern physid_mask_t phys_cpu_present_map;
 
+extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
+
+extern int default_acpi_madt_oem_check(char *, char *);
+
 #endif /* _ASM_X86_MPSPEC_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 5391631..7b02a1c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -63,7 +63,6 @@ EXPORT_SYMBOL(acpi_disabled);
 
 #ifdef	CONFIG_X86_LOCAL_APIC
 #include <mach_apic.h>
-#include <mach_mpparse.h>
 #endif				/* CONFIG_X86_LOCAL_APIC */
 
 #endif				/* X86 */
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index d7f433e..8faea13 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -40,7 +40,6 @@
 #include <asm/smp.h>
 #include <asm/atomic.h>
 #include <asm/apicdef.h>
-#include <mach_mpparse.h>
 #include <asm/genapic.h>
 #include <asm/setup.h>
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b12fa5c..c693016 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -32,7 +32,6 @@
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
 #include <mach_apicdef.h>
-#include <mach_mpparse.h>
 #endif
 
 /*
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 6fcccfb..626f45c 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -16,7 +16,6 @@
 #include <linux/smp.h>
 #include <asm/bigsmp/apic.h>
 #include <asm/bigsmp/ipi.h>
-#include <asm/mach-default/mach_mpparse.h>
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index e3c5114..6485e57 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <asm/mach-default/mach_apic.h>
 #include <asm/mach-default/mach_ipi.h>
-#include <asm/mach-default/mach_mpparse.h>
 
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-- 
1.6.0.2

