Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYGPTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYGPTDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYGPTDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:03:47 -0400
Received: from www.tglx.de ([62.245.132.106]:56172 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbYGPTDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:03:46 -0400
Date: Wed, 16 Jul 2008 21:03:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Renninger <trenn@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <200807161827.16898.trenn@suse.de>
Message-ID: <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Thomas Renninger wrote:

> This is against Andi's (ak) release branch,
> hope that is ok...

No idea what that is.

> Can this one be reviewed/added, pls.

Reviewed yes. Added no.

>  kernel/time/tick-sched.c |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index b854a89..bda0164 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -589,6 +589,32 @@ static enum hrtimer_restart tick_sched_timer(struct 
> hrtimer *timer)
>  	return HRTIMER_RESTART;
>  }
>  
> +#if defined(CONFIG_X86) && defined(CONFIG_NO_HZ)
> +static __init int is_nohz_broken(void)
> +{

We definitely do not add x86 quirks into the generic code. 

Is there really no other way to fix this problem ? Which chipset is
involved here ? SB400/600 perhaps ?

Thanks,

	tglx


