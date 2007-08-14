Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbXHNRns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbXHNRns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXHNRni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:43:38 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:46374 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbXHNRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:43:38 -0400
X-Greylist: delayed 1122 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 13:43:37 EDT
Date: Tue, 14 Aug 2007 19:24:53 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dst cache overflow
Message-Id: <20070814192453.5a873723.dada1@cosmosbay.com>
In-Reply-To: <20070814160646.GA16283@yamamaya.is-a-geek.org>
References: <20070814160646.GA16283@yamamaya.is-a-geek.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 18:06:46 +0200
Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:

> Hello,
> 
> I suspect I'm seeing a slow dst cache leakage on one of my servers.
> The server in question (oni) regularly needs to be rebooted, because
> it loses network connectivity. However, netconsole and syslog shows that the
> machine is still running and the kernel complains about "dst cache
> overflow".
> 
> I have since installed a monitoring script, which stores the output of
> both "ip route ls cache | fgrep cache | wc -l" and the 'entries' value
> of /proc/net/stat/rt_cache (as suggested in 
> http://www.mail-archive.com/netdev@vger.kernel.org/msg02107.html)
> and produces a nice rrd graph:
> 
> http://uguu.de/~ranma/route-month-oni.png
> So entries is growing more or less constantly, while the number of
> active routes (not visible on the graph due to being too small) is
> relatively constant.
> 
> Comparing this to another host running the exact same kernel:
> http://uguu.de/~ranma/route-month-ari.png
> Here cached_routes and entries barely differ at all.
> 
> The funny thing is, both hosts are running the exact same kernel
> and use more or less the same iptables rules.
> 
> So I'm not sure what would cause the dst cache to leak only on host
> oni?
> 

Could you send the result of these commands on oni and ari ?

ip route ls
grep . /proc/sys/net/ipv4/route/*

