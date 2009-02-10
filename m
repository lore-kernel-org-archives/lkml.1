Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZBJMGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZBJMGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZBJMGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:06:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44216 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZBJMGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:06:41 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC] vmscan: initialize sc->nr_reclaimed in do_try_to_free_pages()
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <28c262360902100403m772576afp3c9212157dc9fcd@mail.gmail.com>
References: <20090210204210.6FEF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360902100403m772576afp3c9212157dc9fcd@mail.gmail.com>
Message-Id: <20090210210520.7004.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 21:06:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> > {
> >        /* Minimum pages needed in order to stay on node */
> >        const unsigned long nr_pages = 1 << order;
> >        struct task_struct *p = current;
> >        struct reclaim_state reclaim_state;
> >        int priority;
> >        struct scan_control sc = {
> >                .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
> >                .may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> >                .swap_cluster_max = max_t(unsigned long, nr_pages,
> >                                        SWAP_CLUSTER_MAX),
> >                .gfp_mask = gfp_mask,
> >                .swappiness = vm_swappiness,
> >                .isolate_pages = isolate_pages_global,
> > +               .nr_reclaimed = 0;
> >        };
> 
> Hmm.. I missed that.  Thanks.
> There is one in shrink_all_memory.

No.
__zone_reclaim isn't a part of shrink_all_memory().

Currently, shrink_all_memory() don't use sc.nr_reclaimed member.
(maybe, it's another wrong thing ;)



