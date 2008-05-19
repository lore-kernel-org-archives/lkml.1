Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbYESPso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbYESPso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbYESPrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:19 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41329 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760966AbYESPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:17 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: allow MPPARSE to be deselected in SMP configs
Date: Mon, 19 May 2008 19:47:22 +0400
Message-ID: <20080519154722.15071.91358.stgit@thinkpad>
In-Reply-To: <20080519154656.15071.96979.stgit@thinkpad>
References: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/Kconfig.debug     |    2 +-
 arch/x86/kernel/setup.c    |    2 +-
 arch/x86/kernel/setup_32.c |    2 +-
 arch/x86/kernel/setup_64.c |    4 ++++
 4 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5eb480e..f27de28 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -128,7 +128,7 @@ config 4KSTACKS
 
 config X86_FIND_SMP_CONFIG
 	def_bool y
-	depends on X86_LOCAL_APIC || X86_VOYAGER
+	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
 	depends on X86_32
 
 config X86_MPPARSE
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 089ddfa..c86bda7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,7 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
-#ifdef CONFIG_X86_MPPARSE
+#ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 12a31de..9af0d5f 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -846,7 +846,7 @@ void __init setup_arch(char **cmdline_p)
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
+#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	if (smp_found_config)
 		get_smp_config();
 #endif
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 9234675..8047db9 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -439,7 +439,9 @@ void __init setup_arch(char **cmdline_p)
        /*
 	* Find and reserve possible boot-time SMP configuration:
 	*/
+#ifdef CONFIG_X86_MPPARSE
 	find_smp_config();
+#endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -485,8 +487,10 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * get boot-time SMP configuration:
 	 */
+#ifdef CONFIG_X86_MPPARSE
 	if (smp_found_config)
 		get_smp_config();
+#endif
 	init_apic_mappings();
 	ioapic_init_mappings();
 

