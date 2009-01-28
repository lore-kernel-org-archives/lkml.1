Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbZA2AZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbZA2AZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbZA1XrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:53418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbZA1XrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:10 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 102/114] x86/Voyager: remove APIC/IO-APIC Kbuild quirk
Date: Wed, 28 Jan 2009 23:42:48 +0000
Message-Id: <1233186180-29883-103-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lapic/ioapic code properly auto-detects and is safe to run on CPUs that
have no local APIC. (or which have their lapic turned off in the hardware)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8210534..6fbb363 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -642,7 +642,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !(X86_VOYAGER || X86_GENERICARCH)
+	depends on X86_32 && !SMP && !X86_GENERICARCH
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -667,11 +667,11 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	depends on X86_64 || SMP || X86_GENERICARCH || X86_UP_APIC
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	depends on X86_64 || SMP || X86_GENERICARCH || X86_UP_APIC
 
 config X86_VISWS_APIC
 	def_bool y
-- 
1.6.0.2

