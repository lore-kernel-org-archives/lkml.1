Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZC3QmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZC3QmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZC3Ql7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:41:59 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39097 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZC3Ql7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:41:59 -0400
Date: Mon, 30 Mar 2009 16:41:53 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch] P4 clock mod: recalibrate_cpu_khz on ia32 only
Message-ID: <20090330164153.GA13777@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

I just triggered the following compile error with an old .config on
x86_64, (latest git):

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
arch/x86/kernel/cpu/cpufreq/p4-clockmod.c: In function ‘cpufreq_p4_cpu_init’:
arch/x86/kernel/cpu/cpufreq/p4-clockmod.c:232: error: implicit declaration of function ‘recalibrate_cpu_khz’
make[3]: *** [arch/x86/kernel/cpu/cpufreq/p4-clockmod.o] Error 1
make[2]: *** [arch/x86/kernel/cpu/cpufreq] Error 2
make[1]: *** [arch/x86/kernel/cpu] Error 2
make: *** [arch/x86/kernel] Error 2

The attached patch calls recalibrate_cpu_khz on ia32 only

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>


diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 41ed949..88be236 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -229,7 +229,9 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	    c->x86_model < 2) {
 		/* switch to maximum frequency and measure result */
 		cpufreq_p4_setdc(policy->cpu, DC_DISABLE);
+#ifdef CONFIG_X86_32
 		recalibrate_cpu_khz();
+#endif
 	}
 	/* get max frequency */
 	stock_freq = cpufreq_p4_get_frequency(c);
