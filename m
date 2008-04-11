Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbYDKIys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbYDKIys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYDKIyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:54:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658AbYDKIyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:54:40 -0400
Date: Fri, 11 Apr 2008 10:54:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at
	mm/slab.c:2103!"
Message-ID: <20080411085411.GA10181@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> >  >  it to build on .25) but that didnt solve the problem either.
> 
> On Fri, Apr 11, 2008 at 11:21 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >  As mentioned privately, I suspect it's the page allocator changes that
> >  went into 2.6.24. Mel, Christoph, any ideas?
> 
> So I'm thinking it's probably related to this patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=523b945855a1427000ffc707c610abe5947ae607
> 
> As kmalloc_node() in setup_cpu_cache() returns NULL, it seems likely 
> to be due to the use of GFP_THISNODE in cache_alloc_refill() when 
> calling cache_grow() and that the semantics changed. No idea why page 
> allocator would think your UMA "local node" has no memory though.

but ... as i said it in my report, this is a regression since v2.6.24 - 
v2.6.24 (and a whole bunch of commits since then, i listed the IDs) 
booted up fine. The commit ID you mention is: v2.6.23-4345-g523b945, way 
earlier than the good commit IDs.

so this is a recent regression.

	Ingo
