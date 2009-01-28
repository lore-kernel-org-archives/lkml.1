Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbZA2AVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbZA2AVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbZA1Xqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:53339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbZA1Xqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:51 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 095/114] x86/Voyager: remove X86_BIOS_REBOOT Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:41 +0000
Message-Id: <1233186180-29883-96-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this Kconfig quirk:

config X86_BIOS_REBOOT
	bool
	depends on !X86_VOYAGER
	default y

Voyager should use the existing machine_ops.emergency_restart reboot
quirk mechanism instead of a build-time quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig             |    6 ------
 arch/x86/include/asm/proto.h |    4 ----
 arch/x86/kernel/Makefile     |    2 +-
 3 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d50c9d..c0d79ab 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -190,11 +190,6 @@ config X86_HT
 	depends on SMP
 	default y
 
-config X86_BIOS_REBOOT
-	bool
-	depends on !X86_VOYAGER
-	default y
-
 config X86_TRAMPOLINE
 	bool
 	depends on SMP || (64BIT && ACPI_SLEEP)
@@ -1361,7 +1356,6 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
-	depends on X86_BIOS_REBOOT
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index d6a22f9..49fb3ec 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -18,11 +18,7 @@ extern void syscall32_cpu_init(void);
 
 extern void check_efer(void);
 
-#ifdef CONFIG_X86_BIOS_REBOOT
 extern int reboot_force;
-#else
-static const int reboot_force = 0;
-#endif
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 1ab8e47..2ba32d2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -50,7 +50,7 @@ obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
-obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
+obj-y				+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-- 
1.6.0.2

