Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXEVP21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXEVP21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760071AbXEVPTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:42 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4997
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965748AbXEVPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:16 -0400
Message-Id: <20070522141251.350437872@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:47 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 06/33] xen: paravirt: make siblingmap functions visible
Content-Disposition: inline; filename=paravirt-unstatic-siblingmaps.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirt implementations need to set the sibling map on new cpus.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/i386/kernel/smpboot.c |    6 ++----
 include/asm-i386/smp.h     |    3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

===================================================================
--- a/include/asm-i386/smp.h
+++ b/include/asm-i386/smp.h
@@ -43,9 +43,12 @@ extern u8 x86_cpu_to_apicid[];
 
 #define cpu_physical_id(cpu)	x86_cpu_to_apicid[cpu]
 
+extern void set_cpu_sibling_map(int cpu);
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
+extern void remove_siblinginfo(int cpu);
 #endif
 
 struct smp_ops
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -308,8 +308,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-static inline void
-set_cpu_sibling_map(int cpu)
+void set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
@@ -1157,8 +1156,7 @@ void __init native_smp_prepare_boot_cpu(
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void
-remove_siblinginfo(int cpu)
+void remove_siblinginfo(int cpu)
 {
 	int sibling;
 	struct cpuinfo_x86 *c = cpu_data;

-- 

