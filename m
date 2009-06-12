Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbZFLQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbZFLQKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbZFLQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:10:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59802 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZFLQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:10:29 -0400
From: Jan Engelhardt <jengelh@medozas.de>
To: mingo@elte.hu
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: restore MCE menuconfig indent
Date: Fri, 12 Jun 2009 18:10:30 +0200
Message-Id: <1244823030-3586-1-git-send-email-jengelh@medozas.de>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit v2.6.29-rc6-16-gb276268 "unthreaded/unindented" the MCE
options in menuconfig, this patch restores this.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 arch/x86/Kconfig |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..acf9b22 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -776,10 +776,12 @@ config X86_MCE
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+if X86_MCE
+
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
-	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_LOCAL_APIC
 	---help---
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
@@ -787,7 +789,7 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_LOCAL_APIC
 	---help---
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
@@ -799,7 +801,7 @@ config X86_MCE_THRESHOLD
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_32 && X86_MCE
+	depends on X86_32
 	---help---
 	  Enabling this feature starts a timer that triggers every 5 seconds which
 	  will look at the machine check registers to see if anything happened.
@@ -812,11 +814,13 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP)
+	depends on X86_32 && (X86_UP_APIC || SMP)
 	---help---
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
 
+endif # X86_MCE
+
 config VM86
 	bool "Enable VM86 support" if EMBEDDED
 	default y
-- 
1.6.3.2

