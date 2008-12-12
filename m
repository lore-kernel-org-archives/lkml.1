Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYLLG1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYLLG1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 01:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYLLG1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 01:27:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYLLG1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 01:27:38 -0500
Date: Fri, 12 Dec 2008 07:27:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] nohz: no softirq pending warnings for offline cpus
Message-ID: <20081212062723.GE12451@elte.hu>
References: <20081211160411.GC6264@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211160411.GC6264@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> After a cpu was taken down during cpu hotplug (read: disabled for interrupts)
> it still might have pending softirqs. However take_cpu_down makes sure
> that the idle task will run next instead of ksoftirqd on the taken down cpu.
> The idle task will call tick_nohz_stop_sched_tick which might warn about
> pending softirqs just before the cpu kills itself completely.
> However the pending softirqs on the dead cpu aren't a problem because they
> will be moved to an online cpu during CPU_DEAD handling.
> 
> So make sure we warn only for online cpus.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/time/tick-sched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/timers/nohz, thanks Heiko!

	Ingo
