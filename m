Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZELHPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZELHPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZELHP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:15:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZELHPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:15:25 -0400
Subject: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 May 2009 12:44:42 +0530
Message-Id: <1242112482.3283.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are 2 patches for adding new field extended_cpuid_level, please
choose PATCH whichever is more appropriate:

PATCH 1:
Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo

extended_cpuid_level also gives useful information like cpuid_level
and very useful for AMD processors.

Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 523bf39..1279e16 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -39,6 +39,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu\t\t: %s\n"
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
+		   "ext cpuid level\t: 0x%x\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
 		   c->hlt_works_ok ? "no" : "yes",
@@ -47,6 +48,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->hard_math ? "yes" : "no",
 		   fpu_exception ? "yes" : "no",
 		   c->cpuid_level,
+		   c->extended_cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
 #else
@@ -56,8 +58,10 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu\t\t: yes\n"
 		   "fpu_exception\t: yes\n"
 		   "cpuid level\t: %d\n"
+		   "ext cpuid level\t: 0x%x\n"
 		   "wp\t\t: yes\n",
-		   c->cpuid_level);
+		   c->cpuid_level,
+		   c->extended_cpuid_level);
 }
 #endif
 
-- 
1.6.0.6


OR

PATCH 2:
Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo

extended_cpuid_level also gives useful information like cpuid_level
and very useful for AMD processors.

Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 523bf39..a965bf7 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -102,7 +102,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	show_cpuinfo_core(m, c, cpu);
 	show_cpuinfo_misc(m, c);
 
-	seq_printf(m, "flags\t\t:");
+	seq_printf(m, "ext cpuid level\t: 0x%x\n"
+		   "flags\t\t:",
+		   c->extended_cpuid_level);
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
-- 
1.6.0.6


