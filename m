Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYCCRPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYCCRPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbYCCROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434AbYCCROF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:05 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 04/52] define smp_ops in common header
Date: Mon,  3 Mar 2008 14:12:32 -0300
Message-Id: <1204564400-17636-5-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-4-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 will benefit from it
Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h    |   14 ++++++++++++++
 include/asm-x86/smp_32.h |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index c130a87..d11b92b 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -8,6 +8,20 @@ extern cpumask_t cpu_callout_map;
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
+struct smp_ops {
+	void (*smp_prepare_boot_cpu)(void);
+	void (*smp_prepare_cpus)(unsigned max_cpus);
+	int (*cpu_up)(unsigned cpu);
+	void (*smp_cpus_done)(unsigned max_cpus);
+
+	void (*smp_send_stop)(void);
+	void (*smp_send_reschedule)(int cpu);
+	int (*smp_call_function_mask)(cpumask_t mask,
+				      void (*func)(void *info), void *info,
+				      int wait);
+};
+
+
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
 #else
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 9a4057d..72faad6 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -38,20 +38,6 @@ extern void remove_siblinginfo(int cpu);
 /* Globals due to paravirt */
 extern void set_cpu_sibling_map(int cpu);
 
-struct smp_ops
-{
-	void (*smp_prepare_boot_cpu)(void);
-	void (*smp_prepare_cpus)(unsigned max_cpus);
-	int (*cpu_up)(unsigned cpu);
-	void (*smp_cpus_done)(unsigned max_cpus);
-
-	void (*smp_send_stop)(void);
-	void (*smp_send_reschedule)(int cpu);
-	int (*smp_call_function_mask)(cpumask_t mask,
-				      void (*func)(void *info), void *info,
-				      int wait);
-};
-
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
-- 
1.5.0.6

