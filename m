Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYCSTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYCSTlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYCSTam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbYCSTaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:39 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 07/79] [PATCH] provide specialized identification routines for x86_64
Date: Wed, 19 Mar 2008 14:25:02 -0300
Message-Id: <1205947607406-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476032561-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

provide two specialized identify_secondary_cpu() and identify_boot_cpu()
routines for x86_64. Although not strictly needed, they are functionally
correct, and will ease integration with i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/setup_64.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 089ce10..352aa23 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1051,14 +1051,24 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 	select_idle_routine(c);
 
-	if (c != &boot_cpu_data)
-		mtrr_ap_init();
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
 
 }
 
+void __cpuinit identify_boot_cpu(void)
+{
+	identify_cpu(&boot_cpu_data);
+}
+
+void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+{
+	BUG_ON(c == &boot_cpu_data);
+	identify_cpu(c);
+	mtrr_ap_init();
+}
+
 static __init int setup_noclflush(char *arg)
 {
 	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
-- 
1.5.0.6

