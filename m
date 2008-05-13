Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYEMLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYEMLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYEMLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:43:21 -0400
Received: from yugo.dsd.sztaki.hu ([195.111.2.114]:52986 "EHLO
	yugo.frugalware.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYEMLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:43:20 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 07:43:20 EDT
From: Miklos Vajna <vmiklos@frugalware.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86: janitor work in bugs.c
Date: Tue, 13 May 2008 13:35:26 +0200
Message-Id: <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
X-Mailer: git-send-email 1.5.5.1.211.g65ea3.dirty
In-Reply-To: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
In-Reply-To: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just moved trailing statements to the next line, removed space before
open/close parenthesis, wrapped long lines.

Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>
---
 arch/x86/kernel/cpu/bugs.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 170d2f5..1fa9809 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -52,14 +52,16 @@ static void __init check_fpu(void)
 {
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
-		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
+		printk(KERN_EMERG "No coprocessor found and no math "
+			"emulation present.\n");
 		printk(KERN_EMERG "Giving up.\n");
 		for (;;) ;
 #endif
 		return;
 	}
 
-/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
+/* trap_init() enabled FXSR and company _before_ testing for FP problems
+ * here. */
 	/* Test for the divl bug.. */
 	__asm__("fninit\n\t"
 		"fldl %1\n\t"
@@ -108,10 +110,13 @@ static void __init check_popad(void)
 	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
 	  : "=&a" (res)
 	  : "d" (inp)
-	  : "ecx", "edi" );
-	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
-	if (res != 12345678) printk( "Buggy.\n" );
-		        else printk( "OK.\n" );
+	  : "ecx", "edi");
+	/* If this fails, it means that any user program may lock the
+	 * CPU hard. Too bad. */
+	if (res != 12345678)
+		printk("Buggy.\n");
+	else
+		printk("OK.\n");
 #endif
 }
 
@@ -137,7 +142,8 @@ static void __init check_config(void)
  * i486+ only features! (WP works in supervisor mode and the
  * new "invlpg" and "bswap" instructions)
  */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
+#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || \
+	defined(CONFIG_X86_BSWAP)
 	if (boot_cpu_data.x86 == 3)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
 #endif
@@ -154,7 +160,8 @@ static void __init check_config(void)
 	    && boot_cpu_data.x86 == 5
 	    && boot_cpu_data.x86_model == 2
 	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
-		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
+		panic("Kernel compiled for PMMX+, assumes a local APIC "
+		    "without the read-before-write bug!");
 #endif
 }
 
@@ -170,6 +177,7 @@ void __init check_bugs(void)
 	check_fpu();
 	check_hlt();
 	check_popad();
-	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
+	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 :
+	    boot_cpu_data.x86);
 	alternative_instructions();
 }
-- 
1.5.4.3

