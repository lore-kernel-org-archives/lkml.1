Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbYA2Tls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbYA2Tls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYA2Tlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:41:39 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48010 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYA2Tlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:41:37 -0500
Date: Tue, 29 Jan 2008 11:13:54 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/4] print out node_data addr and bootmap_start addr
In-reply-to: <200801291041.10490.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291113.55164.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291041.10490.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] print out node_data addr and bootmap_start addr

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -202,6 +202,8 @@ void __init setup_node_bootmem(int nodei
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
+	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
+		nodedata_phys + pgdat_size - 1);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
 	NODE_DATA(nodeid)->bdata = &plat_node_bdata[nodeid];
@@ -221,12 +223,15 @@ void __init setup_node_bootmem(int nodei
 		return;
 	}
 	bootmap_start = __pa(bootmap);
-	Dprintk("bootmap start %lu pages %lu\n", bootmap_start, bootmap_pages);
 
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
 					 bootmap_start >> PAGE_SHIFT,
 					 start_pfn, end_pfn);
 
+	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
+		 bootmap_start, bootmap_start + bootmap_size - 1,
+		 bootmap_pages);
+
 	free_bootmem_with_active_regions(nodeid, end);
 
 	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size);

