Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbYFGFWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbYFGFWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 01:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYFGFWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 01:22:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33344 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYFGFWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 01:22:46 -0400
Date: Sat, 07 Jun 2008 14:21:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 16/25] SHM_LOCKED pages are non-reclaimable
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com
In-Reply-To: <20080606180514.93f620ff.akpm@linux-foundation.org>
References: <20080606202859.466929557@redhat.com> <20080606180514.93f620ff.akpm@linux-foundation.org>
Message-Id: <20080607141333.9C4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > +static void check_move_noreclaim_page(struct page *page, struct zone *zone)
> > +{
> > +
> > +	ClearPageNoreclaim(page); /* for page_reclaimable() */
> 
> Confused.  Didn't we just lose track of our NR_NORECLAIM accounting?

I think this code is right.
this patch track it by below code.

but comments adding is better? 


> > +	if (page_reclaimable(page, NULL)) {
> > +		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
> > +		__dec_zone_state(zone, NR_NORECLAIM);
> > +		list_move(&page->lru, &zone->list[l]);
> > +		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
> > +	} else {
> > +		/*
> > +		 * rotate noreclaim list
> > +		 */
> > +		SetPageNoreclaim(page);
> > +		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
> > +	}
> > +}




