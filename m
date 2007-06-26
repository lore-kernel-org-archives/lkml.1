Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXFZTmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXFZTmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXFZTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:41:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40439 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756254AbXFZTlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:41:55 -0400
Date: Tue, 26 Jun 2007 12:41:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 15/26] Slab defrag: Support generic defragmentation for
 inode slab caches
In-Reply-To: <20070626123709.211c67c4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706261241130.20744@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095917.005535114@sgi.com>
 <20070626011836.f4abb4ff.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706261223110.20457@schroedinger.engr.sgi.com>
 <20070626123709.211c67c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> This is inverted: __GFP_FS is set if we may perform fs operations.

Sigh. 



Slab defragmentation: Only perform slab defrag if __GFP_FS is clear

Avoids slab defragmentation be triggered from filesystem operations.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/vmscan.c	2007-06-26 12:25:28.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/vmscan.c	2007-06-26 12:40:44.000000000 -0700
@@ -233,8 +233,9 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += total_scan;
 	}
 	up_read(&shrinker_rwsem);
-	kmem_cache_defrag(sysctl_slab_defrag_ratio,
-		zone ? zone_to_nid(zone) : -1);
+	if (gfp_mask & __GFP_FS)
+		kmem_cache_defrag(sysctl_slab_defrag_ratio,
+			zone ? zone_to_nid(zone) : -1);
 	return ret;
 }
 
