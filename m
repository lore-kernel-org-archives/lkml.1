Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXDIN1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXDIN1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXDIN1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:27:20 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46322 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXDIN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:27:19 -0400
Date: Mon, 9 Apr 2007 15:27:17 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070409132717.GA10489@rhlx01.hs-esslingen.de>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461A2E39.8060106@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 09, 2007 at 02:14:49PM +0200, Rene Herman wrote:
> This turned into an interactivity thing, and while interactivity is in 
> fact better for a large majority of testers, that isn't what Kolivas' 
> scheduler is about. It's about predictability and leaving the dead-end 
> road of these endlesss tweaks, which then break previous tweaks, rinse, 
> repeat.
> 
> It's unfortunate that Kolivas is having health problems currently, but I 
> certainly do hope that his scheduler finds its way into _a_ -rc1. He 
> said it was done...

The whole recent discussion/flamefest/... here makes me think that we're
still heading towards actually introducing plugsched (most preferrably
by making mainline scheduler the builtin default and optionally building
a plugsched kernel which then allows selection).
There are fundamental behavioural differences between the various
CPU scheduler types developed; while some people want a very interactive
system with in most(!) cases good latency and exploit-less operation,
several others want a scheduler which provides very predictable latency,
low overhead and additionally as much interactivity as this strict
model can provide for. And then there are people who have very specific
SMP requirements which both characteristic scheduler types may have trouble
satisfying properly.

And I really don't see much difference whatsoever to the I/O scheduler
area: some people want predictable latency, while others want maximum
throughput or fastest operation for seek-less flash devices (noop).
Hardware varies similarly greatly has well:
Some people have huge disk arrays or NAS, others have a single flash disk.
Some people have a decaying UP machine, others have huge SMP farms.

IMHO both areas are too varied, thus runtime or compile-time selection
is justified for both areas, not simply for I/O schedulers only.
I don't think anybody would want to introduce new very similar scheduler types
just for the fun of it; development would center around improving the at
most 3 or 4 different scheduler implementations (as is the case with I/O
schedulers, BTW: there hasn't been an explosion of different variants
either!).

I think the whole discussion went on the wrong track when people somehow
had the notion of making RSDL (and its later variants) the main scheduler
for desktop machines, not just server operation. And this target of course
(and rightfully so) prompted people to ask for interactivity similar
to what the current scheduler achieves which RSDL cannot fully provide
within its strict design, however.

However having mainline remain the only scheduler doesn't seem to be such
an attractive option either, e.g. due to its non-predictability, when there
exist several alternatives with rather nice behaviour.

Thus I'd still tend towards making things runtime-selectable, scheduler goals
are just too varied to ever sufficiently achieve Best Results
In Every Area (tm).

Not to mention that making schedulers runtime-selectable would enable
uncovering various application timing bugs much faster (e.g. the RPM timing
issues that -ck managed to hit).

Oh, and get well very soon, Con, Linux needs you, a lot :)

Andreas Mohr
