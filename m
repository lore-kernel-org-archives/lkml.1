Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbYFGOsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbYFGOsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYFGOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:48:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbYFGOsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:48:00 -0400
Date: Sat, 7 Jun 2008 10:47:40 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com, clameter@sgi.com
Subject: Re: [PATCH -mm 02/25] Use an indexed array for LRU variables
Message-ID: <20080607104740.6c12a324@bree.surriel.com>
In-Reply-To: <20080607144105.9C52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080606202858.449902618@redhat.com>
	<20080606180426.89989a07.akpm@linux-foundation.org>
	<20080607144105.9C52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jun 2008 14:43:50 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> > > ===================================================================
> > > --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
> > > +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33.000000000 -0400
> > > @@ -1,40 +1,51 @@
> > >  static inline void
> > > +add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
> > > +{
> > > +	list_add(&page->lru, &zone->list[l]);
> > > +	__inc_zone_state(zone, NR_INACTIVE + l);
> > 
> >                                ^ that's a bug, isn't it?
> 
> this is definitely bug.

I believe this is correct, actually.   I will rename/alias it to
VMSCAN_BASE or something along those lines.

> > oh, no it isn't.
> > Can we rename NR_INACTIVE?  Maybe VMSCAN_BASE or something?
> 
> as far as i remembered, old version use LRU_INACTIVE. 

LRU_* is used to index LRU arrays.

NR_* is used as an offset into the zone state.

-- 
All rights reversed.
