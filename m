Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZBOH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZBOH61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBOH6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:58:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:34086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZBOH6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:58:18 -0500
Message-ID: <4997CAE8.6090208@kernel.org>
Date: Sat, 14 Feb 2009 23:57:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make 32bit to call enable_IO_APIC early like 64bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

so remove some #ifdef

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |    4 ----
 arch/x86/kernel/smpboot.c |    3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3057,13 +3057,9 @@ out:
 void __init setup_IO_APIC(void)
 {
 
-#ifdef CONFIG_X86_32
-	enable_IO_APIC();
-#else
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
-#endif
 
 	io_apic_irqs = ~PIC_IRQS;
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1154,13 +1154,12 @@ void __init native_smp_prepare_cpus(unsi
 	 */
 	setup_local_APIC();
 
-#ifdef CONFIG_X86_64
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
-#endif
+
 	end_local_APIC_setup();
 
 	map_cpu_to_logical_apicid();
