Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXHPQpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXHPQpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXHPQpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:45:05 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:39187 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761521AbXHPQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:45:03 -0400
Date: Thu, 16 Aug 2007 18:45:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dst cache overflow
Message-Id: <20070816184501.cbbd28a2.dada1@cosmosbay.com>
In-Reply-To: <20070814180015.GB3024@yamamaya.is-a-geek.org>
References: <20070814160646.GA16283@yamamaya.is-a-geek.org>
	<20070814192453.5a873723.dada1@cosmosbay.com>
	<20070814180015.GB3024@yamamaya.is-a-geek.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 20:00:15 +0200
Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:

> Eric Dumazet wrote:
> 
> > Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
> > 
> > > Hello,
> > > 
> > > I suspect I'm seeing a slow dst cache leakage on one of my servers.
> > > The server in question (oni) regularly needs to be rebooted, because
> > > it loses network connectivity. However, netconsole and syslog shows that the
> > > machine is still running and the kernel complains about "dst cache
> > > overflow".
> > > 
> > > I have since installed a monitoring script, which stores the output of
> > > both "ip route ls cache | fgrep cache | wc -l" and the 'entries' value
> > > of /proc/net/stat/rt_cache (as suggested in 
> > > http://www.mail-archive.com/netdev@vger.kernel.org/msg02107.html)
> > > and produces a nice rrd graph:
> > > 
> > > http://uguu.de/~ranma/route-month-oni.png
> > > So entries is growing more or less constantly, while the number of
> > > active routes (not visible on the graph due to being too small) is
> > > relatively constant.
> > > 
> > > Comparing this to another host running the exact same kernel:
> > > http://uguu.de/~ranma/route-month-ari.png
> > > Here cached_routes and entries barely differ at all.
> > > 
> > > The funny thing is, both hosts are running the exact same kernel
> > > and use more or less the same iptables rules.
> > > 
> > > So I'm not sure what would cause the dst cache to leak only on host
> > > oni?
> > > 
> > 
> > Could you send the result of these commands on oni and ari ?
> > 
> > ip route ls
> > grep . /proc/sys/net/ipv4/route/*
> 
> Sure.
> 
> AFAICS the only visible difference is gc_thresh, which is probably
> double the size on oni since oni has double the amount of memory
> (512MB for oni vs. 256MB for ari).

You might try to boot oni adding this to kernel commandline : rhash_entries=2047
so that oni has the same route cache hashtable, and see if it changes anything.

