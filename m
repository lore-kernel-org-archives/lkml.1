Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbZCBQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbZCBQ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZCBQ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:52 -0500
Received: from mx1.emlix.com ([193.175.82.87]:51750 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbZCBQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:51 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:43:02 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/7] xtensa: fix init_bootmem_node() argument order
Content-Disposition: inline; filename=xtensa-fix-init_bootmem_node-argument-order.patch
Message-Id: <E1LeBSf-0003Z4-92@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second argument to init_bootmem_node() is the PFN to place the
bootmem bitmap at and the third argument is the first PFN on the node.

This is currently backwards but never made any problems as both values
were always zero.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -145,8 +145,9 @@ void __init bootmem_init(void)
 	/* Reserve the bootmem bitmap area */
 
 	mem_reserve(bootmap_start, bootmap_start + bootmap_size, 1);
-	bootmap_size = init_bootmem_node(NODE_DATA(0), min_low_pfn,
+	bootmap_size = init_bootmem_node(NODE_DATA(0),
 					 bootmap_start >> PAGE_SHIFT,
+					 min_low_pfn,
 					 max_low_pfn);
 
 	/* Add all remaining memory pieces into the bootmem map */

-- 

