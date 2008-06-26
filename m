Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYFZCvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYFZCvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYFZCu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:50:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:7542 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYFZCu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pk0zrA5f0SW5ZazEtNg1P3XM3VPqdahFMnDD7JalzOlaecKUSLYRxN34QkeMMlsK+E
         NMQLrGS4X5ssNzZpYCMhgBvqI5U068qjAnLO9i4Rj+mdVCtHwzkC9k2HhWr/tPJ1dchU
         FUgfyO1w9xs4gmkzA0ag67hSZmi/RFHGTeKe8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: clean up ARCH_SETUP
Date: Wed, 25 Jun 2008 19:52:15 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251952.16257.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


asm-x86/paravirt.h already have protection with CONFIG_PARAVIRT inside

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c                   |    8 ++++----
 include/asm-x86/mach-default/setup_arch.h |    4 ----
 include/asm-x86/mach-visws/setup_arch.h   |    2 --
 3 files changed, 4 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -100,11 +100,7 @@
 #include <asm/proto.h>
 
 #include <mach_apic.h>
-#ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-#else
-#define ARCH_SETUP
-#endif
 
 #include <asm/percpu.h>
 #include <asm/sections.h>
@@ -114,6 +110,10 @@
 #include <asm/highmem.h>
 #endif
 
+#ifndef ARCH_SETUP
+#define ARCH_SETUP
+#endif
+
 #ifndef CONFIG_DEBUG_BOOT_PARAMS
 struct boot_params __initdata boot_params;
 #else
Index: linux-2.6/include/asm-x86/mach-default/setup_arch.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/setup_arch.h
+++ linux-2.6/include/asm-x86/mach-default/setup_arch.h
@@ -1,7 +1,3 @@
 /* Hook to call BIOS initialisation function */
 
 /* no action for generic */
-
-#ifndef ARCH_SETUP
-#define ARCH_SETUP
-#endif
Index: linux-2.6/include/asm-x86/mach-visws/setup_arch.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-visws/setup_arch.h
+++ linux-2.6/include/asm-x86/mach-visws/setup_arch.h
@@ -4,5 +4,3 @@ extern unsigned long sgivwfb_mem_phys;
 extern unsigned long sgivwfb_mem_size;
 
 /* no action for visws */
-
-#define ARCH_SETUP
