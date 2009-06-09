Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZFIP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZFIP2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZFIP2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:28:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:21752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZFIP2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,332,1241420400"; 
   d="scan'208";a="152304361"
Date: Tue, 9 Jun 2009 22:56:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [11/16] HWPOISON: check and isolate corrupted free
	pages v2
Message-ID: <20090609145614.GA5590@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184645.68FA21D0286@basil.firstfloor.org> <20090609100229.GE14820@wotan.suse.de> <20090609130304.GF5589@localhost> <20090609132847.GC15219@wotan.suse.de> <20090609134903.GC6583@localhost> <20090609135514.GD15219@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609135514.GD15219@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 09:55:14PM +0800, Nick Piggin wrote:
> On Tue, Jun 09, 2009 at 09:49:03PM +0800, Wu Fengguang wrote:
> > On Tue, Jun 09, 2009 at 09:28:47PM +0800, Nick Piggin wrote:
> > > And I don't think removing a free page from the page allocator is
> > > too much more complex than removing a live page from the pagecache ;)
> > 
> > There are usable functions for doing pagecache isolations, but no one
> > to isolate one specific page from the buddy system.
> 
> But it shouldn't be too hard. Anyway you wanted to reinvent your
> own functions for pagecache isolations ;)

Heh.

> > Plus, if we did present such a function, you'll then ask for it being
> > included in page_alloc.c, injecting a big chunk of dead code into the
> > really hot code blocks and possibly polluting the L2 cache. Will it be
> 
> But you would say no because you like it better in your memory
> isolation file ;)

I would like to align with your principle on this one :)

> > better than just inserting several lines? Hardly. Smaller text itself
> > yields faster speed.
> 
> Oh speed I'm definitely thinking about, don't worry about that.
> 
> Moving hot and cold functions together could become an issue
> indeed. Mostly it probably matters a little less than code
> within a single function due to their size. But I think gcc
> already has options to annotate this kind of thing which we
> could be using.

Can we tell gcc "I bet this _function_ is rarely used"?

> So it's not such a good argument against moving things out of
> hotpaths, or guiding in which files to place functions.

Yes.

> Anyway, in this case it is not a "nack" from me. Just that I
> would like to see the non-fastpath code too or at least if
> it can be thought about.

I think Andi would be pleased to present you with his buddy page
isolation code :)

Thanks,
Fengguang
