Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZFFV47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZFFV47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZFFV4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:56:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:33946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZFFV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:56:51 -0400
Message-ID: <4A2AE5F9.5030100@kernel.org>
Date: Sat, 06 Jun 2009 14:56:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] x86/cpufreq: don't use SPEEDSTEP with MAXSMP
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com> <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



that is deprecated, and don't update it to use cpumask_copy about cpus_allowed

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/cpu/cpufreq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -111,7 +111,7 @@ config X86_SPEEDSTEP_CENTRINO
 	tristate "Intel Enhanced SpeedStep (deprecated)"
 	select CPU_FREQ_TABLE
 	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
-	depends on X86_32 || (X86_64 && ACPI_PROCESSOR)
+	depends on X86_32 || (X86_64 && ACPI_PROCESSOR && !MAXSMP)
 	help
 	  This is deprecated and this functionality is now merged into
 	  acpi_cpufreq (X86_ACPI_CPUFREQ). Use that driver instead of
