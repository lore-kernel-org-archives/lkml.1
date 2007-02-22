Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXBVHvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXBVHvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXBVHvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:51:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXBVHvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:51:21 -0500
Date: Thu, 22 Feb 2007 08:46:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>, Ken Chen <kenneth.w.chen@intel.com>,
       balducci@units.it, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix posix-cpu-timer breakage caused by stale p->last_ran value
Message-ID: <20070222074624.GA9800@elte.hu>
References: <20070221104747.3cb0da32.akpm@linux-foundation.org> <1172104409.25076.165.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172104409.25076.165.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4699]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The problem is that the p->last_ran value is not updated after a 
> context switch. So a subsequent call to current_sched_time() 
> calculates with a stale p->last_ran value, i.e. accounts the full 
> time, which the task was scheduled away.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

>  	sched_info_switch(prev, next);
>  	if (likely(prev != next)) {
> -		next->timestamp = now;
> +		next->timestamp = next->last_ran = now;

ouch! nice catch. Also for v2.6.20.2 i think. 2.6.19 should be 
unaffected.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
