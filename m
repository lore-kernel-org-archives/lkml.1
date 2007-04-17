Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXDQGPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXDQGPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDQGPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:15:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXDQGPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:15:05 -0400
Date: Tue, 17 Apr 2007 08:15:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417061503.GC1057@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417060955.GO8915@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:09:55PM -0700, William Lee Irwin III wrote:
> On Tue, Apr 17, 2007 at 02:17:22PM +1000, Peter Williams wrote:
> >> I myself was thinking of this as the chance for a much needed 
> >> simplification of the scheduling code and if this can be done with the 
> >> result being "reasonable" it then gives us the basis on which to propose 
> >> improvements based on the ideas of others such as you mention.
> >> As the size of the cpusched indicates, trying to evaluate alternative 
> >> proposals based on the current O(1) scheduler is fraught.  Hopefully, 
> 
> On Tue, Apr 17, 2007 at 06:29:54AM +0200, Nick Piggin wrote:
> > I don't know why. The problem is that you can't really evaluate good
> > proposals by looking at the code (you can say that one is bad, ie. the
> > current one, which has a huge amount of temporal complexity and is
> > explicitly unfair), but it is pretty hard to say one behaves well.
> > And my scheduler for example cuts down the amount of policy code and
> > code size significantly. I haven't looked at Con's ones for a while,
> > but I believe they are also much more straightforward than mainline...
> > For example, let's say all else is equal between them, then why would
> > we go with the O(logN) implementation rather than the O(1)?
> 
> All things are not equal; they all have different properties. I like

Exactly. So we have to explore those properties and evaluate performance
(in all meanings of the word). That's only logical.


> On a random note, limitations on kernel address space make O(lg(n))
> effectively O(1), albeit with large upper bounds on the worst case
> and an expected case much faster than the worst case.

Yeah. O(n!) is also O(1) if you can put an upper bound on n ;)

