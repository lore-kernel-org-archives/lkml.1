Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0APAss (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0APAsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:48:47 -0500
Received: from snt0-omc3-s38.snt0.hotmail.com ([65.55.90.177]:35967 "EHLO
	snt0-omc3-s38.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab0APAsr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:48:47 -0500
Message-ID: <SNT125-W1534D12CF3C73B12D3CA8DC3680@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Fri, 15 Jan 2010 16:48:47 -0800
Importance: Normal
In-Reply-To: <alpine.LFD.2.00.0912311019580.11961@localhost.localdomain>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<alpine.LFD.2.00.0912311019580.11961@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2010 00:48:47.0412 (UTC) FILETIME=[A97FDF40:01CA9645]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There's a potential secondary issue: my test-bed for that btrfs setup was
> a netbook using Intel Atom. The performance profile of an Atom chip is
> pretty different from any of the better out-of-order CPU's.
>
> Extra instructions cost a lot more. For example, out-of-order is
> particularly good at handling "nonsense" instructions that aren't on a
> critical path and aren't important for actual semantics - things like the
> stack frame modifications etc are often almost "free" on out-of-order
> CPU's because they only tend to have trivial dependencies that can be
> worked around with things like the "stack engine" etc. So I seem to
> remember that the "omit stack frame" option was a much bigger deal on Atom
> than on a Core 2 Duo CPU, for example.
>
> So it's entirely possible that the TLB flushing (and eventual misses, of
> course) involved with kmap()/kunmap() is much more expensive on Atom than
> it is on a Core2 system. So it's possible that my 25% cost thing was for
> pretty much a pessimal situation, due to a combination of heavy kernel
> loads (I used "git status" as one of the btrfs/atom benchmarks - pretty
> much _all_ it does is pathname lookups and readdir) with btrfs and atom.

Luckily, most Atom netbooks currently only ship with 1GB of RAM (partly due to restrictions imposed by MS), and even Intel's Pine Trail Atoms is limited to only 2GB of RAM. And the desktop version has always supported 64-bit, and now all Pine Trail Atoms support 64-bit too.
Disabling HIGHMEM however of course will disable NX which all Atoms have, unless you turn CONFIG_PAE back on.
 
Yuhong Bao
 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
http://clk.atdmt.com/GBL/go/196390709/direct/01/