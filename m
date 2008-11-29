Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYK2LU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYK2LU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYK2LUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:20:21 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:50476 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbYK2LUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:20:20 -0500
From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: mahesh@linux.vnet.ibm.com
Subject: [PATCH] Don't export sched_mc_power_savings in laptops
Date: Sat, 29 Nov 2008 16:50:12 +0530
Message-Id: <1227957612-7000-1-git-send-email-mahesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
Author: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Fix to prevent sched_mc_power_saving from being exported through sysfs
        for multicore single socket (Laptop).
    
        CPU core map of the boot cpu should be equal to possible number
        of cpus for single socket system.
    
        This fix has been developed at FOSS.in kernel workout.
    
        Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4850e4b..4adc830 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -239,7 +239,7 @@ struct pci_bus;
 void set_pci_bus_resources_arch_default(struct pci_bus *b);
 
 #ifdef CONFIG_SMP
-#define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
+#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map,0)) != nr_cpu_ids)
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
