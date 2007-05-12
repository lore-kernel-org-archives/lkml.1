Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXELPmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXELPmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXELPmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:42:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44240 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbXELPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:42:44 -0400
Date: Sat, 12 May 2007 17:42:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Message-ID: <20070512154217.GA20228@elte.hu>
References: <20070511131541.992688403@chello.nl> <Pine.LNX.4.64.0705121120210.26287@frodo.shire> <1178964103.6810.55.camel@twins> <Pine.LNX.4.64.0705121520210.2101@frodo.shire> <20070512143328.GA24803@elte.hu> <Pine.LNX.4.64.0705121721570.2101@frodo.shire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705121721570.2101@frodo.shire>
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


* Esben Nielsen <nielsen.esben@googlemail.com> wrote:

> Yeah, after sending that mail I realized I accepted this fact way 
> back... But I disagree in that it is easy to avoid not write-lcling 
> the mm semaphore: A simple malloc() might lead to a mmap() call 
> creating trouble. Am I right?

yeah - that's why "hard RT" apps generally either preallocate all memory 
in advance, or use special, deterministic allocators. And for "soft RT" 
it's all a matter of degree.

> > But mainline should not be bothered with this.
> 
> I disagree. You lay a large burdon on the users of PI futexes to avoid 
> write locking the mm semaphore. PI boosting those writers would be a 
> good idea even in the mainline.

only if it can be done without slowing down all the much more important 
uses of the MM semaphore.

> 1) How much slower would the pi_rw_mutex I suggested really be? As far 
> as I see there is only an overhead when there is congestion. I can not 
> see that that overhead is much larger than a non-PI boosting 
> implementation.

it could be measured, but it's certainly not going to be zero.

> 2) I know that execution time isn't bounded in the main-line - that is 
> why -rt is needed. But it is _that_ bad? How low can you get your 
> latencies with preemption on on a really busy machine?

on mainline? It can get arbitrarily large (read: seconds) in essence.

	Ingo
