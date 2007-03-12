Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXCLIaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXCLIaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCLIaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:30:03 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:38915 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965336AbXCLIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:30:00 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 19:29:39 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173684174.6659.13.camel@Homer.simpson.net> <200703121848.44714.kernel@kolivas.org>
In-Reply-To: <200703121848.44714.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121929.39702.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 18:48, Con Kolivas wrote:
> On Monday 12 March 2007 18:22, Mike Galbraith wrote:
> > On Sun, 2007-03-11 at 13:10 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > > Full patch for 2.6.21-rc3-mm2:
> > > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsd
> > > > >l- 0.29.patch
> > > >
> > > > I'm seeing a cpu distribution problem running this on my P4 box.
> > > >
> > > > With 2.6.21-rc3, X/Gforce maintain their ~50% cpu (remain smooth),
> > > > and the encoders (100%cpu bound) get whats left when Amarok isn't
> > > > eating it.
> > > >
> > > > I plunked the above patch into plain 2.6.21-rc3 and retested to
> > > > eliminate other mm tree differences, and it's repeatable.  The nice 5
> > > > cpu hogs always receive considerably more that the nice 0 sleepers.
> > >
> > > hm. Do you get the same same problem on UP too? (i.e. lets eliminate
> > > any SMP/HT artifacts)
> >
> > Behavior is slightly different with a UP kernel.  Neither encoder
> > receives more cpu than X, but they each still receive more than gforce.
> > The distribution of X/Gforce vs lame/lame averages per eyeball to
> > roughly ~50:50.
> >
> > I noticed Con posted an accounting fix, and applied it.  No change.
>
> So the lames are nice 5 which means they should receive 75% of the cpu that
> nice 0 tasks receive so they should get 43% of the cpu...
>
> Just a couple of questions;
>
> The X/Gforce case; do they alternate cpu between them? By that I mean when
> they're the only thing running does the cpu load summate to 1 or does it
> summate to 2?

I'll save you the trouble. I just checked myself and indeed the load is only 
1. What this means is that although there are 2 tasks running, only one is 
running at any time making a total load of 1. So, if we add two other tasks 
that add 2 more to the load the total load is 3. However if we weight the 
other two tasks at nice 5, they only add .75 each to the load making a 
weighted total of 2.5. This means that X+Gforce together should get a total 
of 1/2.5 or 40% of the overall cpu. That sounds like exactly what you're 
describing is happening.

-- 
-ck
