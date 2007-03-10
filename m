Return-Path: <linux-kernel-owner+w=401wt.eu-S1767685AbXCJAep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767685AbXCJAep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767688AbXCJAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:34:45 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:36753 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767685AbXCJAep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:34:45 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 11:34:26 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703100918.05547.kernel@kolivas.org> <20070309222923.GK10394@waste.org>
In-Reply-To: <20070309222923.GK10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101134.26313.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 09:29, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 09:18:05AM +1100, Con Kolivas wrote:
> > On Saturday 10 March 2007 08:57, Con Kolivas wrote:
> > > On Saturday 10 March 2007 08:39, Matt Mackall wrote:
> > > > On Sat, Mar 10, 2007 at 08:19:18AM +1100, Con Kolivas wrote:
> > > > > On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> > > > > > On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> > > > > > > My suspicion is the problem lies in giving too much quanta to
> > > > > > > newly-started processes.
> > > > > >
> > > > > > Ah that's some nice detective work there. Mainline does some
> > > > > > rather complex accounting on sched_fork including (possibly) a
> > > > > > whole timer tick which rsdl does not do. make forks off
> > > > > > continuously so what you say may well be correct. I'll see if I
> > > > > > can try to revert to the mainline behaviour in sched_fork (which
> > > > > > was obviously there for a reason).
> > > > >
> > > > > Wow! Thanks Matt. You've found a real bug too. This seems to fix
> > > > > the qemu misbehaviour and bitmap errors so far too! Now can you
> > > > > please try this to see if it fixes your problem?
> > > >
> > > > Sorry, it's about the same. I now suspect an accounting glitch
> > > > involving pipe wake-ups.
> > > >
> > > > 5x memload: good
> > > > 5x execload: good
> > > > 5x forkload: good
> > > > 5 parallel makes: mostly good
> > > > make -j 5: bad
> > > >
> > > > So what's different between makes in parallel and make -j 5? Make's
> > > > job server uses pipe I/O to control how many jobs are running.
> > >
> > > Hmm it must be those deep pipes again then. I removed any quirks
> > > testing for those from mainline as I suspected it would be ok. Guess
> > > I"m wrong.
> >
> > I shouldn't blame this straight up though if NO_HZ makes it better.
> > Something else is going wrong... wtf though?
>
> Just so we're clear, dynticks has only 'fixed' the single non-parallel
> make load so far.

Ok, so some of the basics then. Can you please give me the output of 'top -b' 
running for a few seconds during the whole affair?

Thanks very much for your testing so far!

-- 
-ck
