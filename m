Return-Path: <linux-kernel-owner+w=401wt.eu-S1751699AbZEJHrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbZEJHrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZEJHqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:46:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:38366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZEJHqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:46:54 -0400
Subject: [PATCH -tip] x86: cpu/proc.c grouping of cpuid in /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 13:10:17 +0530
Message-Id: <1241941217.3200.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unification of cpuid_level.
Also added extended_cpuid_level to make it complete.

So cpuid* and cpufeature flag come in same group and /proc/cpuinfo
looks like on AMD box:

cpuid level     : 1
ext cpuid level : 0x8000001a
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 523bf39..f63e968 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -38,7 +38,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "coma_bug\t: %s\n"
 		   "fpu\t\t: %s\n"
 		   "fpu_exception\t: %s\n"
-		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
 		   c->hlt_works_ok ? "no" : "yes",
@@ -46,7 +45,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   fpu_exception ? "yes" : "no",
-		   c->cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
 #else
@@ -55,9 +53,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 	seq_printf(m,
 		   "fpu\t\t: yes\n"
 		   "fpu_exception\t: yes\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: yes\n",
-		   c->cpuid_level);
+		   "wp\t\t: yes\n");
 }
 #endif
 
@@ -102,7 +98,11 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	show_cpuinfo_core(m, c, cpu);
 	show_cpuinfo_misc(m, c);
 
-	seq_printf(m, "flags\t\t:");
+	seq_printf(m, "cpuid level\t: %d\n"
+		   "ext cpuid level\t: 0x%x\n"
+		   "flags\t\t:",
+		   c->cpuid_level,
+		   c->extended_cpuid_level);
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
-- 
1.6.0.6



