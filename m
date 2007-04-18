Return-Path: <linux-kernel-owner+w=401wt.eu-S2992691AbXDROtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992691AbXDROtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992692AbXDROtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:49:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992691AbXDROtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:49:32 -0400
Date: Wed, 18 Apr 2007 07:48:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Nick Piggin <npiggin@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418055525.GS11115@waste.org>
Message-ID: <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
References: <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
 <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
 <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Matt Mackall wrote:
> 
> Why is X special? Because it does work on behalf of other processes?
> Lots of things do this. Perhaps a scheduler should focus entirely on
> the implicit and directed wakeup matrix and optimizing that
> instead[1].

I 100% agree - the perfect scheduler would indeed take into account where 
the wakeups come from, and try to "weigh" processes that help other 
processes make progress more. That would naturally give server processes 
more CPU power, because they help others

I don't believe for a second that "fairness" means "give everybody the 
same amount of CPU". That's a totally illogical measure of fairness. All 
processes are _not_ created equal.

That said, even trying to do "fairness by effective user ID" would 
probably already do a lot. In a desktop environment, X would get as much 
CPU time as the user processes, simply because it's in a different 
protection domain (and that's really what "effective user ID" means: it's 
not about "users", it's really about "protection domains").

And "fairness by euid" is probably a hell of a lot easier to do than 
trying to figure out the wakeup matrix.

		Linus
