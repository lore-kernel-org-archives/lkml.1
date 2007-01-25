Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbXAYLzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbXAYLzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbXAYLzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:55:52 -0500
Received: from [212.12.190.202] ([212.12.190.202]:32956 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932876AbXAYLzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:55:51 -0500
From: Al Boldi <a1426z@gawab.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Limit the size of the pagecache
Date: Thu, 25 Jan 2007 14:57:32 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References: <200701250942.47321.a1426z@gawab.com> <45B86930.2090709@linux.vnet.ibm.com> <1169720945.6189.52.camel@twins>
In-Reply-To: <1169720945.6189.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251457.32999.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> > Apart from kswapd, limiting pagecache helps performance of
> > applications by not eating away their ANON pages or other parts of its
> > resident data set.  When there is enough free memory, then there is no
> > performance issue.  However memory is always utilized to the max.
> > Hence every pagecache page that is allocated should come from some
> > application's RSS, or from cold pagecache page.  If that page was
> > stolen from some application, then that application pays the price for
> > swapping or reading the page back to memory.  This scenario is what we
> >  want to avoid.  All that we are trying to achieve is that pagecache
> > eats a (unmapped) pagecache page and not steal memory from other
> > important application's resident set.
> >
> > Certainly this should be a configurable option and kernel's behavior
> > should not be changed in general.
>
> Ah, this would be a clear case of the page reclaim selecting the wrong
> working set.

Yes.

> It is perfectly fine for a page cache page to evict a app page (be it
> anon or not) if that page cache page is used more frequently than the
> app page in question.

It seems, that there is currently a clear preference for pagecache-page over 
app-page.  Some form of prio-selection could probably aid the situation.

> Trouble seems to be that the current algorithm gets it quite wrong at
> times.

It breaks down when memory gets tight.  You can actually hear it thrashing 
the disk, although it's not supposed to thrash, even with swapoff.

> Also stating that free memory somehow is good for you is weird, free
> memory is a loss, you under utilise your machine. Keeping clean
> pagecache pages in there that are likely to be referenced again is a
> clear win; it saves the tediously slow load from disk.

That's the theory.

> So you're now proposing to limit the page cache

As a workaround.

> where as its clear that
> the better solution would be to tune replacement policy

Yes.  Hopefully successfully.

> (and or provide
> hints to said mechanism using madvise/fadvise)

Not feasible; source is sometimes not immediately available.


Thanks!

--
Al

