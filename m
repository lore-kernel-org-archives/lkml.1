Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZJWXhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZJWXhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZJWXhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:52 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54732 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbZJWXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:50 -0400
Message-Id: <20091023233750.702443000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:46 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, David Rientjes <rientjes@google.com>,
       Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT messages
Content-Disposition: inline; filename=limit_srat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of SRAT messages of the form:

[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/srat_64.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/mm/srat_64.c
+++ linux/arch/x86/mm/srat_64.c
@@ -136,8 +136,9 @@
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+	if (node < 2 || !limit_console_output(false))
+		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+		       pxm, apic_id, node);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -170,8 +171,9 @@
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+	if (node < 2 || !limit_console_output(false))
+		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+		       pxm, apic_id, node);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE

-- 
