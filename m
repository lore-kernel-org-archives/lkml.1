Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYJ3Q4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYJ3Q4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYJ3Q4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:56:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:33725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbYJ3Q4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,516,1220252400"; 
   d="scan'208";a="354071503"
Date: Thu, 30 Oct 2008 09:56:27 -0700
Message-Id: <200810301656.m9UGuQUQ007129@agluck-lia64.sc.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: next-20081029: arch/ia64/include/asm/smp.h:60: error: expected ')'
	before '*' token
In-Reply-To: <20081029145150.GA8668@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On ia64-bigsur (and other ia64 defconfigs):
> 
>   CC      arch/ia64/kernel/asm-offsets.s
> In file included from include/linux/smp.h:30,
>                  from include/linux/sched.h:68,
>                  from arch/ia64/kernel/asm-offsets.c:9:
> arch/ia64/include/asm/smp.h:60: error: expected ')' before '*' token
> arch/ia64/include/asm/smp.h:60: error: expected ')' before 'cpu_online_mask'

Looks like we simply need to delete the declaration in smp.h

Like this:

---

diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
index 12d96e0..21c4023 100644
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -57,7 +57,6 @@ extern struct smp_boot_data {
 
 extern char no_int_routing __devinitdata;
 
-extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
