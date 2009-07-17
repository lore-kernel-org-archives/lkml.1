Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbZGQHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbZGQHAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbZGQHAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:00:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45626 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbZGQHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:00:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/3] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0907161024120.32382@gentwo.org>
References: <20090716095344.9D10.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907161024120.32382@gentwo.org>
Message-Id: <20090717085821.A900.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 16:00:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -740,6 +744,13 @@ int migrate_pages(struct list_head *from
> >  	struct page *page2;
> >  	int swapwrite = current->flags & PF_SWAPWRITE;
> >  	int rc;
> > +	int flags;
> > +
> > +	local_irq_save(flags);
> > +	list_for_each_entry(page, from, lru)
> > +		__inc_zone_page_state(page, NR_ISOLATED_ANON +
> > +				      !!page_is_file_cache(page));
> > +	local_irq_restore(flags);
> >
> 
> Why do a separate pass over all the migrates pages? Can you add the
> _inc_xx  somewhere after the page was isolated from the lru by calling
> try_to_unmap()?

calling try_to_unmap()? the pages are isolated before calling migrate_pages().
migrate_pages() have multiple caller. then I put this __inc_xx into top of
migrate_pages().



