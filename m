Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZCHQuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZCHQuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZCHQsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37635 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbZCHQsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:45 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 06/13] [VOYAGER] x86: eliminate subarchitecture file setup_arch.h
Date: Sun,  8 Mar 2009 11:48:19 -0500
Message-Id: <1236530906-7175-7-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-6-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-6-git-send-email-James.Bottomley@HansenPartnership.com>
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
index 797f7d7..7f5d968 100644
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
 unsigned int boot_cpu_id __read_mostly;
 
 #ifdef CONFIG_X86_64
@@ -701,8 +696,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	ARCH_SETUP
-
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.6.1.3

