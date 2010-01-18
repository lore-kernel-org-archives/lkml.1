Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219Ab0ARU0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0ARU0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924Ab0ARU0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:26:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:53173 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0ARU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="234051381"
Message-Id: <20100118201256.604267529@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 18 Jan 2010 12:10:48 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Chris McDermott <lcm@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>, stable@kernel.org
Subject: [patch 1/2] x86, apic: use physical mode for IBM summit platforms
Content-Disposition: inline; filename=ibm_summit_oem_check_for_x64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris McDermott from IBM confirmed that hurricane chipset in IBM summit
platforms doesn't support logical flat mode. Irrespective of the other things
like apic_id's, total number of logical cpu's, Linux kernel should default
to physical mode for this system. 32bit kernel does so using the OEM checks
for the IBM summit platform. Add a similar OEM platform check for the 64bit
kernel too. Otherwise the linux kernel boot can hang on this platform under
certain bios/platform settings.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Chris McDermott <lcm@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/apic_flat_64.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: tip/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ tip/arch/x86/kernel/apic/apic_flat_64.c
@@ -240,6 +240,11 @@ static int physflat_acpi_madt_oem_check(
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
 	}
+
+	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
+		printk(KERN_DEBUG "IBM Summit detected, will use apic physical");
+		return 1;
+	}
 #endif
 
 	return 0;


