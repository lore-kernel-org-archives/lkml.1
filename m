Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXCHR3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXCHR3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXCHR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:29:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXCHR3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:29:12 -0500
Date: Thu, 8 Mar 2007 18:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rfc][patch] futex: restartable futex_wait?
Message-ID: <20070308172902.GA16834@elte.hu>
References: <20070307153349.GA32404@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307153349.GA32404@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Hi Ingo,
> 
> I'm seeing an LTP test fail for ltp test sigaction_16_24. Basically, 
> it tests whether the SA_RESTART flag works for the sem_wait operation.
> 
> I see sem_wait is implemented with futex_wait, so I wonder whether we 
> can make it restartable? Am I going about it the right way? (Seems to 
> fix the testcase here).

i think that's quite right. I'm wondering why this never came up before? 
But your fix is not complete i think:

> +             restart->arg2 = time;
> +             return -ERESTART_RESTARTBLOCK;
> +     }

'time' here is relative, so the restarted syscall will do a /full/ wait 
again.

maybe we should rather convert futex timed-waits to hrtimers? Thomas?

	Ingo
