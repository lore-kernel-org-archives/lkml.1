Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZGVMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZGVMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZGVMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:54:18 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:21623 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbZGVMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:54:17 -0400
X-Trace: 230133583/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.68.55/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.68.55
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAEAMeoZkpPRUQ3/2dsb2JhbACBUc9AgjSBWgU
X-IronPort-AV: E=Sophos;i="4.43,247,1246834800"; 
   d="scan'208";a="230133583"
Date: Wed, 22 Jul 2009 13:54:06 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Rik van Riel <riel@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       akpm@linux-foundation.org, chrisw@redhat.com, avi@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
In-Reply-To: <4A660101.3000307@redhat.com>
Message-ID: <Pine.LNX.4.64.0907221346040.529@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com> <20090721175139.GE2239@random.random>
 <4A660101.3000307@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Rik van Riel wrote:
> Andrea Arcangeli wrote:
> > > -	if (PageAnon(old_page)) {
> > > +	if (PageAnon(old_page) && !PageKsm(old_page)) {
> > >    if (!trylock_page(old_page)) {
> > >     page_cache_get(old_page);
> > >     pte_unmap_unlock(page_table, ptl);
> > 
> > What exactly does it buy to have PageAnon return 1 on ksm pages,
> > besides requiring the above additional check (that if we stick to the
> > above code, I would find safer to move inside reuse_swap_page).
> 
> I guess that if they are to remain unswappable, they
> should go onto the unevictable list.

The KSM pages are not put on any LRU, so wouldn't be slowing vmscan
down with futile scans: isn't the unevictable list for pages which
belong to another LRU once they become evictable again?

(At this instant I've forgotten why there's an unevictable list at
all - somewhere in vmscan.c which is accustomed to dealing with
pages on lists, so easier to have them on a list than not?)

> 
> Then again, I'm guessing this is all about to change
> in not too much time :)

Yes, I'd much rather put the effort into making them swappable,
than fiddling with counts here and there to highlight their
current unswappability.

Hugh
