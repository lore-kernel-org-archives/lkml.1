Return-Path: <linux-kernel-owner+w=401wt.eu-S1763904AbYFFC2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763904AbYFFC2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYFFC2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:28:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64163 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763085AbYFFC2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:28:09 -0400
Date: Fri, 6 Jun 2008 03:27:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: NMI watchdog: Downgrade helper
Message-ID: <Pine.LNX.4.55.0806060237090.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A downgrade helper for the NMI watchdog to be used in all places where 
the I/O APIC watchdog may have been requested, but the I/O APIC is found 
not to be there or meant to be left disabled.  This is so that the 
reconfiguration is cosistent and defined in a single place only.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-nmiwd-local-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/nmi.h linux-2.6.26-rc1-20080505/include/asm-x86/nmi.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/nmi.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/nmi.h	2008-06-05 19:56:30.000000000 +0000
@@ -78,6 +78,11 @@ extern int unknown_nmi_panic;
 void __trigger_all_cpu_backtrace(void);
 #define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
 
+static inline void localise_nmi_watchdog(void)
+{
+	if (nmi_watchdog == NMI_IO_APIC)
+		nmi_watchdog = NMI_LOCAL_APIC;
+}
 #endif
 
 void lapic_watchdog_stop(void);
