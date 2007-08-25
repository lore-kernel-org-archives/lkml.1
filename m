Return-Path: <linux-kernel-owner+w=401wt.eu-S965083AbXHYUnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbXHYUnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934357AbXHYUnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:43:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844AbXHYUnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:43:23 -0400
Date: Sat, 25 Aug 2007 22:43:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull request] scheduler updates
Message-ID: <20070825204319.GA8772@elte.hu>
References: <20070824141215.GA24403@elte.hu> <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org> <20070824193758.GA6440@elte.hu> <20070825172319.GA2080@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825172319.GA2080@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> Find the shortlog further below. There are 3 commits in it: adaptive 
> granularity, a subsequent cleanup, and a lockdep sysctl bug Peter 
> noticed while hacking on this. (the bug was introduced with the 
> initial CFS commits but nobody noticed because the lockdep sysctls are 
> rarely used.)

hm, a small (and mostly harmless) buglet sneaked into it: the wakeup 
granularity and the runtime limit is now dependent on sched_latency - 
while it should be dependent on min_granularity and latency. To pick up 
that fix please pull from:

    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

(ontop of your very latest git tree)

the effect of this bug was too high wakeup latency that could cause 
audio skipping on small-audio-buffer setups. (didnt happen on mine, they 
have large enough buffers.)

	Ingo

------------------>
Ingo Molnar (1):
      sched: s/sched_latency/sched_min_granularity

 sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
