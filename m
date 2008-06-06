Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbYFFC34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbYFFC34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763631AbYFFC2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:28:35 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64214 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763431AbYFFC2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:28:31 -0400
Date: Fri, 6 Jun 2008 03:28:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: APIC/SMP: Downgrade the NMI watchdog for "noapic"
Message-ID: <Pine.LNX.4.55.0806060306400.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If configured to use the I/O APIC, the NMI watchdog is deemed to fail if 
the chip has been deactivated as a result of "noapic".  Downgrade to the 
local APIC watchdog similarly to what is done for the UP case.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-noapic-watchdog-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/mach-default/smpboot_hooks.h linux-2.6.26-rc1-20080505/include/asm-x86/mach-default/smpboot_hooks.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/mach-default/smpboot_hooks.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/mach-default/smpboot_hooks.h	2008-06-05 22:11:30.000000000 +0000
@@ -41,8 +41,10 @@ static inline void __init smpboot_setup_
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
-	else
+	else {
 		nr_ioapics = 0;
+		localise_nmi_watchdog();
+	}
 }
 
 static inline void smpboot_clear_io_apic(void)
