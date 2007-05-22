Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbXEVFFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbXEVFFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXEVFFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:05:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXEVFFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:05:32 -0400
Date: Tue, 22 May 2007 07:04:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>,
       Stable Team <stable@kernel.org>, Anant Nitya <kernel@prachanda.info>
Subject: Re: [PATCH] Prevent going idle with softirq pending
Message-ID: <20070522050410.GA9295@elte.hu>
References: <1179783264.12708.70.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179783264.12708.70.camel@chaos>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The NOHZ patch contains a check for softirqs pending when a CPU goes 
> idle. The BUG is unrelated to NOHZ, it just was made visible by the 
> NOHZ patch. The BUG showed up mainly on P4 / hyperthreading enabled 
> machines which lead the investigations into the wrong direction in the 
> first place. The real cause is in cond_resched_softirq():
> 
> cond_resched_softirq() is enabling softirqs without invoking the 
> softirq daemon when softirqs are pending. This leads to the warning 
> message in the NOHZ idle code:

good find!

>  		raw_local_irq_disable();
> -		_local_bh_enable();
> +		local_bh_enable();
>  		raw_local_irq_enable();

hm, i think this should be done without having irqs disabled?

	Ingo
