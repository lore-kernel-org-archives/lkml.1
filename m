Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXDUPq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXDUPq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXDUPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:46:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXDUPqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:46:55 -0400
Date: Sat, 21 Apr 2007 17:46:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421154614.GA26169@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421121235.GA2044@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> I promised to perform some tests on your code. I'm short in time right 
> now, but I observed behaviours that should be commented on.

thanks for the feedback!

> 3) CFS-v4
> 
>   Feels even better, mouse movements are very smooth even under high 
>   load. I noticed that X gets reniced to -19 with this scheduler. I've 
>   not looked at the code yet but this looked suspicious to me. I've 
>   reniced it to 0 and it did not change any behaviour. Still very 
>   good. The 64 ocbench share equal CPU time and show exact same 
>   progress after 2000 iterations. The CPU load is more smoothly spread 
>   according to vmstat, and there's no idle (see below). BUT I now 
>   think it was wrong to let new processes start with no timeslice at 
>   all, because it can take tens of seconds to start a new process when 
>   only 64 ocbench are there. [...]

ok, i'll modify that portion and add back the 50%/50% parent/child CPU 
time sharing approach again. (which CFS had in -v1) That should not 
change the rest of your test and should improve the task startup 
characteristics.

	Ingo
