Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYLAAuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYLAAuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYLAAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:50:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbYLAAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:50:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 04/09] memcg: make zone_reclaim_stat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4932BA80.3060708@redhat.com>
References: <20081130195731.8151.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4932BA80.3060708@redhat.com>
Message-Id: <20081201094856.8177.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 09:50:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> 
> > @@ -172,6 +173,10 @@ void activate_page(struct page *page)
> >  
> >  		reclaim_stat->recent_rotated[!!file]++;
> >  		reclaim_stat->recent_scanned[!!file]++;
> > +
> > +		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
> > +		memcg_reclaim_stat->recent_rotated[!!file]++;
> > +		memcg_reclaim_stat->recent_scanned[!!file]++;
> 
> Also, manipulation of the zone based reclaim_stats happens
> under the lru lock.
> 
> What protects the memcg reclaim stat?

memcg zone and memcg zone_reclaim_stat also use zone->lru_lock.




