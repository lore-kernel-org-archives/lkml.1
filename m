Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbYCDVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbYCDVVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYCDVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:21:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849AbYCDVVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:21:43 -0500
Date: Tue, 4 Mar 2008 16:21:13 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
Message-ID: <20080304162113.601ebb30@cuia.boston.redhat.com>
In-Reply-To: <1204643158.5338.5.camel@localhost>
References: <20080228192908.126720629@redhat.com>
	<20080228192929.031646681@redhat.com>
	<20080304192441.1EA2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1204643158.5338.5.camel@localhost>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 10:05:58 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> > IMHO insert "lru" word is better.
> > example,
> > 
> > config NORECLAIM_LRU
> > 	bool "Zone LRU of track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > 	depends on EXPERIMENTAL && 64BIT
> 
> OK.  But, I'd suggest the 'bool' description be something like:
> 
> config NORECLAIM_LRU
> 	bool "Add LRU list to track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"

I have added this in the 2.6.25-rc3-mm1 port.

> > 
> > > @@ -356,8 +380,10 @@ void release_pages(struct page **pages, 
> > >  				zone = pagezone;
> > >  				spin_lock_irqsave(&zone->lru_lock, flags);
> > >  			}
> > > -			VM_BUG_ON(!PageLRU(page));
> > > -			__ClearPageLRU(page);
> > > +			is_lru_page = PageLRU(page);
> > > +			VM_BUG_ON(!(is_lru_page));
> > > +			if (is_lru_page)
> > > +				__ClearPageLRU(page);
> > >  			del_page_from_lru(zone, page);
> > >  		}
> > 
> > it seems unnecessary change??
> 
> Hmmm.  Not sure what I was thinking here.  Might be a relic of some
> previous debug instrumentation.  Guess I don't have any problem with
> removing this change.

Removed.

-- 
All Rights Reversed
