Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYHMJ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYHMJ5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYHMJ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:57:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56439 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYHMJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:57:02 -0400
Date: Wed, 13 Aug 2008 11:56:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] x86_64 UV: Use LED to indicate CPU is active
Message-ID: <20080813095643.GA27074@atrey.karlin.mff.cuni.cz>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005649.986660000@polaris-admin.engr.sgi.com> <20080811155318.GB4524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811155318.GB4524@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +/*
> > + * Illuminate "activity" LED when CPU is going "active",
> > + * extinguish when going "idle".
> > + */
> > +static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
> > +{
> > +	if (action == IDLE_START)
> > +		uv_set_led_bits(0, LED_CPU_ACTIVITY);
> > +
> > +	else if (action == IDLE_END)
> > +		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
> > +
> > +	return NOTIFY_OK;
> > +}
> > +
> > +static struct notifier_block uv_idle_notifier = {
> > +	.notifier_call = uv_idle,
> > +};
> >  
> > +/*
> > + * Initialize idle led callback function
> > + */
> > +static __init void uv_init_led_idle_display(void)
> > +{
> > +	/* initialize timer for activity monitor */
> > +	idle_notifier_register(&uv_idle_notifier);
> > +}
> 
> hm, i think this is a bad idea. While putting it into the go-to-idle 

Plus this really should not be uv-specific. We already have generic
triggers.

And you should really CC led maintainers!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
