Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbYHWNCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbYHWNCC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYHWNBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:20941 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYHWNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vGPeo98uyfz6SXnrFPgOTDgOyQGqF51m4B1CyoBQZvaVjZjPxYaXE2DGHx38uOXOUq
         L6lUYDVCPxKf+8I57C4J+nM6cuR2BOAb3FFolBhZ3yL1P1P+NPsr+9eGDbKUDV4x73fB
         HXLvxSYdyazov4i/SDvwdivx3dT/QVG/NJrWY=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 4/8] x86: apic_64.c - add sanity check for spurious vector definition
Date: Sat, 23 Aug 2008 17:01:21 +0400
Message-Id: <cab0dc5625c319598542f81b20ed2679c49924f9.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not check for SPUTIOUS_APIC_VECTOR definition twice.
Check it once - is what we need.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 03641d7..b220726 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -45,6 +45,13 @@
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
+/*
+ * Sanity check
+ */
+#if ((SPURIOUS_APIC_VECTOR & 0x0F) != 0x0F)
+# error SPURIOUS_APIC_VECTOR definition error
+#endif
+
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
@@ -929,8 +936,6 @@ void __cpuinit setup_local_APIC(void)
 	preempt_disable();
 	value = apic_read(APIC_LVR);
 
-	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
-
 	/*
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
-- 
1.6.0.6.gc667

