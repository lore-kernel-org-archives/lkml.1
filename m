Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZBFOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZBFOh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZBFOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:37:05 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34003 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbZBFOhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:37:02 -0500
Date: Fri, 6 Feb 2009 15:36:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ben Greear <greearb@candelatech.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
In-Reply-To: <498B42C5.7010905@candelatech.com>
Message-ID: <alpine.LRH.1.10.0902061531560.22097@twin.jikos.cz>
References: <498B42C5.7010905@candelatech.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Ben Greear wrote:

> Allow user to force TSC as stable clock-source. Works around BIOS issues 
> in the FWA-7304 (Via CN700 chipset) system, and possibly others.

How do you know that the TSC is stable on such system? What was the reason 
for kernel marking it unstable?

> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index ca89e15..0578fcb 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
>  static DEFINE_SPINLOCK(clocksource_lock);
>  static char override_name[32];
>  static int finished_booting;
> +static int force_tsc_stable;
>  
>  /* clocksource_done_booting - Called near the end of core bootup
>   *
> @@ -82,6 +83,14 @@ static unsigned long watchdog_resumed;
>  #define WATCHDOG_INTERVAL (HZ >> 1)
>  #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
>  
> +static int __init parse_force_tsc_stable(char *arg)
> +{
> +	force_tsc_stable = 1;
> +	return 0;
> +}
> +early_param("force_tsc_stable", parse_force_tsc_stable);

Documentation/kernel-parameters.txt would also like to know about this 
option.

-- 
Jiri Kosina
SUSE Labs

