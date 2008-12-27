Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYL0Kxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYL0Kxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYL0Kxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:53:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46717 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYL0Kxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:53:46 -0500
Date: Sat, 27 Dec 2008 11:53:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while
	interrupt hanging
Message-ID: <20081227105334.GJ14639@elte.hu>
References: <494EEC60.4080708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494EEC60.4080708@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: avoid hanging on slow systems
> 
> While using the function graph tracer on a virtualized system, the 
> hrtimer_interrupt can hang the system on an infinite loop. This can be 
> caused on several situation where something intrusive is slowing the 
> system (ie: tracing) and the next clock events to program are always 
> before the current time. This patch implements a reasonable compromise. 
> If such a situation is detected, we share the CPUs time in 1/4 to 
> process the hrtimer interrupts. This is enough to let the system running 
> without serious starvation.
> 
> It has been successfully tested under VirtualBox with 1000 HZ and 100 HZ 
> with function graph tracer launched. On both cases, the clock events 
> were increased until about 25 ms periodic ticks, which means 40 HZ.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/hrtimer.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)

applied to tip/timers/hrtimers, thanks Frederic!

Thomas, any objections/observations?

	Ingo
