Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBLBi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBLBi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZBLBiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:38:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54092 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZBLBit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:38:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: update_page_reclaim_stat() is called form page fault path
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, npiggin@suse.de, hugh@veritas.com, riel@redhat.com
In-Reply-To: <20090211151801.d9e8c84b.akpm@linux-foundation.org>
References: <20090211213340.C3CD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090211151801.d9e8c84b.akpm@linux-foundation.org>
Message-Id: <20090212103801.C8E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 12 Feb 2009 10:38:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void update_page_reclaim_stat(struct page *page)
> > +{
> > +	struct zone *zone = page_zone(page);
> > +
> > +	spin_lock_irq(&zone->lru_lock);
> > +	/* if the page isn't reclaimable, it doesn't update reclaim stat */
> > +	if (PageLRU(page) && !PageUnevictable(page)) {
> > +		update_page_reclaim_stat_locked(zone, page,
> > +					 !!page_is_file_cache(page), 1);
> > +	}
> > +	spin_unlock_irq(&zone->lru_lock);
> > +}
> 
> And we just added a spin_lock_irq() and a bunch of other stuff to it.
> 
> Can we improve this?
> 
> Can we just omit it, even?
> 
> Can we update those stats locklessly and accomodate the resulting
> inaccuracy over at the codesites where these statistics are actually
> used?

fair enough.
thanks good suggestion.

I'm working it on.



