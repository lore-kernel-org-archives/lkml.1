Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXDIGXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXDIGXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 02:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXDIGXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 02:23:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:35639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752994AbXDIGXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 02:23:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX187hBB4Lb47jAo9RTZCqRhQ5c53HteoZbGHCVEJ9/
	F1mZvSkN2//n8K
Subject: Re: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704082134.43029.a1426z@gawab.com>
References: <200704082134.43029.a1426z@gawab.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 08:23:17 +0200
Message-Id: <1176099797.6355.122.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 21:34 +0300, Al Boldi wrote:
> Mike Galbraith wrote:
> > On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:
> > > I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> > > here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> > > starving 10% duty cycle task has trouble getting 1% CPU.
> >
> > Hmm.  Playing with it some more today, it still happens, but it's not
> > very repeatable.  Something is odd.  I wonder if any SD using readers
> > will try it.
> 
> Tried it on mainline 2.6.20.3.
> It's not easily repeatable, but it's got the same problem.
> 
> top - 21:21:45 up 27 min,  0 users,  load average: 0.80, 0.43, 0.20
> Tasks:  45 total,   3 running,  42 sleeping,   0 stopped,   0 zombie
> Cpu(s):  24.3% user,   0.5% system,   0.0% nice,  75.0% idle,   0.2% IO-wait
> Mem:    499488k total,    27352k used,   472136k free,     1996k buffers
> Swap:  1020088k total,        0k used,  1020088k free,     9160k cached
> 
>   PID  PR  NI  VIRT  RES  SHR SWAP nFLT nDRT WCHAN     S %CPU    TIME+  Command 
>   688  25   0  1804  412  352 1392    0    0 rest_init R 94.7   2:37.01 fairtest
>   689  15   0  1804  264  204 1540    0    0 rest_init R  0.0   0:00.79 fairtest

Aha!  Thanks a bunch for testing it.  (thing was irritating me greatly)

	-Mike

