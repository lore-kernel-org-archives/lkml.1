Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYHRQug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYHRQug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYHRQqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:46:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYHRQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TmX2+F3f1LFJN4IMGGxvJoya+j1Tns8diYSCL/FCVATVGb0KcgZuIqphsq9HUMqJKK
         wVkk4CD+Xezbqgq5bQHte/x0oZlBzY5d0Q1llEMtRnGZlMlFU1ouQQRycCdt++OzKLc7
         XrzG0cpgMpmYo01oHBZ/IcA/BYU47PPmtXgEw=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 13/15] x86: apic - unify disableapic and nolapic setup handlers
Date: Mon, 18 Aug 2008 20:46:01 +0400
Message-Id: <72ca9cdcbfa0f613f84fd387f9d0eaa76036fe0e.1219073223.git.gorcunov@gmail.com>
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
 arch/x86/kernel/apic_32.c |   11 +++++++++--
 arch/x86/kernel/apic_64.c |    6 +++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index acbc4de..5680bda 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1737,13 +1737,20 @@ static int __init parse_lapic(char *arg)
 }
 early_param("lapic", parse_lapic);
 
-static int __init parse_nolapic(char *arg)
+static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_APIC);
 	return 0;
 }
-early_param("nolapic", parse_nolapic);
+early_param("disableapic", setup_disableapic);
+
+/* same as disableapic, for compatibility */
+static int __init setup_nolapic(char *arg)
+{
+	return setup_disableapic(arg);
+}
+early_param("nolapic", setup_nolapic);
 
 static int __init parse_disable_apic_timer(char *arg)
 {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9997818..7a31718 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1759,7 +1759,7 @@ early_param("nox2apic", setup_nox2apic);
 /*
  * APIC command line parameters
  */
-static __init int setup_disableapic(char *str)
+static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_APIC);
@@ -1768,9 +1768,9 @@ static __init int setup_disableapic(char *str)
 early_param("disableapic", setup_disableapic);
 
 /* same as disableapic, for compatibility */
-static __init int setup_nolapic(char *str)
+static int __init setup_nolapic(char *arg)
 {
-	return setup_disableapic(str);
+	return setup_disableapic(arg);
 }
 early_param("nolapic", setup_nolapic);
 
-- 
1.6.0.rc1.34.g0fe8c

