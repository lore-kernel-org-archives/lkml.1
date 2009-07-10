Return-Path: <linux-kernel-owner+w=401wt.eu-S1751412AbZGJJEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbZGJJEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:03:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZGJJDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:03:53 -0400
Date: Fri, 10 Jul 2009 11:03:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090710090351.GD14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247215920.32044.3.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 11:52:00AM +0300, Pekka Enberg wrote:
> Hi Ingo,
> 
> On Fri, 2009-07-10 at 10:47 +0200, Ingo Molnar wrote:
> > > >  arch/arm/include/asm/elf.h |    1 +
> > > >  arch/arm/kernel/module.c   |    1 +
> > > >  drivers/Makefile           |    4 +-
> > > >  include/mf-runtime.h       |   42 ++++++++++++++
> > > >  kernel/Makefile            |    2 +-
> > > >  kernel/mudflap.c           |  132 ++++++++++++++++++++++++++++++++++++++++++++
> > > >  lib/Kconfig.debug          |    7 ++
> > > >  mm/slab.c                  |   53 ++++++++++++++++++
> > > >  8 files changed, 240 insertions(+), 2 deletions(-)
> > > 
> > > SLAB is (slowly) going away so you might want to port this to SLUB 
> > > as well so we can merge both.
> > 
> > and SLQB which will replace both? :-/
> 
> Well, I cannot really expect people to port patches to SLQB until it's
> in mainline.

I agree...

slab allocator's primary metric is performance, and debugging
features can tend to be added very easily after that (because
there is a performance hit accepted). So I have not been spending
much time on those in SLQB.

If it gets merged and decided to stay based on performance results,
then I will do more to port over other debug features.


> And whether SQLB will replace SLUB remains to be seen.
> We're still fixing minor issues here and there in SLUB so I have no
> reason to expect SLQB stabilization to happen overnight which means
> we're going to have SLUB in the tree for a while anyway.

I think it's pretty good now. It was the right thing not to merge
it in this window (seeing as I'd forgotten to make it the default
in -next). And that flushed out a bug or two. The core logic I
think is pretty solid now though.

