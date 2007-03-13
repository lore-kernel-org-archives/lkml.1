Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbXCMKGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbXCMKGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXCMKGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:06:45 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:34933 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbXCMKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:06:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 21:06:08 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173778398.6810.21.camel@Homer.simpson.net> <20070313093914.GA10533@elte.hu>
In-Reply-To: <20070313093914.GA10533@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132106.08878.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 20:39, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > I just retested with the encoders at nice 0, and the x/gforce combo is
> > terrible. [...]
>
> ok. So nice levels had nothing to do with it - it's some other
> regression somewhere. How does the vanilla scheduler cope with the
> exactly same workload? I.e. could you describe the 'delta' difference in
> behavior - because the delta is what we are interested in mostly, the
> 'absolute' behavior alone is not sufficient. Something like:
>
>  - on scheduler foo, under this workload, the CPU hogs steal 70% CPU
>    time and the resulting desktop experience is 'choppy': mouse pointer
>    is laggy and audio skips.
>
>  - on scheduler bar, under this workload, the CPU hogs are at 40%
>    CPU time and the desktop experience is smooth.
>
> things like that - we really need to be able to see the delta.

I only find a slowdown, no choppiness, no audio stutter (it would be extremely 
hard to make audio stutter in this design without i/o starvation or something 
along those lines). The number difference in cpu percentage I've already 
given on the previous email. The graphics driver does feature in this test 
case as well so others' mileage may vary. Mike said it was terrible.

> > [...]  Funny thing though, x/gforce isn't as badly affected with a
> > kernel build.  Any build is quite noticable, but even at -j8, the
> > effect doen't seem to be (very brief test warning applies) as bad as
> > with only the two encoders running.  That seems quite odd.
>
> likewise, how does the RSDL kernel build behavior compare to the vanilla
> scheduler's behavior? (what happens in one that doesnt happen in the
> other, etc.)

Kernel compiles seem similar till the jobs get above about 3 where rsdl gets 
slower but still smooth. Audio is basically unaffected either way.

Don't forget all the rest of the cases people have posted.

-- 
-ck
