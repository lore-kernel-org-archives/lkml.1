Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbYFFC3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbYFFC3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763613AbYFFC2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:28:34 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64197 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763387AbYFFC2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:28:22 -0400
Date: Fri, 6 Jun 2008 03:28:02 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: APIC/SMP: Downgrade the NMI watchdog for "nosmp"
Message-ID: <Pine.LNX.4.55.0806060233540.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If configured to use the I/O APIC, the NMI watchdog is deemed to fail if 
the chip has been deactivated as a result of "nosmp".  Downgrade to the 
local APIC watchdog similarly to what is done for the UP case.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-nosmp-watchdog-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c	2008-05-21 06:24:25.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c	2008-06-05 21:45:41.000000000 +0000
@@ -1147,6 +1147,9 @@ static int __init smp_sanity_check(unsig
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		smpboot_clear_io_apic();
+
+		localise_nmi_watchdog();
+
 #ifdef CONFIG_X86_32
 		connect_bsp_APIC();
 #endif
