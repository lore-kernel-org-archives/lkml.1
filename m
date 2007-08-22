Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbXHVS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbXHVS7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXHVS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:59:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42344 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752919AbXHVS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:59:09 -0400
Message-Id: <20070822172124.217932000@sgi.com>
References: <20070822172101.138513000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 10:21:07 -0700
From: travis@sgi.com
To: Andi Kleen <ak@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 6/6] x86: acpi-use-cpu_physical_id
Content-Disposition: inline; filename=acpi-use-cpu_physical_id
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is from an earlier message from Christoph Lameter:

    processor_core.c currently tries to determine the apicid by special casing
    for IA64 and x86. The desired information is readily available via

	    cpu_physical_id()

    on IA64, i386 and x86_64.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/acpi/processor_core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -420,12 +420,6 @@ static int map_lsapic_id(struct acpi_sub
 	return 0;
 }
 
-#ifdef CONFIG_IA64
-#define arch_cpu_to_apicid 	ia64_cpu_to_sapicid
-#else
-#define arch_cpu_to_apicid 	x86_cpu_to_apicid
-#endif
-
 static int map_madt_entry(u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -499,7 +493,7 @@ static int get_cpu_id(acpi_handle handle
 		return apic_id;
 
 	for (i = 0; i < NR_CPUS; ++i) {
-		if (arch_cpu_to_apicid[i] == apic_id)
+		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
 	return -1;

-- 
