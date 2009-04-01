Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZDAJ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZDAJ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZDAJzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:55:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50788 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbZDAJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:55:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan: rename  sc.may_swap to may_unmap)
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090401094955.GA1656@cmpxchg.org>
References: <20090401180445.80b11d90.kamezawa.hiroyu@jp.fujitsu.com> <20090401094955.GA1656@cmpxchg.org>
Message-Id: <20090401185418.B204.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed,  1 Apr 2009 18:55:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > How about making may_swap mean the following:
> > > 
> > > 	@@ -642,6 +639,8 @@ static unsigned long shrink_page_list(st
> > > 	 		 * Try to allocate it some swap space here.
> > > 	 		 */
> > > 	 		if (PageAnon(page) && !PageSwapCache(page)) {
> > > 	+			if (!sc->map_swap)
> > > 	+				goto keep_locked;
> > > 	 			if (!(sc->gfp_mask & __GFP_IO))
> > > 	 				goto keep_locked;
> > > 	 			if (!add_to_swap(page))
> > > 
> > > try_to_free_pages() always sets it.
> > > 
> > What is the advantage than _not_ scanning ANON LRU at all ?
> 
> I thought we could collect anon pages that don't need swap io.

Yes. but Is this important?
if memcg reclaim don't collect sleal swapcache, other global reclaim can.

Am I missing any viewpoint?



