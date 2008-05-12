Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYELG6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYELG6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYELG6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:58:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34903 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbYELG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:58:01 -0400
Date: Mon, 12 May 2008 08:57:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080512065759.GA7145@uranus.ravnborg.org>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org> <20080511200016.GH1645@cs181133002.pp.htv.fi> <20080511203827.GA850@uranus.ravnborg.org> <20080511211902.GI1645@cs181133002.pp.htv.fi> <20080511214428.GA1782@uranus.ravnborg.org> <20080511221158.GN1645@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511221158.GN1645@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But we are in an area where "common sense" doesn't help if we rely on 
> some specific behaviour.
> 
> > > gcc 4.3 even ignores the unlikely() hint in timespec_add_ns()
> > > (we now have a workaround for this in the kernel).
> > I do not follow the logic here.
> > Gcc may fail in a few cases to do what we expect but that
> > is far from that we shall assume that it always fails.
> 
> My logic is simple:
> 
> If you rely on a hint that assumption can break.

And the fix is to remove all hints?
No - the fix is to replace hints with forced rules so we do
_not_ rely on hint when we need to know what shall happen.

By your definition we should replace all instances
of __always_inline with inline and define both to
__attribute__((always_inline)). Because inline
should be an order not a hint.

And all I try to understand is why you see no value in the
distinction on the possibility to annotate a function:

a)
   static void inline foo() { ... }

and

b)
   static void __attribute__((always_inline)) foo() { ... }

But you continue to pretend that a hint is useless because we
are not sure what happens so we are equally well suited with
no hint at all.
Even so your patch showed that gcc (at least my ancient 4.1.1)
took notice of the inline hint and in some cases did what
it was hinted to do.

On the gcc < 4.0 an its ability to inline properly...
It has been accepted on this list for a long time that
gcc < 4.0 is bad at inlining.
This may be wrong or it may be rigth - I dunno.
But when sending in a patch that suddenly breaks with this
assumption then it should at least be followed with some
kind of information why it does not fail with gcc < 4.0.
And please stop pushing it back to others because this
is stuff that should be in the initial patch submission.

...

> Provocation is the only way of communication that works on this list.

So this was pure time waste. Thanks!
Please do not waste my time answering this.

	Sam
