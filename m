Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXDQGKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXDQGKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXDQGKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:10:08 -0400
Received: from holomorphy.com ([66.93.40.71]:43946 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXDQGKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:10:07 -0400
Date: Mon, 16 Apr 2007 23:09:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417060955.GO8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417042954.GG25513@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 02:17:22PM +1000, Peter Williams wrote:
>> I myself was thinking of this as the chance for a much needed 
>> simplification of the scheduling code and if this can be done with the 
>> result being "reasonable" it then gives us the basis on which to propose 
>> improvements based on the ideas of others such as you mention.
>> As the size of the cpusched indicates, trying to evaluate alternative 
>> proposals based on the current O(1) scheduler is fraught.  Hopefully, 

On Tue, Apr 17, 2007 at 06:29:54AM +0200, Nick Piggin wrote:
> I don't know why. The problem is that you can't really evaluate good
> proposals by looking at the code (you can say that one is bad, ie. the
> current one, which has a huge amount of temporal complexity and is
> explicitly unfair), but it is pretty hard to say one behaves well.
> And my scheduler for example cuts down the amount of policy code and
> code size significantly. I haven't looked at Con's ones for a while,
> but I believe they are also much more straightforward than mainline...
> For example, let's say all else is equal between them, then why would
> we go with the O(logN) implementation rather than the O(1)?

All things are not equal; they all have different properties. I like
getting rid of the queue-swapping artifacts as ebs and cfs have done,
as the artifacts introduced there are nasty IMNSHO. I'm queueing up
a demonstration of epoch expiry scheduling artifacts as a testcase,
albeit one with no pass/fail semantics for its results, just detecting
scheduler properties.

That said, inequality/inequivalence is not a superiority/inferiority
ranking per se. What needs to come out of these discussions is a set
of standards which a candidate for mainline must pass to be considered
correct and a set of performance metrics by which to rank them. Video
game framerates and some sort of way to automate window wiggle tests
sound like good ideas, but automating such is beyond my userspace
programming abilities. An organization able to devote manpower to
devising such testcases will likely have to get involved for them to
happen, I suspect.

On a random note, limitations on kernel address space make O(lg(n))
effectively O(1), albeit with large upper bounds on the worst case
and an expected case much faster than the worst case.


-- wli
