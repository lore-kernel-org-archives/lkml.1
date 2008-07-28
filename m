Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYG1LBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYG1LBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYG1LA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:00:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:11712 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYG1LA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=I5jynxPLDctJXkTrwESw55Sbf40TFbgQUw/sVZe7KnPp6Z3s+04m+5JfjOlqbrQ2TJ
         +F/RsU2cNzTuUPFwVnKRxHKK1u3dCFgJIWwSxCMF62DxgLwiSpJhooGLsfJxLlmSC3/d
         KiHuK3jJ/p0r5INdUuXAOLVlwUyd4jecdgzp0=
Date: Mon, 28 Jul 2008 13:00:49 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Subject: Subject: [PATCH] x86: Coding style fixes to 
 arch/x86/kernel/cpu/cpufreq/elanfreq.c
Message-ID: <20080728130049.240db1ff@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciao Ingo,

Before:
total: 15 errors, 10 warnings, 308 lines checked

After:
total: 0 errors, 4 warnings, 308 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/elafreq.o.*
add1d36c2f077c5aab7682e8642a9f34  /tmp/elafreq.o.after
add1d36c2f077c5aab7682e8642a9f34  /tmp/elafreq.o.before

paolo@paolo-desktop:~/linux.trees.git$ size /tmp/elafreq.o.*
   text    data     bss     dec     hex filename
    934     270       4    1208     4b8 /tmp/elafreq.o.after
    934     270       4    1208     4b8 /tmp/elafreq.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/elanfreq.c |   42 ++++++++++++++++----------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/elanfreq.c b/arch/x86/kernel/cpu/cpufreq/elanfreq.c
index 94619c2..515d10b 100644
--- a/arch/x86/kernel/cpu/cpufreq/elanfreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/elanfreq.c
@@ -25,8 +25,8 @@
 #include <linux/cpufreq.h>
 
 #include <asm/msr.h>
-#include <asm/timex.h>
-#include <asm/io.h>
+#include <linux/timex.h>
+#include <linux/io.h>
 
 #define REG_CSCIR 0x22		/* Chip Setup and Control Index Register    */
 #define REG_CSCDR 0x23		/* Chip Setup and Control Data  Register    */
@@ -82,7 +82,7 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
 	u8 clockspeed_reg;    /* Clock Speed Register */
 
 	local_irq_disable();
-	outb_p(0x80,REG_CSCIR);
+	outb_p(0x80, REG_CSCIR);
 	clockspeed_reg = inb_p(REG_CSCDR);
 	local_irq_enable();
 
@@ -98,10 +98,10 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
 	}
 
 	/* 33 MHz is not 32 MHz... */
-	if ((clockspeed_reg & 0xE0)==0xA0)
+	if ((clockspeed_reg & 0xE0) == 0xA0)
 		return 33000;
 
-	return ((1<<((clockspeed_reg & 0xE0) >> 5)) * 1000);
+	return (1<<((clockspeed_reg & 0xE0) >> 5)) * 1000;
 }
 
 
@@ -117,7 +117,7 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
  *	There is no return value.
  */
 
-static void elanfreq_set_cpu_state (unsigned int state)
+static void elanfreq_set_cpu_state(unsigned int state)
 {
 	struct cpufreq_freqs    freqs;
 
@@ -144,20 +144,20 @@ static void elanfreq_set_cpu_state (unsigned int state)
 	 */
 
 	local_irq_disable();
-	outb_p(0x40,REG_CSCIR);		/* Disable hyperspeed mode */
-	outb_p(0x00,REG_CSCDR);
+	outb_p(0x40, REG_CSCIR);		/* Disable hyperspeed mode */
+	outb_p(0x00, REG_CSCDR);
 	local_irq_enable();		/* wait till internal pipelines and */
 	udelay(1000);			/* buffers have cleaned up          */
 
 	local_irq_disable();
 
 	/* now, set the CPU clock speed register (0x80) */
-	outb_p(0x80,REG_CSCIR);
-	outb_p(elan_multiplier[state].val80h,REG_CSCDR);
+	outb_p(0x80, REG_CSCIR);
+	outb_p(elan_multiplier[state].val80h, REG_CSCDR);
 
 	/* now, the hyperspeed bit in PMU Force Mode Register (0x40) */
-	outb_p(0x40,REG_CSCIR);
-	outb_p(elan_multiplier[state].val40h,REG_CSCDR);
+	outb_p(0x40, REG_CSCIR);
+	outb_p(elan_multiplier[state].val40h, REG_CSCDR);
 	udelay(10000);
 	local_irq_enable();
 
@@ -173,12 +173,12 @@ static void elanfreq_set_cpu_state (unsigned int state)
  *	for the hardware supported by the driver.
  */
 
-static int elanfreq_verify (struct cpufreq_policy *policy)
+static int elanfreq_verify(struct cpufreq_policy *policy)
 {
 	return cpufreq_frequency_table_verify(policy, &elanfreq_table[0]);
 }
 
-static int elanfreq_target (struct cpufreq_policy *policy,
+static int elanfreq_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
 {
@@ -205,7 +205,7 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* capability check */
 	if ((c->x86_vendor != X86_VENDOR_AMD) ||
-	    (c->x86 != 4) || (c->x86_model!=10))
+	    (c->x86 != 4) || (c->x86_model != 10))
 		return -ENODEV;
 
 	/* max freq */
@@ -213,7 +213,7 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 		max_freq = elanfreq_get_cpu_frequency(0);
 
 	/* table init */
-	for (i=0; (elanfreq_table[i].frequency != CPUFREQ_TABLE_END); i++) {
+	for (i = 0; (elanfreq_table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (elanfreq_table[i].frequency > max_freq)
 			elanfreq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
 	}
@@ -224,7 +224,7 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 
 	result = cpufreq_frequency_table_cpuinfo(policy, elanfreq_table);
 	if (result)
-		return (result);
+		return result;
 
 	cpufreq_frequency_table_get_attr(elanfreq_table, policy->cpu);
 	return 0;
@@ -260,7 +260,7 @@ __setup("elanfreq=", elanfreq_setup);
 #endif
 
 
-static struct freq_attr* elanfreq_attr[] = {
+static struct freq_attr *elanfreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
 	NULL,
 };
@@ -284,9 +284,9 @@ static int __init elanfreq_init(void)
 
 	/* Test if we have the right hardware */
 	if ((c->x86_vendor != X86_VENDOR_AMD) ||
-		(c->x86 != 4) || (c->x86_model!=10)) {
+		(c->x86 != 4) || (c->x86_model != 10)) {
 		printk(KERN_INFO "elanfreq: error: no Elan processor found!\n");
-                return -ENODEV;
+		return -ENODEV;
 	}
 	return cpufreq_register_driver(&elanfreq_driver);
 }
@@ -298,7 +298,7 @@ static void __exit elanfreq_exit(void)
 }
 
 
-module_param (max_freq, int, 0444);
+module_param(max_freq, int, 0444);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Schwebel <r.schwebel@pengutronix.de>, Sven Geggus <sven@geggus.net>");
-- 
1.5.6.rc1.21.g03300

