Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXCMLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXCMLXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXCMLXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:23:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:57085 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753233AbXCMLXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:23:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/VbL1u2HDV6D/rFmDtvUSI+XoUTwAjXoXvanv4No
	L3akRqgYvlXlTq
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703132106.08878.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173778398.6810.21.camel@Homer.simpson.net>
	 <20070313093914.GA10533@elte.hu>  <200703132106.08878.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 12:23:26 +0100
Message-Id: <1173785006.8561.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 21:06 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 20:39, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > > I just retested with the encoders at nice 0, and the x/gforce combo is
> > > terrible. [...]
> >
> > ok. So nice levels had nothing to do with it - it's some other
> > regression somewhere. How does the vanilla scheduler cope with the
> > exactly same workload? I.e. could you describe the 'delta' difference in
> > behavior - because the delta is what we are interested in mostly, the
> > 'absolute' behavior alone is not sufficient. Something like:
> >
> >  - on scheduler foo, under this workload, the CPU hogs steal 70% CPU
> >    time and the resulting desktop experience is 'choppy': mouse pointer
> >    is laggy and audio skips.
> >
> >  - on scheduler bar, under this workload, the CPU hogs are at 40%
> >    CPU time and the desktop experience is smooth.
> >
> > things like that - we really need to be able to see the delta.
> 
> I only find a slowdown, no choppiness, no audio stutter (it would be extremely 
> hard to make audio stutter in this design without i/o starvation or something 
> along those lines). The number difference in cpu percentage I've already 
> given on the previous email. The graphics driver does feature in this test 
> case as well so others' mileage may vary. Mike said it was terrible.

My first test run with lame at nice 0 was truly horrid, but has _not_
repeated, so disregard that as an anomaly.  For the most part, it is as
you say, things just get slower with load, any load.  I definitely am
seeing lurchiness which is not present in mainline.  No audio problems
with either kernel.

> > > [...]  Funny thing though, x/gforce isn't as badly affected with a
> > > kernel build.  Any build is quite noticable, but even at -j8, the
> > > effect doen't seem to be (very brief test warning applies) as bad as
> > > with only the two encoders running.  That seems quite odd.
> >
> > likewise, how does the RSDL kernel build behavior compare to the vanilla
> > scheduler's behavior? (what happens in one that doesnt happen in the
> > other, etc.)
> 
> Kernel compiles seem similar till the jobs get above about 3 where rsdl gets 
> slower but still smooth. Audio is basically unaffected either way.

It seems to be a plain linear slowdown.  The lurchiness I'm experiencing
varies in intensity, and is impossible to quantify.  I see neither
lurchiness nor slowdown in mainline through -j8.

> Don't forget all the rest of the cases people have posted.

Absolutely, all test results count.

	-Mike

