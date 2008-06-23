Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYFWAjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYFWAjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFWAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:39:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:27690 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYFWAjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=U+eWfNf7JgLncb8rIXEQVsLDtkkv3mKOejZVj89GH9Kfku0dsijYZv3XM/9gxgxbcb
         D5mLuoVT6UC2So9uRvNF8axrk9Xtkg5pTahUEjNWl9HWucIkqvsqR0eTOr+DNB0kA/n1
         rNvysJ0F/j49ExbDNdP5v3sU9Qf6Vxs3TL/do=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: move boot_params declaring to setup.c
Date: Sun, 22 Jun 2008 17:37:54 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com>
In-Reply-To: <200806220246.58958.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806221737.54413.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common_64.c |    6 ------
 arch/x86/kernel/setup.c         |    6 ++++++
 arch/x86/kernel/setup_32.c      |    6 ------
 3 files changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -421,12 +421,6 @@ static __init int setup_disablecpuid(cha
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
-struct boot_params boot_params;
-#endif
-
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 struct x8664_pda **_cpu_pda __read_mostly;
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -15,6 +15,12 @@
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
 
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
+
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -161,12 +161,6 @@ unsigned long saved_video_mode;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
-struct boot_params boot_params;
-#endif
-
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
 #ifdef CONFIG_EDD_MODULE
