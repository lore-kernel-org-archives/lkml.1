Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZDUGf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZDUGf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZDUGfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:35:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZDUGfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:35:45 -0400
Date: Tue, 21 Apr 2009 08:35:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jon Hunter <jon-hunter@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
	more than 2.15 seconds
Message-ID: <20090421063523.GA8020@elte.hu>
References: <49ECE615.2010800@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECE615.2010800@ti.com>
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


* Jon Hunter <jon-hunter@ti.com> wrote:

> Hello,
>
> From reviewing the dynamic tick code, I noticed that the 
> "max_delta_ns" member of the "clock_event_device" structure, 
> represents the upper limit between timer events in nanoseconds. 
> The variable, "max_delta_ns", is defined as an unsigned long. An 
> unsigned long is a 32-bit integer for 32-bit machines and is a 
> 64-bit integer for 64-bit machines (if -m64 option is used for 
> gcc). Also see [1].
>
> The variable, "max_delta_ns", is configured by calling function 
> "clockevent_delta2ns()". The maximum value that "max_delta_ns" can 
> be set to by calling clockevent_delta2ns(), is LONG_MAX. For a 
> 32-bit machine LONG_MAX is equal to 0x7fffffff and in nanoseconds 
> this equates to ~2.15 seconds. Hence, the maximum sleep time for a 
> 32-bit machine is ~2.15 seconds, where as for a 64-bit machine it 
> will be many years.
>
> Therefore, I wanted to propose changing the type of max_delta_ns 
> to be "unsigned long long" instead of "unsigned long". My 
> understanding is that a variable of type "unsigned long long" is 
> 64-bits for both 32-bit and 64-bit machines and hence this would 
> allow a 32-bit machine to sleep for longer than ~2.15 seconds. 
> Please note that I also ended up making "min_delta_ns" of type 
> "unsigned long long" too and although this is probably very 
> unnecessary, it made the patch simpler. See below.
>
> Anyway, making this change has allowed my 32-bit machine to sleep 
> for longer than ~2.15 seconds and thought this could be of 
> interest to others. Your comments/feedback would be appreciated.
>
> [1] http://en.wikipedia.org/wiki/64-bit#64-bit_data_models
>
> Cheers
> Jon
>
>
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>
> ---
>  include/linux/clockchips.h |    6 +++---
>  kernel/hrtimer.c           |    2 +-
>  kernel/time/clockevents.c  |   10 +++++-----
>  kernel/time/tick-oneshot.c |    2 +-
>  kernel/time/timer_list.c   |    4 ++--
>  5 files changed, 12 insertions(+), 12 deletions(-)

Looks like a good thing at first sight. Thomas, John, what do you 
think?

	Ingo
