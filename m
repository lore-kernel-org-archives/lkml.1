Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbXCUTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbXCUTQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXCUTQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:16:17 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1771 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbXCUTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:16:15 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <hansendc@us.ibm.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] anti-fragmentation: switch over to pfn_valid_within()
References: <exportbomb.1174504472@pinky>
InReply-To: <exportbomb.1174504472@pinky>
Message-ID: <600bd66bb100addcdbab7a091e081091@pinky>
Date: Wed, 21 Mar 2007 19:15:57 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move to using pfn_valid_within().

Signed-off-by: Andy Whitcroft <andyw@uk.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 695b5a6..3d7c29e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -747,12 +747,10 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page < end_page;) {
-#ifdef CONFIG_HOLES_IN_ZONE
-		if (!pfn_valid(page_to_pfn(page))) {
+		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
 		}
-#endif
 
 		if (!PageBuddy(page)) {
 			page++;
