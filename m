Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZAAJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZAAJct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 04:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZAAJcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 04:32:41 -0500
Received: from waste.org ([66.93.16.53]:33456 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbZAAJck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 04:32:40 -0500
Subject: Re: random.c changes for sparse irq_desc are crap
From: Matt Mackall <mpm@selenic.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <86802c440812311614n4a0ef459u4bb8be65d33994a@mail.gmail.com>
References: <1230748169.19620.132.camel@calx> <495BFB48.8080506@kernel.org>
	 <1230766826.19620.150.camel@calx>
	 <86802c440812311614n4a0ef459u4bb8be65d33994a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 03:31:56 -0600
Message-Id: <1230802316.3204.4.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 16:14 -0800, Yinghai Lu wrote:
> On Wed, Dec 31, 2008 at 3:40 PM, Matt Mackall <mpm@selenic.com> wrote:
> > On Wed, 2008-12-31 at 15:07 -0800, Yinghai Lu wrote:
> >> Matt Mackall wrote:
> >> > I just noticed you merged a change that pointlessly converts two
> >> > random.c functions into ugly random.h inlines without going through the
> >> > maintainer.
> >> >
> >> > I also don't like the look of the newly-introduced sparse variants of
> >> > these functions. Failure to find an irq descriptor in
> >> > get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
> >> > not something to silently ignore. Letting the code try to dereference
> >> > NULL is preferred here: we'll actually be able to find and fix the
> >> > broken driver that's throwing around meaningless irq vectors.
> >> >
> >> > Throwing away the timer_state pointer in the set_timer_rand_state
> >> > function is similarly bogus in addition to being a memory leak.
> >> >
> >> > Please fix this up.
> >> >
> >>
> >> want something like this?
> >
> > Not quite.
> >
> > First, please turn these back into normal functions in random.c.
> > Inlining functions is generally discouraged these days unless you have a
> > good reason and numbers to back it up.
> 
> Ingo wanted to hide that #ifdef to .h

Ahh. I think that makes sense in some situations, but I'd prefer not to
do that here. Some headers are actually meant to be more readable than
the corresponding .c file. Also, we still end up with an ifdef in the .c
file so we're not actually winning.

-- 
Mathematics is the supreme nostalgia of our time.

