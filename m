Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbYFVOYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbYFVOYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYFVOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:22:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35802 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756397AbYFVOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:22:18 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:22:17 -0700
Message-Id: <20080622142217.5591.55403.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 5/5 v2] x86 boot: more consistently use type int for node ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Everywhere I look, node id's are of type 'int', except in this one
case, which has 'unsigned long'.  Change this one to 'int' as well.
There is nothing special about the way this variable 'nid' is used in
this routine to justify using an unusual type here.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page_alloc.c	2008-06-22 06:36:16.800519641 -0700
+++ linux-next/mm/page_alloc.c	2008-06-22 06:36:26.765123903 -0700
@@ -3666,7 +3666,7 @@ static void __init sort_node_map(void)
 }
 
 /* Find the lowest pfn for a node */
-unsigned long __init find_min_pfn_for_node(unsigned long nid)
+unsigned long __init find_min_pfn_for_node(int nid)
 {
 	int i;
 	unsigned long min_pfn = ULONG_MAX;
@@ -3677,7 +3677,7 @@ unsigned long __init find_min_pfn_for_no
 
 	if (min_pfn == ULONG_MAX) {
 		printk(KERN_WARNING
-			"Could not find start_pfn for node %lu\n", nid);
+			"Could not find start_pfn for node %d\n", nid);
 		return 0;
 	}
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
