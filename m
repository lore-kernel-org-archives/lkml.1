Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYCCRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYCCRSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbYCCROd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbYCCROc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:32 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 12/52] move disabled_cpus to common header
Date: Mon,  3 Mar 2008 14:12:40 -0300
Message-Id: <1204564400-17636-13-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-12-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disabled_cpus is (up to now) a x86_64-only contruction.
But it's extern declaration can be moved to common header anyway

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |    3 +++
 include/asm-x86/smp_64.h |    1 -
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 9620165..be8a511 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_SMP_H_
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
+#include <linux/init.h>
 
 extern cpumask_t cpu_callout_map;
 
@@ -60,6 +61,8 @@ void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
+
+extern unsigned disabled_cpus;
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index b920458..c7a00ca 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -44,7 +44,6 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
-extern unsigned __cpuinitdata disabled_cpus;
 
 #define raw_smp_processor_id()	read_pda(cpunumber)
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
-- 
1.5.0.6

