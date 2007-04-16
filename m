Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXDPQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXDPQNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXDPQNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:13:46 -0400
Received: from holomorphy.com ([66.93.40.71]:40427 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030810AbXDPQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:13:46 -0400
Date: Mon, 16 Apr 2007 09:13:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416161326.GJ2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415152643.GH8915@holomorphy.com> <46239C62.4090302@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46239C62.4090302@nortel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> The sorts of like explicit decisions I'd like to be made for these are:
>> (1) In a mixture of tasks with varying nice numbers, a given nice number
>>	corresponds to some share of CPU bandwidth. Implementations
>>	should not have the freedom to change this arbitrarily according
>>	to some intention.

On Mon, Apr 16, 2007 at 09:55:14AM -0600, Chris Friesen wrote:
> The first question that comes to my mind is whether nice levels should 
> be linear or not.  I would lean towards nonlinear as it allows a wider 
> range (although of course at the expense of precision).  Maybe something 
> like "each nice level gives X times the cpu of the previous"?  I think a 
> value of X somewhere between 1.15 and 1.25 might be reasonable.
> What about also having something that looks at latency, and how latency 
> changes with niceness?
> What about specifying the timeframe over which the cpu bandwidth is 
> measured?  I currently have a system where the application designers 
> would like it to be totally fair over a period of 1 second.  As you can 
> imagine, mainline doesn't do very well in this case.

It's unclear how latency enters the picture as the semantics of nice
levels relevant to such are essentially priority preemption, which is
not particularly easy to mess up. I suppose tests to ensure priority
preemption occurs properly are in order.

I don't really have a preference regarding specific semantics for nice
numbers, just that they should be deterministic and specified somewhere.
It's not really for us to decide what those semantics are as it's more
of a userspace ABI/API issue.

The timeframe is also relevant, but I suspect it's more of a performance
metric than a strict requirement.


-- wli
