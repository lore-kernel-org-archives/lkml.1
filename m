Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYJUTKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYJUTKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYJUTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:09:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbYJUTJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:09:53 -0400
Date: Tue, 21 Oct 2008 14:09:51 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86: Use consistent names for region size and conherence id on x86 and ia64.
Message-ID: <20081021190951.GA51519@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use consistent names for region size and conherence id on x86 and ia64.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
The SGI xp drivers are used on both ia64 and x86.  Using the same
names (sn_coherency_id, sn_region_size) simplies the driver code.



 arch/x86/kernel/bios_uv.c        |    8 ++++----
 arch/x86/kernel/genx2apic_uv_x.c |    4 ++--
 include/asm-x86/uv/bios.h        |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-21 11:54:05.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-21 11:54:08.000000000 -0500
@@ -85,9 +85,9 @@ extern void uv_bios_init(void);
 
 extern int uv_type;
 extern long sn_partition_id;
-extern long uv_coherency_id;
-extern long uv_region_size;
-#define partition_coherence_id()	(uv_coherency_id)
+extern long sn_coherency_id;
+extern long sn_region_size;
+#define partition_coherence_id()	(sn_coherency_id)
 
 extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
 
Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-21 11:54:05.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-21 11:54:08.000000000 -0500
@@ -69,10 +69,10 @@ s64 uv_bios_call_reentrant(enum uv_bios_
 
 long sn_partition_id;
 EXPORT_SYMBOL_GPL(sn_partition_id);
-long uv_coherency_id;
-EXPORT_SYMBOL_GPL(uv_coherency_id);
-long uv_region_size;
-EXPORT_SYMBOL_GPL(uv_region_size);
+long sn_coherency_id;
+EXPORT_SYMBOL_GPL(sn_coherency_id);
+long sn_region_size;
+EXPORT_SYMBOL_GPL(sn_region_size);
 int uv_type;
 
 
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-10-21 11:54:05.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-10-21 11:54:20.000000000 -0500
@@ -429,7 +429,7 @@ void __init uv_system_init(void)
 
 	uv_bios_init();
 	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
-			    &uv_coherency_id, &uv_region_size);
+			    &sn_coherency_id, &sn_region_size);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -451,7 +451,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
-		uv_cpu_hub_info(cpu)->coherency_domain_number = uv_coherency_id;
+		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
