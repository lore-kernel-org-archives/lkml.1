Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZECIbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZECIbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZECIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:30:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55306 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZECIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:30:52 -0400
Date: Sun, 3 May 2009 10:30:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [patch] remove put_cpu_no_resched() [ Resend ]
Message-ID: <20090503083027.GB27707@elte.hu>
References: <20090502202312.124351431@linutronix.de> <20090502202317.506137353@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502202317.506137353@linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Impact: remove a high latency source
> 
> put_cpu_no_resched() is an optimization of put_cpu() which
> unfortunately can cause high latencies.
> 
> The nfs iostats code uses put_cpu_no_resched() in a code sequence
> where a reschedule request caused by an interrupt between the
> get_cpu() and the put_cpu_no_resched() can delay the reschedule for at
> least HZ.
> 
> The other users of put_cpu_no_resched() optimize correctly in
> interrupt code, but there is no real harm in using the put_cpu()
> function which is an alias for preempt_enable(). The extra check of the
> preemmpt count is not as critical as the potential source of missing a
> reschedule.
> 
> Debugged in the preempt-rt tree and verified in mainline.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  arch/ia64/kernel/perfmon.c |    2 +-
>  fs/nfs/iostat.h            |    4 ++--
>  include/linux/smp.h        |    1 -
>  3 files changed, 3 insertions(+), 4 deletions(-)

Good catch!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
