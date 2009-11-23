Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZKWUG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZKWUG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZKWUG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:06:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:44909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbZKWUG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:06:58 -0500
Date: Mon, 23 Nov 2009 20:06:38 GMT
From: tip-bot for Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
In-Reply-To: <20091121130145.GA31357@liondog.tnic>
References: <20091121130145.GA31357@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, cpu: mv display_cacheinfo -> cpu_detect_cache_sizes
Message-ID: <tip-27c13ecec4d8856687b50b959e1146845b478f95@git.kernel.org>
Git-Commit-ID: 27c13ecec4d8856687b50b959e1146845b478f95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27c13ecec4d8856687b50b959e1146845b478f95
Gitweb:     http://git.kernel.org/tip/27c13ecec4d8856687b50b959e1146845b478f95
Author:     Borislav Petkov <petkovbb@googlemail.com>
AuthorDate: Sat, 21 Nov 2009 14:01:45 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Nov 2009 11:59:53 -0800

x86, cpu: mv display_cacheinfo -> cpu_detect_cache_sizes

display_cacheinfo() doesn't display anything anymore and it is used to
detect CPU cache sizes. Rename it accordingly.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
LKML-Reference: <20091121130145.GA31357@liondog.tnic>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c       |    2 +-
 arch/x86/kernel/cpu/centaur.c   |    2 +-
 arch/x86/kernel/cpu/common.c    |    4 ++--
 arch/x86/kernel/cpu/cpu.h       |    2 +-
 arch/x86/kernel/cpu/cyrix.c     |    2 +-
 arch/x86/kernel/cpu/transmeta.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..7128b37 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -535,7 +535,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008) {
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..e58d978 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -294,7 +294,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 61242a5..9bf845d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,7 +61,7 @@ void __init setup_cpu_local_masks(void)
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 #else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
@@ -383,7 +383,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6de9a90..3624e8a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -32,6 +32,6 @@ struct cpu_dev {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
-extern void display_cacheinfo(struct cpuinfo_x86 *c);
+extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 19807b8..4fbd384 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -373,7 +373,7 @@ static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
 	/* Handle the GX (Formally known as the GX2) */
 
 	if (c->x86 == 5 && c->x86_model == 5)
-		display_cacheinfo(c);
+		cpu_detect_cache_sizes(c);
 	else
 		init_cyrix(c);
 }
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index bb62b3e..2800074 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -26,7 +26,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 
 	early_init_transmeta(c);
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
