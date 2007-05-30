Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbXE3NE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbXE3NE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXE3NET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:04:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXE3NES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:04:18 -0400
Date: Wed, 30 May 2007 15:02:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530130237.GA19162@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465D43A0.8040307@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> >>You should pick up the kevent work :)
> >
> >3 months ago i verified the published kevent vs. epoll benchmark and 
> >found that benchmark to be fatally flawed. When i redid it properly 
> >kevent showed no significant advantage over epoll. Note that i did 
> >those measurements _before_ the recent round of epoll speedups. So 
> >unless someone does believable benchmarks i consider kevent an 
> >over-hyped, mis-benchmarked complication to do something that epoll 
> >is perfectly capable of doing.
> 
> You snipped the key part of my response, so I'll say it again:
> 
> Event rings (a) most closely match what is going on in the hardware 
> and (b) often closely match what is going on in multi-socket, 
> event-driven software application.

event rings are just pure data structures that describe a set of data, 
and they have advantages and disadvantages. For the record, we've 
already got direct experience with rings as software APIs: they were 
used for KAIO and they were an implementational and maintainance 
nightmare and nobody used them. Kevent might be better, but you make it 
sound as if it was a trivial design choice while it certainly isnt!

Sure, for hardware interfaces like networking cards tx and rx rings are 
the best thing but that is apples to oranges: hardware itself is about 
_limited_ physical resources, matching a _limited_ data structure like a 
ring quite well. But for software APIs, the built-in limit of rings 
makes it a baroque data structure that has a fair share disadvantages in 
addition to its obvious advantages.

> This is not something epoll is capable of doing, at the present time.

epoll is very much is capable of doing it - but why bother if something 
more flexible than a ring can be used and the performance difference is 
negligible? (Read my other reply in this thread for further points.)

but, for the record, syslets very much use a completion ring, so i'm not 
fundamentally opposed to the idea. I just think it's seriously 
over-hyped, just like most other bits of the kevent approach. (Nor do we 
have to attach this to syslets and threadlets - kevents are an 
orthogonal approach not directly related to asynchronous syscalls - 
syslets/threadlets can make use of epoll just as much as they can make 
use of kevent APIs.)

	Ingo
