Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXCLUMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXCLUMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXCLUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:12:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:44090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752851AbXCLUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:12:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DZn1mmbDDeoK17Wd9FqKinSQITY/V8iEX6L7jNC
	qk2sw/T6R4t9Cb
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703130549.47058.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <200703130549.47058.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 21:11:54 +0100
Message-Id: <1173730314.6431.30.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 05:49 +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 01:34, Mike Galbraith wrote:
> > On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:
> > > Mike the cpu is being proportioned out perfectly according to fairness as
> > > I mentioned in the prior email, yet X is getting the lower latency
> > > scheduling. I'm not sure within the bounds of fairness what more would
> > > you have happen to your liking with this test case?
> >
> > It has been said that "perfection is the enemy of good".  The two
> > interactive tasks receiving 40% cpu while two niced background jobs
> > receive 60% may well be perfect, but it's damn sure not good.
> 
> Again I think your test is not a valid testcase. Why use two threads for your 
> encoding with one cpu? Is that what other dedicated desktop OSs would do?

The testcase is perfectly valid.  My buddies box has two full cores, so
we used two encoders such that whatever bandwidth is not being actively
consumed by more important things gets translated into mp3 encoding.

How would you go about ensuring that there won't be any cycles wasted?
 
_My_ box has 1 core that if fully utilized translates to 1.2 cores.. or
whatever, depending on the phase of the moon.  But no matter, logical vs
physical cpu argument is pure hand-waving.  What really matters here is
the bottom line: your fair scheduler ignores the very real requirements
of interactivity.

> And let's not lose sight of things with this one testcase.
> 
> RSDL fixes
> - every starvation case
> - all fairness isssues
> - is better 95% of the time on the desktop

I don't know where you got that 95% number from.  For the most part, the
existing scheduler does well.  If it sucked 95% of the time, it would
have been shredded a long time ago.

> If we fix 95% of the desktop and worsen 5% is that bad given how much else 
> we've gained in the process?

Killing the known corner case starvation scenarios is wonderful, but
let's not just pretend that interactive tasks don't have any special
requirements.

	-Mike

