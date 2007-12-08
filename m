Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbXLHPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbXLHPGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXLHPGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:06:39 -0500
Received: from rtr.ca ([76.10.145.34]:4103 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbXLHPGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:06:39 -0500
Message-ID: <475AB2FD.30600@rtr.ca>
Date: Sat, 08 Dec 2007 10:06:37 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, stefano.brivio@polimi.it,
       Nick Piggin <nickpiggin@yahoo.com.au>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <200712072213.06530.nickpiggin@yahoo.com.au> <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it> <20071207122516.GA25115@elte.hu> <20071207123509.GA28676@elte.hu> <20071207124034.GA30052@elte.hu> <20071207145418.GA22277@elte.hu> <20071207174649.39c9198d@inria.fr> <20071207175754.GB19173@elte.hu>
In-Reply-To: <20071207175754.GB19173@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>...
> thanks. I do get the impression that most of this can/should wait until 
> 2.6.25. The patches look quite dangerous.
..

I confess to not really trying hard to understand everything in this thread,
but the implication seems to be that this bug might affect udelay()
and possibly jiffies ?

If so, then fixing it has to be a *must* for 2.6.24, as otherwise we'll get
all sorts of one-in-while odd driver bugs.. like maybe these two for starters:

[Bug 9492] 2.6.24:  false double-clicks from USB mouse
[Bug 9489] 20000+ wake-ups/second in 2.6.24

Neither of which happens often enough to explain or debug,
but either of which *could* be caused by some weird jiffies thing maybe.

???
