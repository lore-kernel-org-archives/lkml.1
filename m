Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbZA2A3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbZA2A3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZA1Xri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:53458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbZA1Xrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:37 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 114/114] x86/Voyager: move to the X86_32_NON_STANDARD code section
Date: Wed, 28 Jan 2009 23:43:00 +0000
Message-Id: <1233186180-29883-115-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make Voyager depend on X86_32_NON_STANDARD - it is a non-standard 32-bit
SMP architecture.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1427cb1..5bf0e0c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -331,19 +331,6 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
-config X86_VOYAGER
-	bool "Voyager (NCR)"
-	depends on X86_32 && SMP && !PCI && BROKEN
-	depends on X86_NON_STANDARD
-	help
-	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
-	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
-
-	  *** WARNING ***
-
-	  If you do not specifically know you have a Voyager based machine,
-	  say N here, otherwise the kernel you build will not be bootable.
-
 config X86_32_NON_STANDARD
 	bool "Support non-standard 32-bit SMP architectures"
 	depends on X86_32 && SMP
@@ -354,6 +341,13 @@ config X86_32_NON_STANDARD
 	  if you select them all, kernel will probe it one by one. and will
 	  fallback to default.
 
+config X86_BIGSMP
+	bool "Support for big SMP systems with more than 8 CPUs"
+	depends on X86_32_NON_STANDARD
+	help
+	  This option is needed for the systems that have more than 8 CPUs
+	  and if the system is not of any sub-arch type above.
+
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
 	depends on X86_32_NON_STANDARD
@@ -380,12 +374,18 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
-config X86_BIGSMP
-	bool "Support for big SMP systems with more than 8 CPUs"
+config X86_VOYAGER
+	bool "Voyager (NCR)"
+	depends on SMP && !PCI && BROKEN
 	depends on X86_32_NON_STANDARD
 	help
-	  This option is needed for the systems that have more than 8 CPUs
-	  and if the system is not of any sub-arch type above.
+	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
+	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
+
+	  *** WARNING ***
+
+	  If you do not specifically know you have a Voyager based machine,
+	  say N here, otherwise the kernel you build will not be bootable.
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
-- 
1.6.0.2

