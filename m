Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXGYOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXGYOjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGYOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:39:09 -0400
Received: from ns.suse.de ([195.135.220.2]:32896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXGYOjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:39:08 -0400
Date: Wed, 25 Jul 2007 16:39:04 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070725143904.GI19559@v2.random>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com> <20070724194418.GH19559@v2.random> <20070725032011.GN6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725032011.GN6909@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 08:20:11PM -0700, William Lee Irwin III wrote:
> In any event, I've never been involved in a research project, though

I didn't mean it was supposed to be research project in some
University. But IIRC it was founded by what is defined as R&D in the
income statement of a public company. That's why I called so, given it
wasn't incorporated in mainline or forked trees, and it eventually
bitrotten. I didn't mean to de-qualify the effort by calling it that
way. Infact I'm just saying it is valid now more than ever before,
given the current directions that are being pushed for mainline.

> In both instances, insurmountable nontechnical obstacles were present,
> which remain in place and effectively limit the scale and scope of any
> sort of project I can personally lead with any sort of likelihood of
> mainline acceptance.
> 
> Where I am limited, you are not. Good luck to you.

Not so sure as you are, I'm not even invited to KS this year, but I
guess that's fair enough punishment for me, given I also wasted some
time with other activities that in the long run I hope will become
profitable (this remains to be seen though, there's an Italian saying
that "who wants too much will get nothing" ;). But I'll be at the VM
summit which to me is probably more important than KS and I hope to
have some discussion about this stuff there, hope you're there
too. Anyway there's no reason why you shouldn't contribute to
CONFIG_PAGE_SHIFT if you want. I don't really care if it's me doing
it, or you or Hugh, I stepped in first because of the great idea of
the Hack Week and second because I care that Linux goes in directions
that benefit everyone, not just a single filesystem running on top of
some scatter gather crippled storage that slowdowns like a crawl if
the sg entries are small (which is something CONFIG_PAGE_SHIFT will
address too just fine but while giving other advantages at the same time).

I'm also not against the defrag efforts, but I simply want to reduce
the maximum the code that require order > 0 allocations for
strict performance reasons. defrag is by far not a free operation, it
even requires memcopies of the bulk data payload or swapouts.

For the kernel stack btw, when alloc_pages(order=1) fails vmalloc
should be used and 4k stacks can be dropped. Nobody does dma from the
stack anymore these days IIRC (it doesn't work in all archs anyway).
