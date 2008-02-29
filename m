Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbYB2Tvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbYB2Tvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933628AbYB2TvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:51:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760252AbYB2TvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:51:12 -0500
Date: Fri, 29 Feb 2008 11:50:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Michael Kerrisk <michael.kerrisk@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <20080229190952.GM24887@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.00.0802291128560.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy> <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org> <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com> <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org> <1204305488.6243.113.camel@lappy>
 <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org> <1204306934.6243.119.camel@lappy> <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org> <65dd6fd50802291101j3786ee60iec0f3a24f5df9945@mail.gmail.com>
 <20080229190952.GM24887@devserv.devel.redhat.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Jakub Jelinek wrote:
> On Fri, Feb 29, 2008 at 11:01:38AM -0800, Ollie Wild wrote:
> > 
> > This is precisely why I picked 25% as the maximum argument size ratio.
> >  In practice, that 25% can easily mean 50% or more.  If people want to
> > increase this, it can probably be tweaked somewhat, but switching it
> > to, say, 50% probably isn't a good idea.
> 
> I think 50% would be still fine.  And, ideally make that
> MAX (RLIMIT_STACK / 2, 128KB) to avoid regressions for programs which assume
> they can pass ARG_MAX args+env, even if they have say 192KB stack limit.

It would certainly be worth at least testing that as an approach.

Another thing we could decide to do is to just check the size of the stack 
that is left at the end of all the stack setup code, and just say "if it's 
less than X bytes, just return ENOMEM rather than set up a process with a 
really unusably small stack".

			Linus
