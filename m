Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXECIiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXECIiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXECIiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:38:10 -0400
Received: from [212.12.190.206] ([212.12.190.206]:33064 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932409AbXECIiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:38:08 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Thu, 3 May 2007 11:42:02 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu>
In-Reply-To: <20070503074552.GA14960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031142.02550.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > i'm pleased to announce release -v7 of the CFS scheduler patchset.
> > > (The main goal of CFS is to implement "desktop scheduling" with as
> > > high quality as technically possible.)
> > >
> > >
> > > As usual, any sort of feedback, bugreport, fix and suggestion is
> > > more than welcome,
> >
> > This one seems on par with SD, [...]
>
> excellent :-)
>
> > [...] but there are still some nice issues.
> >
> > Try running 3 chew.c's, then renicing one to -10, starves others for
> > some seconds while switching prio-level.  Now renice it back to 10, it
> > starves for up to 45sec.
>
> ok - to make sure i understood you correctly: does this starvation only
> occur right when you renice it (when switching prio levels),

Yes.

> and it gets
> rectified quickly once they get over a few reschedules?

Well, depending on nice level this delay may be more than 45sec.

And, in cfs-v8 there is an additional repeating latency blip akin to an 
expiry when running procs at different nice levels.  chew.c shows this 
clearly.

> > Also, nice levels are only effective on every other step; ie:
> >  ... -3/-2 , -1/0 , 1/2 ... yields only 20 instead of 40 prio-levels.
>
> yeah - this is a first-approximation thing.
>
> Some background: in the upstream scheduler (and in SD) nice levels are
> linearly scaled, while in CFS they are exponentially scaled. I did this
> because i believe exponential is more logical: regardless of which nice
> level a task uses, if it goes +2 nice levels up then it will halve its
> "fair CPU share". So for example the CPU consumption delta between nice
> 0 and nice +10 is 1/32 - and so is the delta between -5 and +5, -10 and
> -5, etc. This makes nice levels _alot_ more potent than upstream's
> linear approach.

Actually, I think 1/32 for +10 is a bit to strong.  Introducing a scalefactor 
tunable may be useful.

Also, don't you think it reasonable to lower-bound the timeslices?


Thanks!

--
Al

