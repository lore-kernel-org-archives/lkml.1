Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYFGFok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYFGFok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 01:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYFGFoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 01:44:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49369 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbYFGFob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 01:44:31 -0400
Date: Sat, 07 Jun 2008 14:43:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 02/25] Use an indexed array for LRU variables
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com, clameter@sgi.com
In-Reply-To: <20080606180426.89989a07.akpm@linux-foundation.org>
References: <20080606202858.449902618@redhat.com> <20080606180426.89989a07.akpm@linux-foundation.org>
Message-Id: <20080607144105.9C52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> > ===================================================================
> > --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
> > +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33.000000000 -0400
> > @@ -1,40 +1,51 @@
> >  static inline void
> > +add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
> > +{
> > +	list_add(&page->lru, &zone->list[l]);
> > +	__inc_zone_state(zone, NR_INACTIVE + l);
> 
>                                ^ that's a bug, isn't it?

this is definitely bug.


> oh, no it isn't.
> Can we rename NR_INACTIVE?  Maybe VMSCAN_BASE or something?

as far as i remembered, old version use LRU_INACTIVE. 


