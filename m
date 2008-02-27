Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYB0VQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYB0VQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYB0VQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:16:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:28047 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYB0VQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:16:32 -0500
Message-ID: <47C5D32E.8070308@ct.jp.nec.com>
Date: Wed, 27 Feb 2008 13:16:30 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: X86_HT always enable on X86_64 SMP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

X86_HT is used for hyperthreading or multicore on 32-bit.
The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.

Unify X86_HT for hyperthreading or multicore.
Turn X86_HT on when X86_64 and SMP are enabled.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bbb385..7168437 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -174,7 +174,7 @@ config X86_64_SMP
 config X86_HT
 	bool
 	depends on SMP
-	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
+	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || X86_64
 	default y
 
 config X86_BIOS_REBOOT
@@ -516,7 +516,7 @@ config NR_CPUS
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
-	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
+	depends on X86_HT
 	help
 	  SMT scheduler support improves the CPU scheduler's decision making
 	  when dealing with Intel Pentium 4 chips with HyperThreading at a
@@ -526,7 +526,7 @@ config SCHED_SMT
 config SCHED_MC
 	def_bool y
 	prompt "Multi-core scheduler support"
-	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
+	depends on X86_HT
 	help
 	  Multi-core scheduler support improves the CPU scheduler's decision
 	  making when dealing with multi-core CPU chips at a cost of slightly
-- 
1.5.3.8

