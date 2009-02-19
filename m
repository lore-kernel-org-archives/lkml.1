Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZBSLW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZBSLW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZBSLWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:22:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZBSLWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:22:17 -0500
Date: Thu, 19 Feb 2009 12:22:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mutex: enable spinning for DEBUG_MUTEX
Message-ID: <20090219112212.GQ2354@elte.hu>
References: <1234815510.30178.357.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234815510.30178.357.camel@laptop>
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

> Subject: mutex: enable spinning for DEBUG_MUTEX
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Thu, 15 Jan 2009 15:57:38 +0100
> 
> Spinning with CONFIG_DEBUG_MUTEX is possible but care must be taken
> with the debug checks vs. racy access to the lock owner field.
> 
> In the case where the lock owner gets rescheduled after acquisition
> and therefor unlocks on another CPU, that second CPU might not see the
> write of the owner field from the first CPU and we warn about owner
> mismatch.  Thus the memory barriers for the debug case.
> 
> Also remove the redundant mutex_set_owner()s in __mutex_lock_common()
> and __mutex_trylock_slowpath(), it's taken care of in mutex_lock() and
> mutex_trylock().
> 
> [a.p.zijlstra@chello.nl: fix _nested variants]
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/mutex-debug.c |    6 ++++++
>  kernel/mutex-debug.h |    6 ++++++
>  kernel/mutex.c       |   27 +++++++++++++++------------
>  3 files changed, 27 insertions(+), 12 deletions(-)

Applied to tip:core/locking, thanks Peter!

	Ingo
