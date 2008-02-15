Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYBORPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYBORPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYBORPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:15:18 -0500
Received: from mail.fieldses.org ([66.93.2.214]:43707 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYBORPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:15:16 -0500
Date: Fri, 15 Feb 2008 12:15:08 -0500
To: Benny Halevy <bhalevy@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080215171508.GF20826@fieldses.org>
References: <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org> <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org> <20080213042512.GB9766@fieldses.org> <alpine.LFD.1.00.0802122127110.2920@woody.linux-foundation.org> <20080213175212.GB13462@fieldses.org> <47B47BC7.60401@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B47BC7.60401@panasas.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 07:35:03PM +0200, Benny Halevy wrote:
> One idea that I thought about when debating rebase vs. merge (and it's
> far far from being fully baked) is versioned commits.  The gist of it
> is that patches are assigned an hash identifier like today when they
> are first committed into the tree, but, and this is the main change:
> if they mutate, e.g. by a rebase, or even git commit --amend, their
> version is bumped up rather than SHA changed.

The SHA1 is uniquely determined by the contents of that commit--commit
and author names and times, changelog message, snapshot of the tree at
that point, and parents--hence, recursively, by the entire history
leading up to that commit.

Naming objects by their content in that way has a lot of advantages--for
example, you can sign an entire history by signing just the SHA1 of the
commit at its tip.  So you can't break that link between the names of
commits and their contents without ending up with a fundamentally
different (and probably weaker, in some sense), system.

I suspect there's an unavoidable tradeoff--if you want to be able to
reliably and efficiently determine how two branches are related, then
you can't just throw away their (possibly messy) history.  The best you
may be able to do, if you want the advantages of both rebasing and
merging, is to maintain on your own the messier meta-history as a
superset of the simpler history that you end up submitting.

--b.

> This way all versions of the commit would be accessible and addressable using
> their respective SHA *and* version. I think that this can help keep
> the tree's history in a more intuitive way (since the patches' base identifier
> won't change, just its version number), and you get a bonus of seeing each
> commit's history, who changed it, and what was the change.
