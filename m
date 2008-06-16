Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYFPGcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYFPGcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbYFPGag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757596AbYFPGaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:30:22 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:30:21 -0700
Message-Id: <20080616063021.14597.82858.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 8/8] x86 boot: more consistently use type int for node ids
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

--- linux.orig/mm/page_alloc.c	2008-06-15 21:43:46.109185357 -0700
+++ linux/mm/page_alloc.c	2008-06-15 21:43:49.753406159 -0700
@@ -3678,7 +3678,7 @@ static void __init sort_node_map(void)
 }
 
 /* Find the lowest pfn for a node */
-unsigned long __init find_min_pfn_for_node(unsigned long nid)
+unsigned long __init find_min_pfn_for_node(int nid)
 {
 	int i;
 	unsigned long min_pfn = ULONG_MAX;
@@ -3689,7 +3689,7 @@ unsigned long __init find_min_pfn_for_no
 
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
