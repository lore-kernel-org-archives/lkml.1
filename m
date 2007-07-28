Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXG1WmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXG1WmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXG1WmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:42:09 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1687 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625AbXG1WmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:42:08 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ensure we count pages transitioning inactive via clear_active_flags
References: <exportbomb.1185662485@pinky>
InReply-To: <exportbomb.1185662485@pinky>
Message-ID: <06a9050c636e7b489c2a4c91951d2141@pinky>
Date: Sat, 28 Jul 2007 23:51:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We are transitioning pages from active to inactive in
clear_active_flags, those need counting as PGDEACTIVATE vm events.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d419e10..99ec7fa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -777,6 +777,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 			     (sc->order > PAGE_ALLOC_COSTLY_ORDER)?
 					     ISOLATE_BOTH : ISOLATE_INACTIVE);
 		nr_active = clear_active_flags(&page_list);
+		__count_vm_events(PGDEACTIVATE, nr_active);
 
 		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
 		__mod_zone_page_state(zone, NR_INACTIVE,
