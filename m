Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYHRQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYHRQsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYHRQpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbYHRQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mkuYSwC4BbcgKpkvEty6DrZQZZ/hiTbWj4yVDaWP6xAhkLQyJJNJex+tuzAnlncLsO
         paDXyEFsSylufHnW1ARPBC+gxB9ILntQY0LgJ/WVgsn2HciVSmWqeMTf/POjZ4pQuSG8
         BmXMHJJTq5XsJ+fqV4ClKByU996AOEw+7FHc0=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 10/15] x86: apic - unify end_local_APIC_setup
Date: Mon, 18 Aug 2008 20:45:58 +0400
Message-Id: <a6530339e0bc1f0cd4100b9fa0d91bf6054238f1.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    6 ++++--
 arch/x86/kernel/apic_64.c |    9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c3a252b..f188232 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1155,13 +1155,15 @@ void __cpuinit setup_local_APIC(void)
 
 void __cpuinit end_local_APIC_setup(void)
 {
-	unsigned long value;
-
 	lapic_setup_esr();
+
+#ifdef CONFIG_X86_32
+	unsigned int value;
 	/* Disable the local apic timer */
 	value = apic_read(APIC_LVTT);
 	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 	apic_write(APIC_LVTT, value);
+#endif
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 76c2077..eec10b3 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1014,6 +1014,15 @@ void __cpuinit setup_local_APIC(void)
 void __cpuinit end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
+
+#ifdef CONFIG_X86_32
+	unsigned int value;
+	/* Disable the local apic timer */
+	value = apic_read(APIC_LVTT);
+	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+	apic_write(APIC_LVTT, value);
+#endif
+
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
-- 
1.6.0.rc1.34.g0fe8c

