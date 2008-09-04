Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYIDI61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYIDI61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYIDI6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:58:17 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:50453 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYIDI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:58:16 -0400
Date: Thu, 4 Sep 2008 09:58:09 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for
	allocation by the reclaimer
Message-ID: <20080904085809.GA6460@brain>
References: <1220467452-15794-5-git-send-email-apw@shadowen.org> <1220475206-23684-1-git-send-email-apw@shadowen.org> <48BEFAF9.3030006@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BEFAF9.3030006@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:00:41PM -0500, Christoph Lameter wrote:
> Andy Whitcroft wrote:
> 
> >  
> >  #ifndef __GENERATING_BOUNDS_H
> > @@ -208,6 +211,9 @@ __PAGEFLAG(SlubDebug, slub_debug)
> >   */
> >  TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
> >  __PAGEFLAG(Buddy, buddy)
> > +PAGEFLAG(BuddyCapture, buddy_capture)	/* A buddy page, but reserved. */
> > +	__SETPAGEFLAG(BuddyCapture, buddy_capture)
> > +	__CLEARPAGEFLAG(BuddyCapture, buddy_capture)
> 
> Doesnt __PAGEFLAG do what you want without having to explicitly specify
> __SET/__CLEAR?

I think I end up with one extra test that I don't need, but its
probabally much clearer.

> How does page allocator fastpath behavior fare with this pathch?

The fastpath should be unaffected on the allocation side.  On the free
side there is an additional check for merging with a buddy under capture
as we merge buddies in __free_one_page.

-apw
