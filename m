Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYCCRWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYCCRWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYCCRP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759638AbYCCRPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:23 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 33/52] move hotplug related extern definitions to smp.h
Date: Mon,  3 Mar 2008 14:13:01 -0300
Message-Id: <1204564400-17636-34-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-33-git-send-email-gcosta@redhat.com>
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
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

definitions that are inside CONFIG_HOTPLUG_CPU in
the arch-specific smp*.h files are moved to common
header

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |    6 ++++++
 include/asm-x86/smp_32.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 1b4481a..c800b81 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -80,6 +80,12 @@ extern void prefill_possible_map(void);
 # include "smp_64.h"
 #endif
 
+#ifdef CONFIG_HOTPLUG_CPU
+extern void cpu_exit_clear(void);
+extern void cpu_uninit(void);
+extern void remove_siblinginfo(int cpu);
+#endif
+
 extern void smp_alloc_memory(void);
 extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 76247a9..0b25134 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -29,12 +29,6 @@ DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 
-#ifdef CONFIG_HOTPLUG_CPU
-extern void cpu_exit_clear(void);
-extern void cpu_uninit(void);
-extern void remove_siblinginfo(int cpu);
-#endif
-
 #ifdef CONFIG_SMP
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
-- 
1.5.0.6

