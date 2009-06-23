Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZFWHOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZFWHOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZFWHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:13 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:55159 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbZFWHOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:11 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/8] SFI: Hook boot-time initialization
Date: Tue, 23 Jun 2009 03:14:02 -0400
Message-id: <049af54e14f6f070140927cb67602c186f93b26c.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
In-reply-to: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/setup.c |    3 +++
 init/main.c             |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..e2e6794 100644
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
@@ -952,6 +953,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
+	sfi_init();
+
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
diff --git a/init/main.c b/init/main.c
index f1b9f0f..36333c7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -65,6 +65,7 @@
 #include <linux/idr.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
+#include <linux/sfi.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -688,6 +689,7 @@ asmlinkage void __init start_kernel(void)
 	check_bugs();
 
 	acpi_early_init(); /* before LAPIC and SMP init */
+	sfi_init_late();
 
 	ftrace_init();
 
-- 
1.6.0.6

