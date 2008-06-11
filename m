Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYFKDSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYFKDSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYFKDSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:18:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:52531 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYFKDSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:18:23 -0400
Date: Wed, 11 Jun 2008 05:18:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
Message-ID: <20080611031822.GA8228@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:00:48PM -0700, Christoph Lameter wrote:
> On Thu, 5 Jun 2008, npiggin@suse.de wrote:
> 
> > Index: linux-2.6/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm.h
> > +++ linux-2.6/include/linux/mm.h
> > @@ -244,7 +244,7 @@ static inline int put_page_testzero(stru
> >   */
> >  static inline int get_page_unless_zero(struct page *page)
> >  {
> > -	VM_BUG_ON(PageTail(page));
> > +	VM_BUG_ON(PageCompound(page));
> >  	return atomic_inc_not_zero(&page->_count);
> >  }
> 
> This is reversing the modification to make get_page_unless_zero() usable 
> with compound page heads. Will break the slab defrag patchset.

Is the slab defrag patchset in -mm? Because you ignored my comment about
this change that assertions should not be weakened until required by the
actual patchset. I wanted to have these assertions be as strong as
possible for the lockless pagecache patchset.


