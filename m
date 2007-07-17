Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbXGQHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbXGQHy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXGQHyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:54:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47165 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXGQHyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:54:15 -0400
Date: Tue, 17 Jul 2007 09:53:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070717075346.GB13539@elte.hu>
References: <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org> <Pine.LNX.4.64.0707162304330.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707162304330.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > > It's nice that these artifacts are gone, but that still doesn't 
> > > explain why this ratio had to be increase that much from around 
> > > 1:10 to 1:69.
> > 
> > More dynamic range is better? If you actually want a task to get 20x 
> > the CPU time of another, the older scheduler doesn't really allow 
> > it.
> 
> You can already have that, the complete range level from 19 to -20 was 
> about 1:80.

But that is irrelevant: all tasks start out at nice 0, and what matters 
is the dynamic range around 0.

So the dynamic range has been made uniform in the positive from 
1:10...1:20...1:30 to 1:69 for nice +19, and from 1:8 to 1:69 in the 
minus. (with 1:86 nice -20) If you look at the negative nice levels 
alone it's a substantial increase but if you compare it with positive 
nice levels you'll similar kinds of dynamic ranges were already present 
in the old scheduler and you'll see why we've done it.

Negative nice levels are admin-controlled, the increase in the negative 
levels is is not a big issue and people actually like the increased 
dynamic range and the consistency. The positive range _might_ be a 
bigger issue but there we were largely inconsistent anyway, and again, 
people like the increased dynamic range.

	Ingo
