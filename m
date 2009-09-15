Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZIOU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZIOU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZIOU0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:26:44 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:43997 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbZIOU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:26:43 -0400
X-Trace: 259120221/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAHOVr0pPRVRK/2dsb2JhbACBU956hBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="259120221"
Date: Tue, 15 Sep 2009 21:26:01 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/8] mm: follow_hugetlb_page flags
In-Reply-To: <20090914132737.GB11778@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0909152117060.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909072235360.15430@sister.anvils> <20090909113143.GG24614@csn.ul.ie>
 <Pine.LNX.4.64.0909131548001.22865@sister.anvils> <20090914132737.GB11778@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Mel Gorman wrote:
> On Sun, Sep 13, 2009 at 04:35:44PM +0100, Hugh Dickins wrote:
> > On Wed, 9 Sep 2009, Mel Gorman wrote:
> 
> > > and called something like hugetlbfs_pagecache_present()
> > 
> > Can call it that if you prefer, either name suits me.
> 
> I don't feel strongly enough to ask for a new version. If this is not
> the final version that is merged, then a name-change would be nice.
> Otherwise, it's not worth the hassle.

You've raised several points, so worth a patch on top to keep you sweet!

> > > or else reuse
> > > the function and have the caller unlock_page but it's probably not worth
> > > addressing.
> > 
> > I did originally want to do it that way, but the caller is holding
> > page_table_lock, so cannot lock_page there.
> 
> Gack, fair point. If there is another version, a comment to that effect
> wouldn't hurt.

Righto, done.

> And nothing else other than core dumping will be using FOLL_DUMP so
> there should be no assumptions broken.

You have no idea of the depths of depravity to which I might sink:
see patch 1/4 in the coming group, you might be inclined to protest.

> > But it does seem that we've confused each other: what to say instead?
> 
> /*
>  * When core-dumping, it's suits the get_dump_page() if an error is
>  * returned if there is a hole and no huge pagecache to back it.
>  * get_dump_page() is concerned with individual pages and by
>  * returning the page as an error, the core dump file still gets
>  * zeros but a hugepage allocation is avoided.
>  */

I've added a sentence to that comment, not quite what you've
suggested above, but something I hope makes it clearer.

Hugh
