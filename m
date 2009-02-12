Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbZBLMxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbZBLMxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbZBLMun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbZBLMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/9] x86: CMCI: Disable CMCI on rebooting
Message-Id: <20090212124937.6095D3E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disable the CMCI vector on reboot to avoid confusing other OS.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/apic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2009-02-12 12:02:27.000000000 +0100
+++ linux/arch/x86/kernel/apic.c	2009-02-12 12:10:16.000000000 +0100
@@ -868,6 +868,14 @@
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
 	}
 #endif
+#ifdef CONFIG_X86_MCE_INTEL
+	if (maxlvt >= 6) {
+		v = apic_read(APIC_LVTCMCI);
+		if (!(v & APIC_LVT_MASKED))
+			apic_write(APIC_LVTCMCI, v | APIC_LVT_MASKED);
+	}
+#endif
+
 	/*
 	 * Clean APIC state for other OSs:
 	 */
