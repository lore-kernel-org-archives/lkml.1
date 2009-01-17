Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbZAQQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbZAQQMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbZAQQMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:12:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762361AbZAQQMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:12:34 -0500
Date: Sat, 17 Jan 2009 17:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090117161222.GC31601@elte.hu>
References: <20090111144305.GA7154@elte.hu> <20090114121521.197dfc5e.akpm@linux-foundation.org> <1231964647.14825.59.camel@laptop> <20090116204049.f4d6ef1c.akpm@linux-foundation.org> <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232186054.6813.48.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Dunno about the IO bits, but..
>  
> The problem with the C++ testcases seems to be wake_up_all() plunking a 
> genuine thundering herd onto runqueues.  The sleeper fairness logic 
> places the entire herd left of min_vruntime, meaning N*sched_latency 
> pain for the poor sods who are setting the runqueue pace.

100 wakeup pairs that all run and ping-pong between each other?

That creates 200 tasks with an average system load of 100.0, on a 
dual-core system. Is that a fair representation of some real workload, or 
just an unrealistic "gee, look, given enough tasks running I can overload 
the system _this bad_" example?

	Ingo
