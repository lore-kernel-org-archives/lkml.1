Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbZIXVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbZIXVa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZIXVaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:30:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31379 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZIXVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:30:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHqBu0qrR7O6/2dsb2JhbAC+MohTAZAMBYQcgV0
X-IronPort-AV: E=Sophos;i="4.44,447,1249257600"; 
   d="scan'208";a="395549170"
From: Roland Dreier <rdreier@cisco.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Kill overly verbose "throttling states" log messages
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 14:30:27 -0700
Message-ID: <adaskecyqrw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 21:30:27.0924 (UTC) FILETIME=[3C2C5940:01CA3D5E]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was recently lucky enough to get a 64-CPU system.  The processors
actually have T-states, so my kernel log ends up with 64 lines like:

    ACPI: Processor [CPU0] (supports xx throttling states)

This is pretty useless clutter because

 - this info is already available after boot from
   /proc/acpi/processor/CPUnn/throttling

 - there's also an ACPI_DEBUG_PRINT() in processor_throttling.c that
   gives the same info on boot for anyone who *really* cares.

So just delete the code that prints the throttling states in
processor_core.c.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/acpi/processor_core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index c2d4d6e..c567b46 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -863,13 +863,6 @@ static int acpi_processor_add(struct acpi_device *device)
 		goto err_remove_sysfs;
 	}
 
-	if (pr->flags.throttling) {
-		printk(KERN_INFO PREFIX "%s [%s] (supports",
-		       acpi_device_name(device), acpi_device_bid(device));
-		printk(" %d throttling states", pr->throttling.state_count);
-		printk(")\n");
-	}
-
 	return 0;
 
 err_remove_sysfs:
