Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0AUQl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0AUQl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691Ab0AUQlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:25 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38400 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0AUQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:23 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] x86, smp: Add wbinvd_on_all_cpus helper
Date: Thu, 21 Jan 2010 17:41:29 +0100
Message-Id: <1264092093-13739-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/smp.h |    2 ++
 arch/x86/lib/smp.c         |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 090146e..3c8ed3a 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -139,6 +139,7 @@ void play_dead_common(void);
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 void wbinvd_on_cpu(int cpu);
+int wbinvd_on_all_cpus(void);
 
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
@@ -150,6 +151,7 @@ static inline int num_booting_cpus(void)
 }
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)	wbinvd()
+#define wbinvd_on_all_cpus()	wbinvd()
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/lib/smp.c b/arch/x86/lib/smp.c
index 408c3b7..38f92b0 100644
--- a/arch/x86/lib/smp.c
+++ b/arch/x86/lib/smp.c
@@ -209,3 +209,9 @@ void wbinvd_on_cpu(int cpu)
 	smp_call_function_single(cpu, native_wbinvd, NULL, 1);
 }
 EXPORT_SYMBOL(wbinvd_on_cpu);
+
+int wbinvd_on_all_cpus(void)
+{
+	return on_each_cpu(native_wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
1.6.6

