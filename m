Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXIUT5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXIUT5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbXIUT45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:56:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757575AbXIUT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:56:56 -0400
Date: Fri, 21 Sep 2007 12:56:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709211249330.18088@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Linus Torvalds wrote:

> The problem with that commit that I just reverted was that it mixed the 
> two, but not completely. It still kept them separate.

The quicklists have a long history and this bug has therefore also been in 
IA64 for a long time and it also likely exists on sparc64, sh and sh64. We 
need the patch that I posted to fix the other platforms. And with this fix 
there would be nothing amiss on x86_64 either.

---
 include/linux/quicklist.h |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/include/linux/quicklist.h
===================================================================
--- linux-2.6.orig/include/linux/quicklist.h	2007-09-21 11:46:44.000000000 -0700
+++ linux-2.6/include/linux/quicklist.h	2007-09-21 11:55:01.000000000 -0700
@@ -56,14 +56,6 @@ static inline void __quicklist_free(int 
 	struct page *page)
 {
 	struct quicklist *q;
-	int nid = page_to_nid(page);
-
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		__free_page(page);
-		return;
-	}
 
 	q = &get_cpu_var(quicklist)[nr];
 	*(void **)p = q->page;
