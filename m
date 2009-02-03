Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZBCQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZBCQro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZBCQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:46:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:55972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbZBCQqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 6/7] CPUFREQ: powernow-k8: Only print error message once, not per core.
Date: Tue,  3 Feb 2009 17:46:45 +0100
Message-Id: <1233679606-1971-7-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the typical message you get if you plug in a CPU
which is newer than your BIOS. It's annoying seeing this
message for each core.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 9accffb..9e312c5 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -743,7 +743,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 	 * BIOS and Kernel Developer's Guide, which is available on
 	 * www.amd.com
 	 */
-	printk(KERN_ERR PFX "BIOS error - no PSB or ACPI _PSS objects\n");
+	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
 	return -ENODEV;
 }
 
@@ -1154,11 +1154,11 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
-			       " ACPI _PSS objects in a way that Linux "
-			       "understands. Please report this to the Linux "
-			       "ACPI maintainers and complain to your BIOS "
-			       "vendor.\n");
+			WARN_ONCE(1, KERN_ERR FW_BUG PFX "Your BIOS does not "
+				  "provide ACPI _PSS objects in a way that "
+				  "Linux understands. Please report this to "
+				  "the Linux ACPI maintainers and complain to "
+				  "your BIOS vendor.\n");
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
-- 
1.6.0.2

