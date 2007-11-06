Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbXKFHdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbXKFHdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXKFHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:32:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:25149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbXKFHc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:32:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,376,1188802800"; 
   d="scan'208";a="263743977"
Subject: [Patch1/2] fix wrong proc cpuinfo on x64
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Organization: 
Message-Id: <1194333939.3046.36.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 06 Nov 2007 15:25:39 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


in 2.6.24-rc1 kernel, 
The /proc/cpuinfo display is wrong.

One issue is every processor id appears to be 0.

That is because smp_store_cpu_info will set cpuinfo_x86->cpu_index
to cpu id then call identify_cpu
identify_cpu will call early_identify_cpu which set c->cpu_index back to
0.

This patch set cpu_index after identify_cpu to fix the issue.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>

--- linux-2.6.24-rc1/arch/x86/kernel/smpboot_64.c	2007-10-29 22:03:05.000000000 -0400
+++ b/arch/x86/kernel/smpboot_64.c	2007-11-05 22:12:57.000000000 -0500
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 

