Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbYBKT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbYBKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbYBKT6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:58:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:55804 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758858AbYBKT6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:58:51 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZmDcYN78ZlOlg5wWudRzl+aglxquVzAE4OXiNUb
	oNNFfd+cLlzCz0
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Olof Johansson <olof@lixom.net>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080211172648.GA7962@lixom.net>
References: <1202543920.9578.3.camel@homer.simson.net>
	 <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net>
	 <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net>
	 <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net>
	 <20080210061558.GC22137@1wt.eu> <20080210070056.GA6401@lixom.net>
	 <1202717755.21339.65.camel@homer.simson.net>
	 <20080211172648.GA7962@lixom.net>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 20:58:46 +0100
Message-Id: <1202759926.4165.31.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 11:26 -0600, Olof Johansson wrote: 
> On Mon, Feb 11, 2008 at 09:15:55AM +0100, Mike Galbraith wrote:
> > Piddling around with your testcase, it still looks to me like things
> > improved considerably in latest greatest git.  Hopefully that means
> > happiness is in the pipe for the real workload... synthetic load is
> > definitely happier here as burst is shortened.
> 
> The real workload doesn't see much of an improvement. The changes I did
> when tinkering yesterday seem like they're better at modelling just
> what's going on with that one.

So the real application is trying to yield?  If so, you could try
prodding /proc/sys/kernel/sched_compat_yield.

It shouldn't matter if you yield or not really, that should reduce the
number of non-work spin cycles wasted awaiting preemption as threads
execute in series (the problem), and should improve your performance
numbers, but not beyond single threaded.

If I plugged a yield into the busy wait, I would expect to see a large
behavioral difference due to yield implementation changes, but that
would only be a symptom in this case, no?  Yield should be a noop.

	-Mike

