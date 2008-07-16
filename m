Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbYGPTzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbYGPTzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYGPTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:54:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:42391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbYGPTyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:54:52 -0400
From: Thomas Renninger <trenn@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres enabled
Date: Wed, 16 Jul 2008 21:56:00 +0200
User-Agent: KMail/1.9.9
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807162156.00983.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 09:03:12 pm you wrote:
> On Wed, 16 Jul 2008, Thomas Renninger wrote:
> > This is against Andi's (ak) release branch,
> > hope that is ok...
>
> No idea what that is.
The branch Andi will merge his ACPI stuff into 2.6.27.
>
> > Can this one be reviewed/added, pls.
>
> Reviewed yes. Added no.
>
> >  kernel/time/tick-sched.c |   31 +++++++++++++++++++++++++++++++
> >  1 files changed, 31 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index b854a89..bda0164 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -589,6 +589,32 @@ static enum hrtimer_restart tick_sched_timer(struct
> > hrtimer *timer)
> >  	return HRTIMER_RESTART;
> >  }
> >
> > +#if defined(CONFIG_X86) && defined(CONFIG_NO_HZ)
> > +static __init int is_nohz_broken(void)
> > +{
>
> We definitely do not add x86 quirks into the generic code.
So the right solution (if nobody cares about this one) is to set 
tick_no_hz_enabled global and disable it through:
arch/x86/kernel/quirks.c
is that correct?
>
> Is there really no other way to fix this problem ?
I have no idea.
Richard's last message:
"I can help out as needed, just a work deadline I have to meet so I 
haven't been able to dig further.  Just point me in the direction and 
I'll gladly be someones hands on the beastly machine"

has silently be ignored.

> Which chipset is 
> involved here ? SB400/600 perhaps ?
No, it is probably much older and I am pretty sure that it is not chipset 
related, but related to the "Mobile" in the Mobile Sempron as this exactly 
seem to hit 3500 and 3600 Mobile Sempron CPUs.

I can't help much further because:
  - I have not such a machine
  - I don't know these parts. I hoped to get some hints to help these guys

       Thomas
