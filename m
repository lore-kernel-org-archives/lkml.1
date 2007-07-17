Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXGQACg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXGQACg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXGQAC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:02:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3364 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbXGQAC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:02:28 -0400
Date: Tue, 17 Jul 2007 02:02:03 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716222909.GA30906@elte.hu>
Message-ID: <Pine.LNX.4.64.0707170047230.1817@scrub.home>
References: <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu>
 <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu>
 <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org>
 <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home>
 <20070716222909.GA30906@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 17 Jul 2007, Ingo Molnar wrote:

> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > Hi,
> > 
> > On Mon, 16 Jul 2007, Ingo Molnar wrote:
> > 
> > > and note that even on the old scheduler, nice-0 was "3200% more 
> > > powerful" than nice +19 (with CONFIG_HZ=300),
> > 
> > How did you get that value? At any HZ the ratio should be around 1:10 
> > (+- rounding error).
> 
> you are wrong again. I sent you the numbers earlier today already:
> 
> |   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> |  2332 mingo     25   0  1580  248  196 R 95.1  0.0   0:11.84 loop
> |  2335 mingo     39  19  1576  244  196 R  3.1  0.0   0:00.39 loop
> 
> 3.1% is 3067% more than 95.1%, and the ratio is 1:30.67. You again deny 
> above that this is the case, and there's nothing i can do about your 
> denial of facts - that is your own private problem.

Ingo, how am I supposed to react to this? I'm asking a simple question
and I get this? I'm at serious loss how to deal with you. :-(

Above is based on theoritical values, for a 300HZ kernel these two 
processes should get 30 and 3 ticks. Should there be any rounding error or 
off by one error so that the processes get one tick less than they should 
get or one tick is accounted to the wrong process, my theoritical value is 
still within the possible error range and doesn't contradict your
practical values.
Playing around with some other nice levels, confirms the theory that 
something is a little off, so I'm quite correct at saying that the ratio 
_should_ be 1:10.
OTOH you are the one who is wrong about me (again). :-(

bye, Roman
