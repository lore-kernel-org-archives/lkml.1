Return-Path: <linux-kernel-owner+w=401wt.eu-S936275AbYBVWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936275AbYBVWOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbYBVWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761198AbYBVWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Mlzfv/4PMddxCkZ2HCzC6MMDXAhHIxaOFkj23ZtoDfpXlTtVHx8RAJk5P4gvT+txOR3zNriAu9ympIB9bC5EP1fl83fh2LmSVoxxPVLLoQqRGkc7DMb0hwxyq/6QVM5XJb9h0bSIEAix0w8gLXrLhWb0ATWFle8ngFjOGtnfiXM=
Date: Fri, 22 Feb 2008 23:10:28 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/transmeta.c
Message-ID: <20080222231028.5478fef8@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/transmeta.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index c2d168e..daee21d 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -18,8 +18,8 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
 	cpu_rev = 0;
-	if ( max >= 0x80860001 ) {
-		cpuid(0x80860001, &dummy, &cpu_rev, &cpu_freq, &cpu_flags); 
+	if (max >= 0x80860001) {
+		cpuid(0x80860001, &dummy, &cpu_rev, &cpu_freq, &cpu_flags);
 		if (cpu_rev != 0x02000000) {
 			printk(KERN_INFO "CPU: Processor revision %u.%u.%u.%u, %u MHz\n",
 				(cpu_rev >> 24) & 0xff,
@@ -29,7 +29,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 				cpu_freq);
 		}
 	}
-	if ( max >= 0x80860002 ) {
+	if (max >= 0x80860002) {
 		cpuid(0x80860002, &new_cpu_rev, &cms_rev1, &cms_rev2, &dummy);
 		if (cpu_rev == 0x02000000) {
 			printk(KERN_INFO "CPU: Processor revision %08X, %u MHz\n",
@@ -42,7 +42,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 		       cms_rev1 & 0xff,
 		       cms_rev2);
 	}
-	if ( max >= 0x80860006 ) {
+	if (max >= 0x80860006) {
 		cpuid(0x80860003,
 		      (void *)&cpu_info[0],
 		      (void *)&cpu_info[4],
@@ -75,22 +75,24 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 
 	/* All Transmeta CPUs have a constant TSC */
 	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
-	
+
 #ifdef CONFIG_SYSCTL
-	/* randomize_va_space slows us down enormously;
-	   it probably triggers retranslation of x86->native bytecode */
+	/*
+	 * randomize_va_space slows us down enormously;
+	 * it probably triggers retranslation of x86->native bytecode
+	 */
 	randomize_va_space = 0;
 #endif
 }
 
-static void __cpuinit transmeta_identify(struct cpuinfo_x86 * c)
+static void __cpuinit transmeta_identify(struct cpuinfo_x86 *c)
 {
 	u32 xlvl;
 
 	/* Transmeta-defined flags: level 0x80860001 */
 	xlvl = cpuid_eax(0x80860000);
-	if ( (xlvl & 0xffff0000) == 0x80860000 ) {
-		if (  xlvl >= 0x80860001 )
+	if ((xlvl & 0xffff0000) == 0x80860000) {
+		if (xlvl >= 0x80860001)
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 }
-- 
1.5.4.GIT

