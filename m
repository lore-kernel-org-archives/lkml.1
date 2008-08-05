Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYHEL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYHEL0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHEL0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:26:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34521 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbYHEL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:26:09 -0400
Date: Tue, 05 Aug 2008 20:19:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48982F9E.2080100@linux.vnet.ibm.com>
References: <20080805151956.A885.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48982F9E.2080100@linux.vnet.ibm.com>
Message-Id: <20080805200556.A891.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In general yes, but in practice no. We have different paths through which a page
> can be reclaimed. Consider the following
> 
> 1. What happens if a global reclaim is in progress at the same time as memory
> cgroup reclaim and they are both looking at the same page?
> 2. In the shared reclaim infrastructure, we move pages and update statistics for
> pages belonging to a particular zone in a particular cgroup.

hehe, you said mem_cgroup_per_zone::lru_lock is unnecessary lock.

Also, we can two approach

  1. the pages are allowed to exist in different zone of memcg zone and 
     global zone.
     and recover later (by mem_cgroup_isolate_pages).
     here is current implementation.
  2. the pages aren't allowed to exist in different zone of memcg zone and 
     global zone.
     (you said its mail)

if we select 2, I hope mem_cgroup_move_lists is called by ____pagevec_lru_add
and add_page_to_unevictable_list.
then, page's global lru transition become memcg lru transition automatically.
it increase source code readability.




