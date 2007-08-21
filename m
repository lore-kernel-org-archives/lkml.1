Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXHUK7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXHUK7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXHUK7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:59:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXHUK7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:59:09 -0400
Date: Tue, 21 Aug 2007 12:58:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070821105858.GC26598@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708121827.36656.a1426z@gawab.com> <20070812155242.GA1977@elte.hu> <200708122243.05191.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708122243.05191.a1426z@gawab.com>
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


* Al Boldi <a1426z@gawab.com> wrote:

> There is one workload that still isn't performing well; it's a 
> web-server workload that spawns 1K+ client procs.  It can be emulated 
> by using this:
> 
>   for i in `seq 1 to 3333`; do ping 10.1 -A > /dev/null & done

on bash i did this as:

  for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done

and this quickly creates a monster-runqueue with tons of ping tasks 
pending. (i replaced 10.1 with the IP of another box on the same LAN as 
the testbox) Is this what should happen?

> The problem is that consecutive runs don't give consistent results and 
> sometimes stalls.  You may want to try that.

well, there's a natural saturation point after a few hundred tasks 
(depending on your CPU's speed), at which point there's no idle time 
left. From that point on things get slower progressively (and the 
ability of the shell to start new ping tasks is impacted as well), but 
that's expected on an overloaded system, isnt it?

	Ingo
