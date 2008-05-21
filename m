Return-Path: <linux-kernel-owner+w=401wt.eu-S937674AbYEUVMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937674AbYEUVMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937104AbYEUVKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:10:03 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63929 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937377AbYEUVKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:10:00 -0400
Date: Wed, 21 May 2008 22:09:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] x86: APIC/SMP: Correct the message for "nosmp"
Message-ID: <Pine.LNX.4.55.0805212035240.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The local APIC is no longer forced off when "nosmp" has been specified.  
Correct the message printed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-nosmp-apic-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c	2008-05-05 02:56:19.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c	2008-05-21 06:24:25.000000000 +0000
@@ -1145,8 +1145,7 @@ static int __init smp_sanity_check(unsig
 	 * If SMP should be disabled, then really disable it!
 	 */
 	if (!max_cpus) {
-		printk(KERN_INFO "SMP mode deactivated,"
-				 "forcing use of dummy APIC emulation.\n");
+		printk(KERN_INFO "SMP mode deactivated.\n");
 		smpboot_clear_io_apic();
 #ifdef CONFIG_X86_32
 		connect_bsp_APIC();
