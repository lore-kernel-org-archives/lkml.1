Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYFQWpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYFQWpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbYFQWpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:45:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:57824 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbYFQWpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=Ff3HcydCxNEgRZdTIshgmYVzUlk7KLRYCOF3gH9E2JG/X3Pb1qKu+idwm5YELbgYkV
         PA11NXQRZvZdrYw/8y2WAAhAzPH6frJA+HoyGrbitHsUUprfbL/ryYR3WHiUy/CQGntz
         xbhXMn5Z7Klv6u8FQCsNJmJVWr/fZSW9rb3FA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: Kconfig cleanup with genericarch
Date: Tue, 17 Jun 2008 15:39:01 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806171539.01555.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we already have summit and etc depends on genericarch,
so use genericarch only

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 48b2143..ee63192 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -428,7 +428,7 @@ config MEMTEST
 
 config ACPI_SRAT
 	def_bool y
-	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	depends on X86_32 && ACPI && NUMA && X86_GENERICARCH
 	select ACPI_NUMA
 
 config HAVE_ARCH_PARSE_SRAT
@@ -437,11 +437,11 @@ config HAVE_ARCH_PARSE_SRAT
 
 config X86_SUMMIT_NUMA
 	def_bool y
-	depends on X86_32 && NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	depends on X86_32 && NUMA && X86_GENERICARCH
 
 config X86_CYCLONE_TIMER
 	def_bool y
-	depends on X86_32 && X86_SUMMIT || X86_GENERICARCH
+	depends on X86_GENERICARCH
 
 config ES7000_CLUSTERED_APIC
 	def_bool y
@@ -906,9 +906,9 @@ config X86_PAE
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_GENERICARCH || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
 	default n if X86_PC
-	default y if (X86_NUMAQ || X86_SUMMIT || X86_GENERICARCH)
+	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	help
 	  Enable NUMA (Non Uniform Memory Access) support.
 	  The kernel will try to allocate memory used by a CPU on the
