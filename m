Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbZGHERZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbZGHERZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbZGHEPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:15:09 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:42823 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbZGHEPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:15:06 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 12/12] SFI: add boot-time initialization hooks
Date: Wed, 08 Jul 2009 00:13:58 -0400
Message-id: <7d8801c4e11f26a68fca70798dc40d5f405b4be2.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

There are two SFI boot-time hooks:

sfi_init() maps the SYST using early_ioremap() and validates all the tables.

sfi_init_late() re-maps SYST with ioremap(), and initializes
the ACPI extension, if present.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/setup.c |    3 +++
 init/main.c             |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..94ad296 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -27,6 +27,7 @@
 #include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
+#include <linux/sfi.h>
 #include <linux/apm_bios.h>
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
@@ -977,6 +978,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
+	sfi_init();
+
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
diff --git a/init/main.c b/init/main.c
index 2c5ade7..d32a1ff 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
 #include <linux/kmemtrace.h>
+#include <linux/sfi.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -712,6 +713,7 @@ asmlinkage void __init start_kernel(void)
 	check_bugs();
 
 	acpi_early_init(); /* before LAPIC and SMP init */
+	sfi_init_late();
 
 	ftrace_init();
 
-- 
1.6.0.6

