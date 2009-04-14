Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZDNPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZDNPyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZDNPvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45967 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbZDNPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:46 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 06/14] [VOYAGER] x86: eliminate subarchitecture file setup_arch.h
Date: Tue, 14 Apr 2009 10:51:32 -0500
Message-Id: <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serves no purpose any longer since voyager will reappear as an
explicit quirk function call instead of via the ARCH_SETUP code
insertion.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/mach-voyager/setup_arch.h |   12 ------------
 arch/x86/include/asm/setup_arch.h              |    3 ---
 arch/x86/kernel/probe_roms_32.c                |    1 -
 arch/x86/kernel/setup.c                        |    7 -------
 4 files changed, 0 insertions(+), 23 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-voyager/setup_arch.h
 delete mode 100644 arch/x86/include/asm/setup_arch.h

diff --git a/arch/x86/include/asm/mach-voyager/setup_arch.h b/arch/x86/include/asm/mach-voyager/setup_arch.h
deleted file mode 100644
index 71729ca..0000000
--- a/arch/x86/include/asm/mach-voyager/setup_arch.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#include <asm/voyager.h>
-#include <asm/setup.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
-			(&boot_params.apm_bios_info))
-
-/* Hook to call BIOS initialisation function */
-
-/* for voyager, pass the voyager BIOS/SUS info area to the detection
- * routines */
-
-#define ARCH_SETUP	voyager_detect(VOYAGER_BIOS_INFO);
-
diff --git a/arch/x86/include/asm/setup_arch.h b/arch/x86/include/asm/setup_arch.h
deleted file mode 100644
index 3884620..0000000
--- a/arch/x86/include/asm/setup_arch.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/* Hook to call BIOS initialisation function */
-
-/* no action for generic */
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
index 071e7fe..d683a43 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms_32.c
@@ -18,7 +18,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/io.h>
-#include <asm/setup_arch.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 17fc85f..43f81f0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -82,7 +82,6 @@
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/vmi.h>
-#include <asm/setup_arch.h>
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
@@ -108,10 +107,6 @@
 #include <asm/numa_64.h>
 #endif
 
-#ifndef ARCH_SETUP
-#define ARCH_SETUP
-#endif
-
 RESERVE_BRK(dmi_alloc, 65536);
 
 unsigned int boot_cpu_id __read_mostly;
@@ -725,8 +720,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	ARCH_SETUP
-
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.6.2.1

