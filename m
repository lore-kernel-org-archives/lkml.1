Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbXDIJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbXDIJ5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXDIJ5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:57:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:50771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750882AbXDIJ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:57:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YckdjxV+YNlnQeKkU9XtVq1UFvKL594l5RZR1n1
	c7YlFlOp0CjzG9
Subject: Re: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0704090220p60c49ec9w8eb1083943526155@mail.gmail.com>
References: <200704082134.43029.a1426z@gawab.com>
	 <1176099797.6355.122.camel@Homer.simpson.net>
	 <b647ffbd0704090220p60c49ec9w8eb1083943526155@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 11:57:32 +0200
Message-Id: <1176112652.10120.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 11:20 +0200, Dmitry Adamushko wrote:
> On 09/04/07, Mike Galbraith <efault@gmx.de> wrote:
> > On Sun, 2007-04-08 at 21:34 +0300, Al Boldi wrote:
> > > Mike Galbraith wrote:
> > > > On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:
> > > > > I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> > > > > here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> > > > > starving 10% duty cycle task has trouble getting 1% CPU.
> > > >
> > > > Hmm.  Playing with it some more today, it still happens, but it's not
> > > > very repeatable.  Something is odd.  I wonder if any SD using readers
> > > > will try it.
> > >
> > > Tried it on mainline 2.6.20.3.
> > > It's not easily repeatable, but it's got the same problem.
> 
> In my case, it's easily reproducible. Below is a mainline 2.6.19.
> 
> Look at both %CPU and TIME+ (sched_time).

Yeah, 23.7% idle.  Hrm.

> top - 10:55:00 up 33 min,  8 users,  load average: 1.07, 0.61, 0.51
> Tasks:  76 total,   2 running,  74 sleeping,   0 stopped,   0 zombie
> Cpu(s): 76.0% us,  0.3% sy,  0.0% ni, 23.7% id,  0.0% wa,  0.0% hi,  0.0% si
> Mem:    256592k total,   251888k used,     4704k free,    46516k buffers
> Swap:   272120k total,     4924k used,   267196k free,    90048k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  8113 dimm      15   0  1460  436  360 R 74.4  0.2   1:43.63 fairtest_xx
>  8114 dimm      15   0  1460  108   32 S  0.3  0.0   0:00.15 fairtest_xx
> 
> 
> If you take a look at my previous report, you'll also notice
> "strangeness" with both cpu% and sched_time.
> 
> sched_clock() is based on "tsc" and it's available for my CPU. So
> maybe something fishy is going on with accounting.

Yeah.  There's a patch floating around that is supposed to fix some of
the error.  I'm going to test with it, and I'm rummaging around a bit as
well.  I know for sure that frequency scaling will screw up the test
proggy's calibration here, but I test with it locked to max, and in any
case the hog half should eat any cpu not being used by the tenp half.

	-Mike

