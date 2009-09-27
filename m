Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbZI0V5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbZI0V5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZI0V5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 17:57:31 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:61665 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbZI0V5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 17:57:30 -0400
X-Trace: 266686303/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.87.63/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.87.63
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAIt8v0pPRVc//2dsb2JhbACBUNBZhB4F
X-IronPort-AV: E=Sophos;i="4.44,461,1249254000"; 
   d="scan'208";a="266686303"
Date: Sun, 27 Sep 2009 22:57:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
In-Reply-To: <20090927192251.GB6327@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0909272251180.4402@sister.anvils>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils>
 <20090926190645.GB14368@wotan.suse.de> <20090926213204.GX30185@one.firstfloor.org>
 <Pine.LNX.4.64.0909271714370.9097@sister.anvils> <20090927192251.GB6327@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Nick Piggin wrote:
> On Sun, Sep 27, 2009 at 05:26:25PM +0100, Hugh Dickins wrote:
> > 
> > I don't particularly like adding a GFP_LOCKED just for this, and I
> > don't particularly like having to remember to unlock the thing on the
> > various(?) error paths between getting the page and adding it to cache.
> 
> God no, please no more crazy branches in the page allocator.
> 
> I'm going to resubmit my patches to allow 0-ref page allocations,
> so the pagecache will be able to work with those to do what we
> want here.
>  
> > But it is a good idea, and if doing it that way would really close a
> > race window which checking page->mapping (or whatever) cannot (I'm
> > simply not sure about that), then it would seem the best way to go.
> 
> Yep, seems reasonable: the ordering is no technical burden, and a
> simple comment pointing to hwpoison will keep it maintainable.

You move from "God no" to "Yep, seems reasonable"!

I think perhaps you couldn't bring yourself to believe that I was
giving any support to Andi's GFP_LOCKED idea.  Pretend I did not!

I'll assume we stick with the "God no", and we'll see how what
you come up with affects what they want.

Hugh
