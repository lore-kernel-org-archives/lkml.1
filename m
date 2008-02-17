Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYBQGw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYBQGw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYBQGwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:52:20 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42969 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYBQGwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:52:19 -0500
Date: Sat, 16 Feb 2008 23:00:22 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: get apic_id later in acpi_numa_processor_affinity_init
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802162300.23353.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need get that at beginning.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index ecd91ea..13110f6 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -132,7 +132,6 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	int pxm, node;
 	int apic_id;
 
-	apic_id = pa->apic_id;
 	if (srat_disabled())
 		return;
 	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
@@ -148,6 +147,8 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		bad_srat();
 		return;
 	}
+
+	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
