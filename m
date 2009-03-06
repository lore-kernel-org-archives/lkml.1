Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZCFU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZCFU4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZCFUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:55:59 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:56455 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZCFUz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:55:58 -0500
X-IronPort-AV: E=Sophos;i="4.38,316,1233532800"; 
   d="scan'208";a="152091884"
From: Roland Dreier <rdreier@cisco.com>
To: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: Remove KERN_ERR output if nForce2 chipset not found
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Mar 2009 12:55:56 -0800
Message-ID: <ada3adqid5v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2009 20:55:56.0655 (UTC) FILETIME=[F22847F0:01C99E9D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distribution kernels are building cpufreq drivers into the kernel to get
faster boot; if the nForce2 driver is built in, then on systems that are
not supported by the driver (ie nearly all current systems), the message

    cpufreq: No nForce2 chipset.

is printed at the KERN_ERR level, which means it goes to the console
even if quiet boot is turned on.

The best way to handle this is just to delete the message, since the
likelihood of it ever being of any use to anyone is very low, and other
cpufreq drivers don't print anything if no matching hardware is found.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index 965ea52..055fca3 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -419,10 +419,8 @@ static int __init nforce2_init(void)
 	/* TODO: do we need to detect the processor? */
 
 	/* detect chipset */
-	if (nforce2_detect_chipset()) {
-		printk(KERN_ERR "cpufreq: No nForce2 chipset.\n");
+	if (nforce2_detect_chipset())
 		return -ENODEV;
-	}
 
 	return cpufreq_register_driver(&nforce2_driver);
 }
