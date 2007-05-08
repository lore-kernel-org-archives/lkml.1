Return-Path: <linux-kernel-owner+w=401wt.eu-S1032504AbXEHWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032504AbXEHWfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968452AbXEHWf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:35:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:55340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968462AbXEHWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:35:21 -0400
Date: Wed, 9 May 2007 00:35:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
Message-ID: <20070508223518.GC20174@wotan.suse.de>
References: <20070508114003.GB19294@wotan.suse.de> <20070508113709.GA19294@wotan.suse.de> <9948.1178626415@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9948.1178626415@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:13:35PM +0100, David Howells wrote:
> 
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > This patch trades a page flag for a significant improvement in the unlock_page
> > fastpath. Various problems in the previous version were spotted by Hugh and
> > Ben (and fixed in this one).
> 
> It looks reasonable at first glance, though it does consume yet another page
> flag:-/  However, I think that's probably a worthy trade.

Well, that's the big question :)


> >  }
> > -	
> > +
> > +static inline void unlock_page(struct page *page)
> > +{
> > +	VM_BUG_ON(!PageLocked(page));
> > +	ClearPageLocked_Unlock(page);
> > +	if (unlikely(PageWaiters(page)))
> > +		__unlock_page(page);
> > +}
> > +
> 
> Please don't simply discard the documentation, we have little enough as it is:

Oops, right.

