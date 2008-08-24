Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYHXJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYHXJEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYHXJDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYHXJDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fIRyR/P4dKgVbGhBFyTeSlDtRbfzJGVBWT0qaLlehjBiBL/SOXbkz75FGKJ/Yh/W6X
         aW+xvvZryXtpde6pVt0DNYUxp1vQru5XZ0qhKS/M93b/GxhnySxZ2R0BETrHvoxCi3H6
         b3Ao6LKhkT8NdNzReOS2dkkd3ZcLxF5zjgrDY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 04/18] x86: apic_64.c - add sanity check for spurious vector definition
Date: Sun, 24 Aug 2008 02:01:42 -0700
Message-Id: <1219568516-681-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Do not check for SPUTIOUS_APIC_VECTOR definition twice.
Check it once - is what we need.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index ddc5b24..4587e16 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -46,6 +46,13 @@
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
@@ -939,8 +946,6 @@ void __cpuinit setup_local_APIC(void)
 	preempt_disable();
 	value = apic_read(APIC_LVR);
 
-	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
-
 	/*
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
-- 
1.5.4.5

