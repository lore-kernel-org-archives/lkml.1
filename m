Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYIHMms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYIHMms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYIHMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:42:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34933 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYIHMm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:42:27 -0400
X-IronPort-AV: E=Sophos;i="4.32,358,1217822400"; 
   d="scan'208";a="18945368"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] Xen: Make CPU hotplug functions static
Date: Mon,  8 Sep 2008 13:43:34 +0100
Message-Id: <1220877814-4934-2-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220877814-4934-1-git-send-email-alex.nixon@citrix.com>
References: <>
 <1220877814-4934-1-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 08 Sep 2008 12:42:26.0407 (UTC) FILETIME=[5921BF70:01C911B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for these functions to be accessed from outside of xen/smp.c

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/smp.c     |   12 ++++++------
 arch/x86/xen/xen-ops.h |    4 ----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index bf51a46..d77da61 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -333,7 +333,7 @@ static void xen_smp_cpus_done(unsigned int max_cpus)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-int xen_cpu_disable(void)
+static int xen_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
 	if (cpu == 0)
@@ -345,7 +345,7 @@ int xen_cpu_disable(void)
 	return 0;
 }
 
-void xen_cpu_die(unsigned int cpu)
+static void xen_cpu_die(unsigned int cpu)
 {
 	while (HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
 		current->state = TASK_UNINTERRUPTIBLE;
@@ -362,7 +362,7 @@ void xen_cpu_die(unsigned int cpu)
 		alternatives_smp_switch(0);
 }
 
-void xen_play_dead(void)
+static void xen_play_dead(void)
 {
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
@@ -370,17 +370,17 @@ void xen_play_dead(void)
 }
 
 #else /* !CONFIG_HOTPLUG_CPU */
-int xen_cpu_disable(void)
+static int xen_cpu_disable(void)
 {
 	return -ENOSYS;
 }
 
-void xen_cpu_die(unsigned int cpu)
+static void xen_cpu_die(unsigned int cpu)
 {
 	BUG();
 }
 
-void xen_play_dead(void)
+static void xen_play_dead(void)
 {
 	BUG();
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 8dbd97f..d7422dc 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -51,10 +51,6 @@ void xen_mark_init_mm_pinned(void);
 
 void __init xen_setup_vcpu_info_placement(void);
 
-void xen_play_dead(void);
-void xen_cpu_die(unsigned int cpu);
-int xen_cpu_disable(void);
-
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
-- 
1.5.4.3

