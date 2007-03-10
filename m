Return-Path: <linux-kernel-owner+w=401wt.eu-S1030178AbXCJJJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178AbXCJJJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030242AbXCJJJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:09:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030178AbXCJJJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:09:46 -0500
Date: Sat, 10 Mar 2007 10:09:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] futex: restartable futex_wait
Message-ID: <20070310090900.GA18250@elte.hu>
References: <20070310033753.GA13299@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310033753.GA13299@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> LTP test sigaction_16_24 fails, because it expects sem_wait to be 
> restarted if SA_RESTART is set. sem_wait is implemented with 
> futex_wait, that currently doesn't support being restarted. Ulrich 
> confirms that the call should be restartable.
> 
> Implement a restart_block method to handle the relative timeout, and 
> allow restarts.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

yeah:

  Acked-by: Ingo Molnar <mingo@elte.hu>

i was totally confused and thought this was the original argument:

> +		restart->arg2 = time;
> +		return -ERESTART_RESTARTBLOCK;

but it's indeed the 'new' relative timeout. (It can still be a tiny bit 
inaccurate because if there are many signals then the signals will delay 
the relative timeout - so absolute timeouts are still better - but your 
fix is correct and needed nevertheless)

	Ingo
