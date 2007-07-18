Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXGRK2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXGRK2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXGRK1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:27:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXGRK1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:27:54 -0400
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
References: <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu>
	 <20070716070610.GA10907@elte.hu>
	 <Pine.LNX.4.64.0707161213500.1817@scrub.home>
	 <20070716112037.GA6895@elte.hu>
	 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
	 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 12:27:10 +0200
Message-Id: <1184754430.20032.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 10:47 -0700, Linus Torvalds wrote:
> 
> On Mon, 16 Jul 2007, Roman Zippel wrote:
> >
> > To illustrate the problem a little different: a task with a nice level -20 
> > got around 700% more cpu time (or 8 times more), now it gets 8500% more 
> > cpu time (or 86.7 times more).
> 
> Ingo, that _does_ sound excessive. 
> 
> How about trying a much less aggressive nice-level (and preferably linear, 
> not exponential)?

I actually like the extra range, it allows for a much softer punch of
background tasks even on somewhat slower boxen.

I've been testing CFS on my 1200 MHz lappy for some time and a strongly
niced kbuild leaves a very usable system. 

The old scheduler would leave the thing rather jumpy. And while CFS
fully fixes the jumpyness, I just did a nice +13 (which should be
equivalent to the old schedulers nice +19 for my HZ) and did a nice +19
kbuild and I can definitely feel the difference between them.

Early CFS versions had an pretty aggressive nice range (0.1% for +19),
and that has been toned down based on feedback. The current levels seem
to work well, at least on my boxen.

- Peter

