Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbYESUaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbYESUaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYESU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:29:57 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:46509 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360AbYESU35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:29:57 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: allow MPPARSE to be deselected in SMP configs
Date: Tue, 20 May 2008 00:29:59 +0400
Message-ID: <20080519202959.1467.7919.stgit@thinkpad>
In-Reply-To: <86802c440805191308k5700fbb9x5ed76f7f58d11c69@mail.gmail.com>
References: <86802c440805191308k5700fbb9x5ed76f7f58d11c69@mail.gmail.com>
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
index 9234675..88f0ac2 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -436,10 +436,12 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_reserve_bootmem();
 
+#ifdef CONFIG_X86_MPPARSE
        /*
 	* Find and reserve possible boot-time SMP configuration:
 	*/
 	find_smp_config();
+#endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -482,11 +484,13 @@ void __init setup_arch(char **cmdline_p)
 
 	init_cpu_to_node();
 
+#ifdef CONFIG_X86_MPPARSE
 	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
 		get_smp_config();
+#endif
 	init_apic_mappings();
 	ioapic_init_mappings();
 

