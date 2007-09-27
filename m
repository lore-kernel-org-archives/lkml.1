Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbXI0GzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbXI0GzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXI0GzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:55:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXI0GzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:55:08 -0400
Date: Thu, 27 Sep 2007 08:54:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andr? Goddard Rosa <andre.goddard@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: sched-devel feedback
Message-ID: <20070927065447.GA28697@elte.hu>
References: <b8bf37780709261828m6f9f7318qe753d8b32055bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8bf37780709261828m6f9f7318qe753d8b32055bf@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andr? Goddard Rosa <andre.goddard@gmail.com> wrote:

> Hi, Ingo , Mike and Peter!
> 
>     Just passing around to say that 2.6.23-rc8-sched-dev is the best 
> scheduler ever to me. It's great for 3D games.

cool! :-)

>      http://www.openarena.ws/?files is really great with this 
> scheduler. I played a whole match without no slowdown, smooth playing 
> all the time. I had never played it before like this, it made a huge 
> difference to me. Even older CFS releases and -ck did not made it 
> sooooo smooth. It was really smooth _all_ the time.

i'm wondering, in previous schedulers, under what situations did you 
notice smoothness problems? Was the scenario in any way deterministic, 
or just random delays that are hard to describe?

Just in case you have smoothness problems in the future, a good way of 
measuring it objectively is to enable CONFIG_SCHED_DEBUG=y and 
CONFIG_SCHEDSTATS=y and to monitor the se.wait_max field in the 
/proc/PID/tasks/*/sched file[s].

Every time there's some ruckle or other smoothness problem, that field's 
value should increase. (a few milliseconds up to a few dozen 
milliseconds is fine normally - anything above 100 msecs is probably 
less fine.) By looking at that latency field you can compare two 
kernels. (And by echoing 0 to the sched file you can clear these stats.) 

So by saying "under .23-rc8 se.wait_max was 50 msecs while in .24-rc1 it 
increased to 250 msecs" everyone can effectively complain to us about 
smoothness problems :-)

>     The scheduler team did a really good work on this!
> 
> Thank you so much for this great work,

you are welcome!

	Ingo
