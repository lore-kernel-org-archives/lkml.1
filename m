Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYB2TOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYB2TOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYB2TOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:14:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYB2TON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:14:13 -0500
Date: Fri, 29 Feb 2008 14:09:52 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ollie Wild <aaw@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Michael Kerrisk <michael.kerrisk@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Message-ID: <20080229190952.GM24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1204119455.6242.403.camel@lappy> <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org> <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com> <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org> <1204305488.6243.113.camel@lappy> <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org> <1204306934.6243.119.camel@lappy> <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org> <65dd6fd50802291101j3786ee60iec0f3a24f5df9945@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65dd6fd50802291101j3786ee60iec0f3a24f5df9945@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 11:01:38AM -0800, Ollie Wild wrote:
> On Fri, Feb 29, 2008 at 10:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So it's not *going* to be exact even with RLIMIT_ARG_MAX, because it's
> > going to have all those other issues to contend with - on a 64-bit
> > architecture, the argument _pointers_ are often within an order of
> > magnitude of the argument strings themselves, and I don't think your patch
> > counted them as part of the argument/environemnt size (I was too lazy to
> > check the sources, but I'm pretty sure argv/env_start/end is just the
> > string space, not the pointers).
> 
> This is precisely why I picked 25% as the maximum argument size ratio.
>  In practice, that 25% can easily mean 50% or more.  If people want to
> increase this, it can probably be tweaked somewhat, but switching it
> to, say, 50% probably isn't a good idea.

I think 50% would be still fine.  And, ideally make that
MAX (RLIMIT_STACK / 2, 128KB) to avoid regressions for programs which assume
they can pass ARG_MAX args+env, even if they have say 192KB stack limit.

	Jakub
