Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYEQUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYEQUsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbYEQUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:48:14 -0400
Received: from yugo.dsd.sztaki.hu ([195.111.2.114]:52291 "EHLO
	yugo.frugalware.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbYEQUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:48:13 -0400
From: Miklos Vajna <vmiklos@frugalware.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: janitor work in bugs.c
Date: Sat, 17 May 2008 22:48:13 +0200
Message-Id: <1211057293-19497-1-git-send-email-vmiklos@frugalware.org>
X-Mailer: git-send-email 1.5.5.1.211.g65ea3.dirty
In-Reply-To: <20080516134858.GC28910@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just moved trailing statements to the next line, removed space before
open/close parenthesis, wrapped long lines.

Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>
---

On Fri, May 16, 2008 at 03:48:58PM +0200, Ingo Molnar <mingo@elte.hu> wrote:
> the two comments should be merged, somehow like this:

Merged.

> or just do:
>
> > +   init_utsname()->machine[1] =
> > +            '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);

OK, I did so.

 arch/x86/kernel/cpu/bugs.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 170d2f5..12c27c8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,8 +59,12 @@ static void __init check_fpu(void)
 		return;
 	}
 
-/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
-	/* Test for the divl bug.. */
+	/* 
+	 * trap_init() enabled FXSR and company _before_ testing for FP
+	 * problems here.
+	 *
+	 * Test for the divl bug..
+	 */
 	__asm__("fninit\n\t"
 		"fldl %1\n\t"
 		"fdivl %2\n\t"
@@ -108,10 +112,15 @@ static void __init check_popad(void)
 	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
 	  : "=&a" (res)
 	  : "d" (inp)
-	  : "ecx", "edi" );
-	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
-	if (res != 12345678) printk( "Buggy.\n" );
-		        else printk( "OK.\n" );
+	  : "ecx", "edi");
+	/* 
+	 * If this fails, it means that any user program may lock the
+	 * CPU hard. Too bad.
+	 */
+	if (res != 12345678)
+		printk("Buggy.\n");
+	else
+		printk("OK.\n");
 #endif
 }
 
@@ -137,7 +146,8 @@ static void __init check_config(void)
  * i486+ only features! (WP works in supervisor mode and the
  * new "invlpg" and "bswap" instructions)
  */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
+#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || \
+	defined(CONFIG_X86_BSWAP)
 	if (boot_cpu_data.x86 == 3)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
 #endif
@@ -170,6 +180,7 @@ void __init check_bugs(void)
 	check_fpu();
 	check_hlt();
 	check_popad();
-	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
+	init_utsname()->machine[1] =
+		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
 }
-- 
1.5.4.3

