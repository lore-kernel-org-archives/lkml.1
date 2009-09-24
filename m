Return-Path: <linux-kernel-owner+w=401wt.eu-S1751397AbZIXVwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbZIXVwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZIXVwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:52:37 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:13148 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZIXVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:52:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKOGu0qrR7PE/2dsb2JhbAC+OYhTAZAOBYQcgV0
X-IronPort-AV: E=Sophos;i="4.44,447,1249257600"; 
   d="scan'208";a="96217511"
From: Roland Dreier <rdreier@cisco.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Kill overly verbose "power state" log messages
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 14:52:36 -0700
Message-ID: <adapr9gypqz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 21:52:37.0191 (UTC) FILETIME=[547A6570:01CA3D61]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was recently lucky enough to get a 64-CPU system.  The processors
actually have T-states, so my kernel log ends up with 64 lines like:

    ACPI: CPU0 (power states: C1[C1] C2[C3])

This is pretty useless clutter because this info is already available
after boot from both /sys/devices/system/cpu/cpu*/cpuidle/state?/ as
well as /proc/acpi/processor/CPU*/power.

So just delete the code that prints the throttling states in
processor_idle.c.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/acpi/processor_idle.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index cc61a62..706eacf 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1214,13 +1214,6 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 		acpi_processor_setup_cpuidle(pr);
 		if (cpuidle_register_device(&pr->power.dev))
 			return -EIO;
-
-		printk(KERN_INFO PREFIX "CPU%d (power states:", pr->id);
-		for (i = 1; i <= pr->power.count; i++)
-			if (pr->power.states[i].valid)
-				printk(" C%d[C%d]", i,
-				       pr->power.states[i].type);
-		printk(")\n");
 	}
 #ifdef CONFIG_ACPI_PROCFS
 	/* 'power' [R] */
