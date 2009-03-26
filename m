Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZCZIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZCZIAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZCZIAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:00:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:42695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZCZIAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:00:14 -0400
Date: Thu, 26 Mar 2009 07:57:42 GMT
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, kiran@scalex86.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kiran@scalex86.org, yinghai@kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090324061429.GH7278@localdomain>
References: <20090324061429.GH7278@localdomain>
Subject: [tip:x86/apic] Revert "x86: don't compile vsmp_64 for 32bit"
Message-ID: <tip-70511134f61bd6e5eed19f767381f9fb3e762d49@git.kernel.org>
Git-Commit-ID: 70511134f61bd6e5eed19f767381f9fb3e762d49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Mar 2009 07:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70511134f61bd6e5eed19f767381f9fb3e762d49
Gitweb:     http://git.kernel.org/tip/70511134f61bd6e5eed19f767381f9fb3e762d49
Author:     Ravikiran G Thirumalai <kiran@scalex86.org>
AuthorDate: Mon, 23 Mar 2009 23:14:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 21:34:28 +0100

Revert "x86: don't compile vsmp_64 for 32bit"

Partial revert of commit 129d8bc828e011bda0b7110a097bf3a0167f966e
titled 'x86: don't compile vsmp_64 for 32bit'

Commit reverted to compile vsmp_64.c if CONFIG_X86_64 is defined,
since is_vsmp_box() needs to indicate that TSCs are not synchronized, and
hence, not a valid time source, even when CONFIG_X86_VSMP is not defined.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: shai@scalex86.org
LKML-Reference: <20090324061429.GH7278@localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h  |    2 +-
 arch/x86/include/asm/setup.h |    2 +-
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/vsmp_64.c    |   12 +++++++++++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 130a9e2..df8a300 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -75,7 +75,7 @@ static inline void default_inquire_remote_apic(int apicid)
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
 
-#ifdef CONFIG_X86_VSMP
+#ifdef CONFIG_X86_64
 extern int is_vsmp_box(void);
 #else
 static inline int is_vsmp_box(void)
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index fbf0521..bdc2ada 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -64,7 +64,7 @@ extern void x86_quirk_time_init(void);
 #include <asm/bootparam.h>
 
 /* Interrupt control for vSMPowered x86_64 systems */
-#ifdef CONFIG_X86_VSMP
+#ifdef CONFIG_X86_64
 void vsmp_init(void);
 #else
 static inline void vsmp_init(void) { }
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 339ce35..6e9c1f3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -70,7 +70,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
@@ -120,4 +119,5 @@ ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
+	obj-y				+= vsmp_64.o
 endif
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 74de562..a1d804b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -22,7 +22,7 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 
-#ifdef CONFIG_PARAVIRT
+#if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -114,6 +114,7 @@ static void __init set_vsmp_pv_ops(void)
 }
 #endif
 
+#ifdef CONFIG_PCI
 static int is_vsmp = -1;
 
 static void __init detect_vsmp_box(void)
@@ -139,6 +140,15 @@ int is_vsmp_box(void)
 	}
 }
 
+#else
+static void __init detect_vsmp_box(void)
+{
+}
+int is_vsmp_box(void)
+{
+	return 0;
+}
+#endif
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
