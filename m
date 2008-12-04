Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYLDGOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYLDGOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYLDGO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:14:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38607 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLDGOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:14:25 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 06/11] memcg: make inactive_anon_is_low()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081203135249.GE17701@balbir.in.ibm.com>
References: <20081201211457.1CDC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081203135249.GE17701@balbir.in.ibm.com>
Message-Id: <20081204151202.1D75.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 15:14:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/*
> > + * The inactive anon list should be small enough that the VM never has to
> > + * do too much work, but large enough that each inactive page has a chance
> > + * to be referenced again before it is swapped out.
> > + *
> > + * this calculation is straightforward porting from
> > + * page_alloc.c::setup_per_zone_inactive_ratio().
> > + * it describe more detail.
> > + */
> > +static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
> > +{
> > +	unsigned int gb, ratio;
> > +
> > +	gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
> > +	if (gb)
> > +		ratio = int_sqrt(10 * gb);
> 
> I don't understand where the magic number 10 comes from?

the function comment write to

  this calculation is straightforward porting from
  page_alloc.c::setup_per_zone_inactive_ratio().
  it describe more detail.





> > @@ -1400,7 +1412,7 @@ static unsigned long shrink_list(enum lr
> >  	}
> > 
> >  	if (lru == LRU_ACTIVE_ANON &&
> > -	    (!scan_global_lru(sc) || inactive_anon_is_low(zone))) {
> > +	    inactive_anon_is_low(zone, sc)) {
> 
> Can't we merge the line with the "if" statement

Will fix.

thanks.



