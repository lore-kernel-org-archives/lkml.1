Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXERHdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXERHdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXERHdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:33:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXERHda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:33:30 -0400
Date: Fri, 18 May 2007 09:31:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070518073147.GC28702@elte.hu>
References: <20070513153853.GA19846@elte.hu> <20070518001841.GA21140@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518001841.GA21140@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> On Sun, May 13, 2007 at 05:38:53PM +0200, Ingo Molnar wrote:
> > Even a simple 3D app like glxgears does a sys_sched_yield() for 
> > every frame it generates (!) on certain 3D cards, which in essence 
> > punishes any scheduler that implements sys_sched_yield() in a sane 
> > manner. This interaction of CFS's yield implementation with this 
> > user-space bug could be the main reason why some testers reported SD 
> > to be handling 3D games better than CFS. (SD uses a yield 
> > implementation similar to the vanilla scheduler.)
> > 
> > So i've added a yield workaround to -v12, which makes it work 
> > similar to how the vanilla scheduler and SD does it. (Xorg has been 
> > notified and this bug should be fixed there too. This took some time 
> > to debug because the 3D driver i'm using for testing does not use 
> > sys_sched_yield().) The workaround is activated by default so -v12 
> > should work 'out of the box'.
> 
> This is an incorrect analysis. [...]

i'm puzzled, incorrect in specifically what way?

> [...] OpenGL has the ability to "yield" after every frame specifically 
> for SGI IRIX (React/Pro) frame scheduler (driven by the system 
> vertical retrace interrupt) so that it can free up CPU resources for 
> other tasks to run. [...]

what you say makes no sense to me. The majority of Linux 3D apps are 
already driven by the vertical retrace interrupt and properly 'yield the 
CPU' if they wish so, but this has nothing to do with sys_sched_yield().

> The correct solution is for the app to use a directed yield and a 
> policy that can directly support it so that OpenGL can guaratee a 
> frame rate governed by CPU bandwidth allocated by the scheduler.
> 
> Will is working on such a mechanism now.

i'm even more puzzled. I've added sched_yield_to() to CFS -v6 and it's 
been part of CFS since then. I'm curious, on what mechanism is Will 
working and have any patches been sent to lkml for discussion?

	Ingo
