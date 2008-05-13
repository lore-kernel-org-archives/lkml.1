Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYEMQMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYEMQMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYEMQL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:11:58 -0400
Received: from yugo.dsd.sztaki.hu ([195.111.2.114]:39938 "EHLO
	yugo.frugalware.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797AbYEMQL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:11:56 -0400
From: Miklos Vajna <vmiklos@frugalware.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: janitor work in bugs.c
Date: Tue, 13 May 2008 18:11:49 +0200
Message-Id: <1210695109-31727-1-git-send-email-vmiklos@frugalware.org>
X-Mailer: git-send-email 1.5.5.1.211.g65ea3.dirty
In-Reply-To: <20080513124454.GF14973@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just moved trailing statements to the next line, removed space before
open/close parenthesis, wrapped long lines.

Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>
---

On Tue, May 13, 2008 at 02:44:54PM +0200, Ingo Molnar <mingo@elte.hu> wrote:
> generally we do not break up strings mid-stream - that makes grepping
> harder. _At most_ we do something like:
>
>               printk(KERN_EMERG
>                      "No coprocessor found and no math emulation present.\n");

Given that it's still longer than 80 chars this way I just left it untouched.

> > -/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
> > +/* trap_init() enabled FXSR and company _before_ testing for FP problems
> > + * here. */
>
> that's not the proper multi-line comment style, this would be:
>
>   /*
>    * trap_init() enabled FXSR and company _before_ testing for
>    * FP problems here.
>    */
>
> same for other places in this patch and for your next patch.

Ok, corrected.

 arch/x86/kernel/cpu/bugs.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 170d2f5..3278c6e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,10 @@ static void __init check_fpu(void)
 		return;
 	}
 
-/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
+/* 
+ * trap_init() enabled FXSR and company _before_ testing for FP problems
+ * here.
+ */
 	/* Test for the divl bug.. */
 	__asm__("fninit\n\t"
 		"fldl %1\n\t"
@@ -108,10 +111,15 @@ static void __init check_popad(void)
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
 
@@ -137,7 +145,8 @@ static void __init check_config(void)
  * i486+ only features! (WP works in supervisor mode and the
  * new "invlpg" and "bswap" instructions)
  */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
+#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || \
+	defined(CONFIG_X86_BSWAP)
 	if (boot_cpu_data.x86 == 3)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
 #endif
@@ -170,6 +179,7 @@ void __init check_bugs(void)
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

