Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbZFLKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbZFLKPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZFLKPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:15:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZFLKPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:15:10 -0400
Date: Fri, 12 Jun 2009 12:15:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or suspending
Message-ID: <20090612101511.GC13607@wotan.suse.de>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI> <20090612091002.GA32052@elte.hu> <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com> <20090612100756.GA25185@elte.hu> <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 01:11:52PM +0300, Pekka Enberg wrote:
> Hi Ingo,
> 
> On Fri, Jun 12, 2009 at 1:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
> > IMHO such invisible side-channels modifying the semantics of GFP
> > flags is a bit dubious.
> >
> > We could do GFP_INIT or GFP_BOOT. These can imply other useful
> > modifiers as well: panic-on-failure for example. (this would clean
> > up a fair amount of init code that currently checks for an panics on
> > allocation failure.)
> 
> OK, but that means we need to fix up every single caller. I'm fine
> with that but Ben is not. As I am unable to test powerpc here, I am
> inclined to just merge Ben's patch as "obviously correct".

I agree with Ingo though that exposing it as a gfp modifier is
not so good. I just like the implementation to mask off GFP_WAIT
better, and also prefer not to test system state, but have someone
just call into slab to tell it not to unconditionally enable
interrupts.

> That does not mean we can't introduce GFP_BOOT later on if we want to. Hmm?

Yes, with sufficient warnings in place, I don't think it should be
too error prone to clean up remaining code over the course of
a few releases.

