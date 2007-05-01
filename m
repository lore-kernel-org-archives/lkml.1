Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXEAH4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXEAH4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXEAH4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:56:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:59525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965589AbXEAH4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:56:02 -0400
Date: Tue, 1 May 2007 09:55:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Kasper Sandberg <lkml@metanurb.dk>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070501075515.GD10590@wotan.suse.de>
References: <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <20070429111159.GH23638@1wt.eu> <1177848054.9756.30.camel@localhost> <1177848810.5791.104.camel@localhost.localdomain> <20070429125522.GB31925@holomorphy.com> <1177853867.5791.120.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177853867.5791.120.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 03:37:47PM +0200, Thomas Gleixner wrote:
> On Sun, 2007-04-29 at 05:55 -0700, William Lee Irwin III wrote:
> > You'll also hit the same holes should you attempt to write such a
> > modularity patch for mainline as opposed to porting current mainline to
> > the driver API as-given. It takes a bit more work to get something that
> > actually works for all this, and it borders on disingenuity to
> > suggest that the scheduler class/driver API as it now stands is
> > capable of any such thing as porting current mainline, nicksched, or SD
> > to it without significant code impact to the core scheduler code.
> 
> I never said, that the current implementation of CFS fits the criteria
> of modularity, but it is a step in that direction. I'm well aware that
> there is a bunch of things missing and it has hard coded leftovers,
> which are related to the current two hard coded policy classes.

[ I've tuned out of most of the scheduler discussion lately, sorry ;) ]


People seem to be confusing scheduler policy with a modular framework.

First of all, I don't know that any of the schedulers can "just go in"
and replace the mainline one, because they are still under development
and have not been sufficiently tested and contrasted IMO.

Secondly, if we want to have a modular framework, it should:
- be a seperate patchset to any new scheduler policy
- obviously retain the existing policy for testing / comparison purposes
- be able to be compiled out. I don't know whether it's CFS policy or
  the framework (maybe both), but CFS is quite a bit slower at context
  switching when I last measured with lmbench (several releases ago).

I still would rather not have a modular framework unless we decide
that is the only wake to make upstream progress. But if we did have
the modular framework, we still need to decide on the process of
avoiding profileration, selecting a default scheduler, and a plan for
future phasing out of non-default GP schedulers once a new one gets
selected.

