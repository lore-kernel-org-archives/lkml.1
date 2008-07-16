Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYGPMBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYGPMBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYGPMBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:01:13 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:18421 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYGPMBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:01:13 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/1] ia64: improper printk format in acpi-cpufreq
Date: Wed, 16 Jul 2008 16:01:34 +0400
Message-Id: <1216209694-25926-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dprintk is enabled the following warnings are generated:
arch/ia64/kernel/cpufreq/acpi-cpufreq.c: In function 'processor_set_pstate':
arch/ia64/kernel/cpufreq/acpi-cpufreq.c:54: warning: format '%x' expects type 'unsigned int', but argument 3 has type 's64'
arch/ia64/kernel/cpufreq/acpi-cpufreq.c: In function 'processor_get_pstate':
arch/ia64/kernel/cpufreq/acpi-cpufreq.c:76: warning: format '%x' expects type 'unsigned int', but argument 2 has type 's64'

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
index b8498ea..eed9b16 100644
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
+++ b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -51,7 +51,7 @@ processor_set_pstate (
 	retval = ia64_pal_set_pstate((u64)value);
 
 	if (retval) {
-		dprintk("Failed to set freq to 0x%x, with error 0x%x\n",
+		dprintk("Failed to set freq to 0x%x, with error 0x%lx\n",
 		        value, retval);
 		return -ENODEV;
 	}
@@ -74,7 +74,7 @@ processor_get_pstate (
 
 	if (retval)
 		dprintk("Failed to get current freq with "
-		        "error 0x%x, idx 0x%x\n", retval, *value);
+		        "error 0x%lx, idx 0x%x\n", retval, *value);
 
 	return (int)retval;
 }
-- 
1.5.3.rc5

