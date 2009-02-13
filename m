Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZBMMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZBMMFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZBMMFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:05:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53830 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZBMMFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:05:04 -0500
Date: Fri, 13 Feb 2009 13:04:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       L-K <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] timers: more consistently use clock vs timer
Message-ID: <20090213120430.GA5483@elte.hu>
References: <1234448191.10603.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234448191.10603.9.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: timers: more consistently use clock vs timer
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Feb 12 15:00:52 CET 2009
> 
> While reviewing the manpages, I noticed I'd missed some clock vs timer sites.
> 
> Make sure that all timer functions call cpu_timer_sample_group() and not
> cpu_clock_sample_group(). This ensures that we enable the process wide timer
> in time, and therefore pay the O(n) thread group cost from the syscall.
> 
> Not doing it here, will result in the first jiffy tick after setting the timer
> doing this, resulting in a very expensive tick (but only once) and a delay in
> actually starting the timer.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/posix-cpu-timers.c |   60 +++++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)

Applied to tip:timers/urgent, thanks Peter!

	Ingo
