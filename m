Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZFIIzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZFIIzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbZFIIzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:55:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37876 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZFIIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:55:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] Properly account for the number of page cache pages zone_reclaim() can reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090609082728.GF18380@csn.ul.ie>
References: <20090609022549.GB6740@localhost> <20090609082728.GF18380@csn.ul.ie>
Message-Id: <20090609175211.DD85.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 17:55:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The ideal would be that the number of tmpfs pages would also be known
> > > and account for like NR_FILE_MAPPED as swap is required to discard them.
> > > A means of working this out quickly was not obvious but a comment is added
> > > noting the problem.
> > 
> > I'd rather prefer it be accounted separately than to muck up NR_FILE_MAPPED :)
> > 
> 
> Maybe I used a poor choice of words. What I meant was that the ideal would
> be we had a separate count for tmpfs pages. As tmpfs pages and mapped pages
> both have to be unmapped and potentially, they are "like" each other with
> respect to the zone_reclaim_mode and how it behaves. We would end up
> with something like
> 
> 	pagecache_reclaimable -= zone_page_state(zone, NR_FILE_MAPPED);
> 	pagecache_reclaimable -= zone_page_state(zone, NR_FILE_TMPFS);

Please see shmem_writepage(). tmpfs writeout make swapcache, We also
need to concern swapcache.

note: swapcache also increase NR_FILE_PAGES, see add_to_swap_cache.



