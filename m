Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYA2I7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYA2I7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYA2I7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:59:31 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33752 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYA2I73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:59:29 -0500
Date: Tue, 29 Jan 2008 01:05:35 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/2] print out node_data addr and bootmap_start addr
In-reply-to: <200801290053.45776.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Message-id: <200801290105.35561.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801290053.45776.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] print out node_data addr and bootmap_start addr

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
