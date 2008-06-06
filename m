Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbYFFC3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbYFFC3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763191AbYFFC2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:28:33 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64183 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763330AbYFFC2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:28:16 -0400
Date: Fri, 6 Jun 2008 03:27:56 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: APIC/UP: Remove redundant NMI watchdog downgrade
Message-ID: <Pine.LNX.4.55.0806060242280.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 For the UP case the NMI watchdog downgrade is done consistently in
APIC_init_uniprocessor() now.  Remove redundant code used only when 
BIOS-disabled local APIC is activated.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-lapic-watchdog-bios-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_32.c	2008-06-05 21:15:55.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_32.c	2008-06-05 21:26:37.000000000 +0000
@@ -1154,9 +1154,6 @@ static int __init detect_init_APIC(void)
 	if (l & MSR_IA32_APICBASE_ENABLE)
 		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
-	if (nmi_watchdog != NMI_NONE && nmi_watchdog != NMI_DISABLED)
-		nmi_watchdog = NMI_LOCAL_APIC;
-
 	printk(KERN_INFO "Found and enabled local APIC!\n");
 
 	apic_pm_activate();
