Return-Path: <linux-kernel-owner+w=401wt.eu-S1161661AbXDXGVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161661AbXDXGVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161664AbXDXGVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:21:38 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:43474 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161661AbXDXGVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:21:37 -0400
Message-ID: <462DA1E8.9080201@bigpond.net.au>
Date: Tue, 24 Apr 2007 16:21:28 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu>	 <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>	 <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr>	 <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>	 <20070423013429.GB25162@wotan.suse.de>	 <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>	 <20070423191143.GA16849@elte.hu>	 <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>	 <462D7D8F.7000401@bigpond.net.au> <1177390323.3244.16.camel@laptopd505.fenrus.org>
In-Reply-To: <1177390323.3244.16.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 24 Apr 2007 06:21:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> Within reason, it's not the number of clients that X has that causes its 
>> CPU bandwidth use to sky rocket and cause problems.  It's more to to 
>> with what type of clients they are.  Most GUIs (even ones that are 
>> constantly updating visual data (e.g. gkrellm -- I can open quite a 
>> large number of these without increasing X's CPU usage very much)) cause 
>> very little load on the X server.  The exceptions to this are the 
> 
> 
> there is actually 2 and not just 1 "X server", and they are VERY VERY
> different in behavior.
> 
> Case 1: Accelerated driver
> 
> If X talks to a decent enough card it supports will with acceleration,
> it will be very rare for X itself to spend any kind of significant
> amount of CPU time, all the really heavy stuff is done in hardware, and
> asynchronously at that. A bit of batching will greatly improve system
> performance in this case.
> 
> Case 2: Unaccelerated VESA
> 
> Some drivers in X, especially the VESA and NV drivers (which are quite
> common, vesa is used on all hardware without a special driver nowadays),
> have no or not enough acceleration to matter for modern desktops. This
> means the CPU is doing all the heavy lifting, in the X program. In this
> case even a simple "move the window a bit" becomes quite a bit of a CPU
> hog already.

Mine's a:

SiS 661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display adapter according 
to X's display settings tool.  Which category does that fall into?

It's not a special adapter and is just the one that came with the 
motherboard. It doesn't use much CPU unless I grab a window and wiggle 
it all over the screen or do something like "ls -lR /" in an xterm.

> 
> The cases are fundamentally different in behavior, because in the first
> case, X hardly consumes the time it would get in any scheme, while in
> the second case X really is CPU bound and will happily consume any CPU
> time it can get.

Which still doesn't justify an elaborate "points" sharing scheme. 
Whichever way you look at that that's just another way of giving X more 
CPU bandwidth and there are simpler ways to give X more CPU if it needs 
it.  However, I think there's something seriously wrong if it needs the 
-19 nice that I've heard mentioned.  You might as well just run it as a 
real time process.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
