Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYF1Aqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYF1Aqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYF1AqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:46:18 -0400
Received: from saeurebad.de ([85.214.36.134]:45257 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYF1AqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:46:17 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
References: <20080627000445.346130358@saeurebad.de>
	<20080627000805.504878592@saeurebad.de>
	<20080627120350.GB30872@elte.hu>
	<87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
	<20080627124329.GA14576@elte.hu>
	<87d4m3xbzq.fsf@skyscraper.fehenstaub.lan>
Date: Sat, 28 Jun 2008 02:45:42 +0200
In-Reply-To: <87d4m3xbzq.fsf@skyscraper.fehenstaub.lan> (Johannes Weiner's
	message of "Fri, 27 Jun 2008 15:07:21 +0200")
Message-ID: <87od5ms7yh.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Weiner <hannes@saeurebad.de> writes:

> From: Johannes Weiner <hannes@saeurebad.de>
> Subject: [PATCH 3/3] softlockup: wake up watchdog twice per threshold timespan
>
> Updating the timestamp more often is pointless as we print the warnings
> only if we exceed the threshold.  And the check for hung tasks relies on
> the last timestamp, so it will keep working correctly, too.
>
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>  kernel/softlockup.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -107,8 +107,11 @@ void softlockup_tick(void)
>  
>  	now = get_timestamp(this_cpu);
>  
> -	/* Wake up the high-prio watchdog task every second: */
> -	if (now > (touch_timestamp + 1))
> +	/*
> +	 * Wake up the high-prio watchdog task twice per
> +	 * threshold timespan.
> +	 */
> +	if (now > touch_timestamp + softlockup_thresh/2)
>  		wake_up_process(per_cpu(watchdog_task, this_cpu));

That defeats patch 1/3 and I think it can be dropped (#1).

	Hannes
