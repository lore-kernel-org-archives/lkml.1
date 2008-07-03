Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYGCQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYGCQgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYGCQgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:36:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36695 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYGCQgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:36:41 -0400
Date: Thu, 3 Jul 2008 17:36:38 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       babydr@baby-dragons.com, lee.schermerhorn@hp.com, a.beregalov@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH] Do not clobber pgdat->nr_zones during memory initialisation
Message-ID: <20080703163638.GC18055@csn.ul.ie>
References: <20080701175855.GI32727@shadowen.org> <20080701190741.GB16501@csn.ul.ie> <1214944175.26855.18.camel@dwillia2-linux.ch.intel.com> <20080702051759.GA26338@csn.ul.ie> <1215049766.2840.43.camel@dwillia2-linux.ch.intel.com> <20080703042750.GB14614@csn.ul.ie> <alpine.LFD.1.10.0807022135360.18105@woody.linux-foundation.org> <20080703050036.GD14614@csn.ul.ie> <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com> <486CD623.8030906@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <486CD623.8030906@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/07/08 08:37), Christoph Lameter didst pronounce:
> What a convoluted description. Simply put: We clobber the nr_zones field
> because we write beyond the bounds of the node_zonelists[] array in
> struct pglist_data.
> 

Subject: [PATCH] Do not clobber pgdat->nr_zones during memory initialisation

The nr_zones field is getting clobbered due to a write beyond the bounds of
the node_zonelists[] array in struct pglist_data.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.26-rc8-clean/mm/page_alloc.c linux-2.6.26-rc8-fix-kswapd-on-numa/mm/page_alloc.c
--- linux-2.6.26-rc8-clean/mm/page_alloc.c	2008-06-24 18:58:20.000000000 -0700
+++ linux-2.6.26-rc8-fix-kswapd-on-numa/mm/page_alloc.c	2008-07-02 21:49:09.000000000 -0700
@@ -2328,7 +2328,6 @@ static void build_zonelists(pg_data_t *p
 static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	pgdat->node_zonelists[0].zlcache_ptr = NULL;
-	pgdat->node_zonelists[1].zlcache_ptr = NULL;
 }
 
 #endif	/* CONFIG_NUMA */
