Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZEVTUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZEVTUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZEVTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:20:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:18115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZEVTUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:20:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,234,1241420400"; 
   d="scan'208";a="414953768"
Subject: [patch] x86: Introduce noxsave boot parameter
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 22 May 2009 12:17:45 -0700
Message-Id: <1243019865.27006.10172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was posted before but never made it to the base. I was bitten yesterday
with some internal xsave kernel issue and I needed this patch to verify that it was
indeed related to xsave. Please apply.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Introduce noxsave boot parameter

Introduce "noxsave" boot parameter which will disable the cpu's xsave/xrstor
capabilities. Useful for debugging and working around xsave related issues.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ced875c..ea7af84 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	noxsave		[BUGS=X86] Disables x86 extended register state save
+			and restore using xsave. The kernel will fallback to
+			enabling legacy floating-point and sse state.
+
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
 			wfi(ARM) instruction doesn't work correctly and not to
 			use it. This is also useful when using JTAG debugger.
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5a60535..3ffdcfa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -115,6 +115,13 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+static int __init x86_xsave_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	return 1;
+}
+__setup("noxsave", x86_xsave_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;


