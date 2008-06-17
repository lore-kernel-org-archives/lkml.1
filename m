Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYFQRCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYFQRCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYFQRBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:01:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:52692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYFQRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=q4cpc7p0nC97XZHraZ42wW24SycIDW50HgtHn1KSQN81/N5dqO6ila2KzjvUN/VHPL
         fWL6nHbe19SWtq2QfBbwx1+OxoMPksOjWkQr0PKavK8SWi3N8IfOdMCHcE/l/p6ZXimC
         UfGI6rT1nkz0KtYcHUTjj5PGgxEMnlYWxf0NA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move some function out of setup_bootmem_alloc
Date: Tue, 17 Jun 2008 10:02:45 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806171002.45836.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so make it more like 64 bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

--- a/arch/x86/kernel/setup_32.c	2008-06-17 00:22:29.000000000 -0700
+++ b/arch/x86/kernel/setup_32.c	2008-06-17 00:25:42.000000000 -0700
@@ -624,21 +624,6 @@ void __init setup_bootmem_allocator(void
 		free_bootmem_with_active_regions(i, max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 */
-	acpi_reserve_bootmem();
-#endif
-#ifdef CONFIG_X86_FIND_SMP_CONFIG
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-#endif
-	reserve_crashkernel();
-
-	reserve_ibft_region();
 }
 
 /*
@@ -804,6 +789,22 @@ void __init setup_arch(char **cmdline_p)
 
 	max_low_pfn = setup_memory();
 
+#ifdef CONFIG_ACPI_SLEEP
+	/*
+	 * Reserve low memory region for sleep support.
+	 */
+	acpi_reserve_bootmem();
+#endif
+#ifdef CONFIG_X86_FIND_SMP_CONFIG
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+#endif
+	reserve_crashkernel();
+
+	reserve_ibft_region();
+
 #ifdef CONFIG_KVM_CLOCK
 	kvmclock_init();
 #endif
