Return-Path: <linux-kernel-owner+w=401wt.eu-S1031229AbXDUOKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031229AbXDUOKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031235AbXDUOKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:10:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:44271 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031229AbXDUOKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:10:12 -0400
Message-ID: <462A1B12.8090001@tmr.com>
Date: Sat, 21 Apr 2007 10:09:22 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu> <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org> <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com> <20070418214816.GA10902@elte.hu> <Pine.LNX.4.64.0704181515290.25880@alien.or.mcafeemobile.com> <20070419080053.GA4106@elte.hu>
In-Reply-To: <20070419080053.GA4106@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Davide Libenzi <davidel@xmailserver.org> wrote:

>> The same user nicing two different multi-threaded processes would 
>> expect a predictable CPU distribution too. [...]
> 
> i disagree that the user 'would expect' this. Some users might. Others 
> would say: 'my 10-thread rendering engine is more important than a 
> 1-thread job because it's using 10 threads for a reason'. And the CFS 
> feedback so far strengthens this point: the default behavior of treating 
> the thread as a single scheduling (and CPU time accounting) unit works 
> pretty well on the desktop.
> 
If by desktop you mean "one and only one interactive user," that's true. 
On a shared machine it's very hard to preserve any semblance of fairness 
when one user gets far more than another, based not on the value of what 
they're doing but the tools they use to to it.

> think about it in another, 'kernel policy' way as well: we'd like to 
> _encourage_ more parallel user applications. Hurting them by accounting 
> all threads together sends the exact opposite message.
> 
Why is that? There are lots of things which are intrinsically single 
threaded, how are we hurting hurting multi-threaded applications by 
refusing to give them more CPU than an application running on behalf of 
another user? By accounting all threads together we encourage writing an 
application in the most logical way. Threads are a solution, not a goal 
in themselves.

>> [...] Doing that efficently (the old per-cpu run-queue is pretty nice 
>> from many POVs) is the real challenge.
> 
> yeah.
> 
> 	Ingo


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
