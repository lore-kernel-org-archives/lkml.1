Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYBKRZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYBKRZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbYBKRYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:24:54 -0500
Received: from lixom.net ([66.141.50.11]:45417 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbYBKRYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:24:53 -0500
Date: Mon, 11 Feb 2008 11:26:48 -0600
From: Olof Johansson <olof@lixom.net>
To: Mike Galbraith <efault@gmx.de>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080211172648.GA7962@lixom.net>
References: <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net> <20080210061558.GC22137@1wt.eu> <20080210070056.GA6401@lixom.net> <1202717755.21339.65.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202717755.21339.65.camel@homer.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:15:55AM +0100, Mike Galbraith wrote:
> Piddling around with your testcase, it still looks to me like things
> improved considerably in latest greatest git.  Hopefully that means
> happiness is in the pipe for the real workload... synthetic load is
> definitely happier here as burst is shortened.

The real workload doesn't see much of an improvement. The changes I did
when tinkering yesterday seem like they're better at modelling just
what's going on with that one.

I've added the new testcase I'm using for the numbers I posted last
night at http://lixom.net/~olof/threadtest/new/, including numbers for
the various kernels. I also included the binaries I built. (with "gcc
-DLOOPS=<size> testcase.c -lpthread").

I tried graphing the numbers as well, it looks like for larger workloads
that 2.6.22 has a fixed benefit over newer kernels. I.e. it seems quicker
at rebalancing, but once things balance out they're obviously doing ok
independent of kernel version.

Graph at http://lixom.net/olof/threadtest/new/schedgraph.pdf. I couldn't
figure out how to make the X axis linear, so it obviously looks odd with
the current powers-of-two at the end instead of linear, but the
differences can still be seen clearly.


-Olof

