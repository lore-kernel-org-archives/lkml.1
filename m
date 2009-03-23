Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZCWJXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZCWJXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZCWJXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:23:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbZCWJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:23:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU  lists
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090323175507.6A18.A69D9226@jp.fujitsu.com>
References: <20090323084254.GA1685@cmpxchg.org> <20090323175507.6A18.A69D9226@jp.fujitsu.com>
Message-Id: <20090323182039.6A1B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 18:23:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > this is the just reason why current code don't call add_page_to_unevictable_list().
> > > add_page_to_unevictable_list() don't use pagevec. it is needed for avoiding race.
> > > 
> > > then, if readahead path (i.e. add_to_page_cache_lru()) use add_page_to_unevictable_list(),
> > > it can cause zone->lru_lock contention storm.
> > 
> > How is it different then shrink_page_list()?  If readahead put a
> > contiguous chunk of unevictable pages to the file lru, then
> > shrink_page_list() will as well call add_page_to_unevictable_list() in
> > a loop.
> 
> it's probability issue.
> 
> readahead: we need to concern
> 	(1) readahead vs readahead
> 	(2) readahead vs reclaim
> 
> vmscan: we need to concern
> 	(3) background reclaim vs foreground reclaim
> 
> So, (3) is rarely event than (1) and (2).
> Am I missing anything?

my last mail explanation is too poor. sorry.
I don't dislike this patch concept. but it seems a bit naive against contention.
if we can decrease contention risk, I can ack with presure.



