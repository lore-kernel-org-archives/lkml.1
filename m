Return-Path: <linux-kernel-owner+w=401wt.eu-S1764087AbXIXQq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764087AbXIXQq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbXIXQgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:36:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762340AbXIXQg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:36:29 -0400
Date: Mon, 24 Sep 2007 18:35:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, dmitry.adamushko@gmail.com,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       containers@lists.osdl.org, kamezawa.hiroyu@jp.fujitsu.com,
       menage@google.com, efault@gmx.de
Subject: Re: [PATCH 1/5] Revert recent removal of set_curr_task()
Message-ID: <20070924163525.GA12745@elte.hu>
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924163653.GB10291@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924163653.GB10291@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> > (3) rework enqueue/dequeue_entity() to get rid of
> > sched_class::set_curr_task()
> 
> Dmitry/Ingo,
> 	I am sorry for not having reviewed this change properly, but I 
> think we need to revert this.

ah, i was wondering about that already. We can certainly skip that 
optimization.

> In theory its possible to solve these problems w/o reintroducing 
> set_curr_task(). I tried doing so, but found it clutters 
> dequeue_entity and enqueue_entity a lot and makes it less readable. It 
> will duplicate what put_prev_entity() and set_next_entity() are 
> supposed to do. Moreoever it is slightly inefficient to do all these 
> in dequeue_entity() if we consider that dequeue_entity can be called 
> on current task for other reasons as well (like when it is abt to 
> sleep or change its nice value).

yeah, it's not worth it. I'd go for keeping the code unified even if 
adds a few instructions runtime overhead, as i'd expect most distros to 
enable fair-group-scheduling by default in the future. (once all the 
containers infrastructure and tools has trickled down to them)

	Ingo
