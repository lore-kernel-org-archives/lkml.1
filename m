Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYG1TIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYG1TIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYG1TIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:08:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:3590 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYG1TIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=JP/jglhVsWGsHpcFOx20x/1wAVZ5QzoBcsxLbqz9jVhTlF8NDOekaEiQDbQQQynEeu
         5P+am3FOzDEbZmDmAakYo7pztHWmQD4I/y1B26YOrODw0D625cCztEjxa5TDNxiPYdG4
         KoVg9udutnxyPkJPuDUE78shZOobVIGF2xgNE=
Date: Mon, 28 Jul 2008 21:08:16 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>
Subject: [PATCH] x86: Coding style fixes to
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c
Message-ID: <20080728210816.4989c3f0@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciao Ingo, all,

Before:
total: 11 errors, 15 warnings, 255 lines checked

After:
total: 0 errors, 6 warnings, 254 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/powernow-k6.o.*
476932f5e1ffe365db9d1dfb3f860369  /tmp/powernow-k6.o.after
476932f5e1ffe365db9d1dfb3f860369  /tmp/powernow-k6.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c |   41 ++++++++++++++---------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index eb9b62b..b5ced80 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -15,12 +15,11 @@
 #include <linux/slab.h>
 
 #include <asm/msr.h>
-#include <asm/timex.h>
-#include <asm/io.h>
+#include <linux/timex.h>
+#include <linux/io.h>
 
-
-#define POWERNOW_IOPORT 0xfff0         /* it doesn't matter where, as long
-					  as it is unused */
+#define POWERNOW_IOPORT 0xfff0          /* it doesn't matter where, as long
+					   as it is unused */
 
 static unsigned int                     busfreq;   /* FSB, in 10 kHz */
 static unsigned int                     max_multiplier;
@@ -53,7 +52,7 @@ static int powernow_k6_get_cpu_multiplier(void)
 
 	msrval = POWERNOW_IOPORT + 0x1;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
-	invalue=inl(POWERNOW_IOPORT + 0x8);
+	invalue = inl(POWERNOW_IOPORT + 0x8);
 	msrval = POWERNOW_IOPORT + 0x0;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
@@ -67,9 +66,9 @@ static int powernow_k6_get_cpu_multiplier(void)
  *
  *   Tries to change the PowerNow! multiplier
  */
-static void powernow_k6_set_state (unsigned int best_i)
+static void powernow_k6_set_state(unsigned int best_i)
 {
-	unsigned long           outvalue=0, invalue=0;
+	unsigned long           outvalue = 0, invalue = 0;
 	unsigned long           msrval;
 	struct cpufreq_freqs    freqs;
 
@@ -90,10 +89,10 @@ static void powernow_k6_set_state (unsigned int best_i)
 
 	msrval = POWERNOW_IOPORT + 0x1;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
-	invalue=inl(POWERNOW_IOPORT + 0x8);
+	invalue = inl(POWERNOW_IOPORT + 0x8);
 	invalue = invalue & 0xf;
 	outvalue = outvalue | invalue;
-	outl(outvalue ,(POWERNOW_IOPORT + 0x8));
+	outl(outvalue , (POWERNOW_IOPORT + 0x8));
 	msrval = POWERNOW_IOPORT + 0x0;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
@@ -124,7 +123,7 @@ static int powernow_k6_verify(struct cpufreq_policy *policy)
  *
  * sets a new CPUFreq policy
  */
-static int powernow_k6_target (struct cpufreq_policy *policy,
+static int powernow_k6_target(struct cpufreq_policy *policy,
 			       unsigned int target_freq,
 			       unsigned int relation)
 {
@@ -152,7 +151,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	busfreq = cpu_khz / max_multiplier;
 
 	/* table init */
-	for (i=0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
+	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (clock_ratio[i].index > max_multiplier)
 			clock_ratio[i].frequency = CPUFREQ_ENTRY_INVALID;
 		else
@@ -165,7 +164,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
 	if (result)
-		return (result);
+		return result;
 
 	cpufreq_frequency_table_get_attr(clock_ratio, policy->cpu);
 
@@ -176,8 +175,8 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
 {
 	unsigned int i;
-	for (i=0; i<8; i++) {
-		if (i==max_multiplier)
+	for (i = 0; i < 8; i++) {
+		if (i == max_multiplier)
 			powernow_k6_set_state(i);
 	}
 	cpufreq_frequency_table_put_attr(policy->cpu);
@@ -189,7 +188,7 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 	return busfreq * powernow_k6_get_cpu_multiplier();
 }
 
-static struct freq_attr* powernow_k6_attr[] = {
+static struct freq_attr *powernow_k6_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
 	NULL,
 };
@@ -227,7 +226,7 @@ static int __init powernow_k6_init(void)
 	}
 
 	if (cpufreq_register_driver(&powernow_k6_driver)) {
-		release_region (POWERNOW_IOPORT, 16);
+		release_region(POWERNOW_IOPORT, 16);
 		return -EINVAL;
 	}
 
@@ -243,13 +242,13 @@ static int __init powernow_k6_init(void)
 static void __exit powernow_k6_exit(void)
 {
 	cpufreq_unregister_driver(&powernow_k6_driver);
-	release_region (POWERNOW_IOPORT, 16);
+	release_region(POWERNOW_IOPORT, 16);
 }
 
 
-MODULE_AUTHOR ("Arjan van de Ven <arjanv@redhat.com>, Dave Jones <davej@codemonkey.org.uk>, Dominik Brodowski <linux@brodo.de>");
-MODULE_DESCRIPTION ("PowerNow! driver for AMD K6-2+ / K6-3+ processors.");
-MODULE_LICENSE ("GPL");
+MODULE_AUTHOR("Arjan van de Ven <arjanv@redhat.com>, Dave Jones <davej@codemonkey.org.uk>, Dominik Brodowski <linux@brodo.de>");
+MODULE_DESCRIPTION("PowerNow! driver for AMD K6-2+ / K6-3+ processors.");
+MODULE_LICENSE("GPL");
 
 module_init(powernow_k6_init);
 module_exit(powernow_k6_exit);
-- 
1.5.6.rc1.21.g03300

