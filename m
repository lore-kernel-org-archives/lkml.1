Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYFUIiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYFUIiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYFUIhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:37:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:10684 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYFUIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=OFBFbnLBlDDNFXf1JIox92HRO62PTSIlWZuVqhBZg8KVh1OB0pKhB4+C2N51yvnG7L
         EEoF39w5z+Sw+Rdjbi2bmebBhYsklLThdDzRNAV4P7KHPooplGzKJhwS6RkmypeVR75/
         pPSID81K3egkhbC9B6JXUJ7mT4b7x+X9Iz6t4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove some ifdef about acpi in setup_32/64
Date: Sat, 21 Jun 2008 01:38:41 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806210138.43100.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |    5 +----
 arch/x86/kernel/setup_64.c |    4 ----
 2 files changed, 1 insertion(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -738,12 +738,10 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
-#ifdef CONFIG_ACPI
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
 	acpi_boot_table_init();
-#endif
 
 #ifdef CONFIG_ACPI_NUMA
         /*
@@ -824,9 +822,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
-#ifdef CONFIG_ACPI
 	acpi_boot_init();
-#endif
+
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	if (smp_found_config)
 		get_smp_config();
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -372,13 +372,11 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-#ifdef CONFIG_ACPI
 	/*
 	 * Initialize the ACPI boot-time table parser (gets the RSDP and SDT).
 	 * Call this early for SRAT node setup.
 	 */
 	acpi_boot_table_init();
-#endif
 
 	/* How many end-of-memory variables you have, grandma! */
 	max_low_pfn = end_pfn;
@@ -449,12 +447,10 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
-#ifdef CONFIG_ACPI
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */
 	acpi_boot_init();
-#endif
 
 	init_cpu_to_node();
 
