Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYCCRX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYCCRX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYCCRPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbYCCRP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:27 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 31/52] make set_cpu_sibling_map nonstatic
Date: Mon,  3 Mar 2008 14:12:59 -0300
Message-Id: <1204564400-17636-32-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-31-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And move its extern definition to smp.h, the common header

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/smp.h        |    3 +++
 include/asm-x86/smp_32.h     |    3 ---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index c51279f..1e8f00a 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -228,7 +228,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-static inline void set_cpu_sibling_map(int cpu)
+void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 2ab8ed4..1b4481a 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -22,6 +22,9 @@ struct smp_ops {
 				      int wait);
 };
 
+/* Globals due to paravirt */
+extern void set_cpu_sibling_map(int cpu);
+
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 29f6195..76247a9 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -35,9 +35,6 @@ extern void cpu_uninit(void);
 extern void remove_siblinginfo(int cpu);
 #endif
 
-/* Globals due to paravirt */
-extern void set_cpu_sibling_map(int cpu);
-
 #ifdef CONFIG_SMP
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
-- 
1.5.0.6

