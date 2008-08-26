Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbYHZSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbYHZSlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbYHZSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:41:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:44272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbYHZSlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:41:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,272,1217833200"; 
   d="scan'208";a="373837422"
Message-Id: <20080826183910.047665000@linux-os.sc.intel.com>
References: <20080826183909.887903000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 Aug 2008 11:38:07 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] x2apic: use x2apic id reported by cpuid during topology discovery
Content-Disposition: inline; filename=use_initial_apicid_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use x2apic id reported by cpuid during topology discovery, instead of the
apic id configured in the APIC. For most of the systems, x2apic id
reported by cpuid leaf 0xb will be same as the physical apic id reported
by the APIC_ID register of the APIC. We follow the suggested guidelines
and use the apic id reported by the cpuid.

No change to non-generic UV platforms, will use the apic id reported in the
APIC_ID register as the cpuid reported apic id's may not be unique.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---


Index: tip/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- tip.orig/arch/x86/kernel/genx2apic_cluster.c	2008-08-25 11:25:47.000000000 -0700
+++ tip/arch/x86/kernel/genx2apic_cluster.c	2008-08-25 13:15:45.000000000 -0700
@@ -120,14 +120,9 @@
 	return x;
 }
 
-static unsigned int x2apic_read_id(void)
-{
-	return apic_read(APIC_ID);
-}
-
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return x2apic_read_id() >> index_msb;
+	return current_cpu_data.initial_apicid >> index_msb;
 }
 
 static void x2apic_send_IPI_self(int vector)
Index: tip/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- tip.orig/arch/x86/kernel/genx2apic_phys.c	2008-08-25 11:25:47.000000000 -0700
+++ tip/arch/x86/kernel/genx2apic_phys.c	2008-08-25 13:15:45.000000000 -0700
@@ -118,14 +118,9 @@
 	return x;
 }
 
-static unsigned int x2apic_read_id(void)
-{
-	return apic_read(APIC_ID);
-}
-
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return x2apic_read_id() >> index_msb;
+	return current_cpu_data.initial_apicid >> index_msb;
 }
 
 void x2apic_send_IPI_self(int vector)

-- 

