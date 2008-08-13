Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYHMJ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYHMJ5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYHMJ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:57:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYHMJ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:57:16 -0400
Date: Wed, 13 Aug 2008 11:57:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86_64 UV: Use blinking LED for heartbeat display
Message-ID: <20080813095715.GB27074@atrey.karlin.mff.cuni.cz>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005652.543469000@polaris-admin.engr.sgi.com> <20080811160235.GC4524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811160235.GC4524@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Mike Travis <travis@sgi.com> wrote:
> 
> > +#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
> > +static void uv_display_heartbeat(void)
> > +{
> > +	int cpu;
> > +
> > +	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
> > +
> > +	for_each_online_cpu(cpu) {
> > +		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
> > +
> > +		if (hub->led_heartbeat_count > 0) {
> > +			uv_set_led_bits_on(cpu, LED_CPU_BLINK,
> > +						LED_CPU_HEARTBEAT);
> > +			--hub->led_heartbeat_count;
> > +		}
> 
> this too is a bad idea. Imagine 16K cores and assume that each such 
> iteration takes a few usecs (we write cross CPU) and you've got a 
> GHz-ish CPU. That can easily be _milliseconds_ of delay (or more) - and 
> in a function (the clocksource watchdog) that is all about precise 
> timings.
> 
> It is also very non-preemptable.

LED subsystem already has nice heartbeat trigger.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
