Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbYLCKJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbYLCKJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYLCKI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:08:58 -0500
Received: from tim.rpsys.net ([194.106.48.114]:60163 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYLCKI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:08:57 -0500
Subject: Re: [PATCH 4/4] leds: Let GPIO LEDs keep their current state
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20081123123154.GB7310@ucw.cz>
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-4-git-send-email-tpiepho@freescale.com>
	 <1226933427.17109.15.camel@ted>
	 <Pine.LNX.4.64.0811201640570.11673@t2.domain.actdsltmp>
	 <20081123123154.GB7310@ucw.cz>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:04:24 +0000
Message-Id: <1228298664.9126.3.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 13:31 +0100, Pavel Machek wrote:
> On Thu 2008-11-20 17:05:56, Trent Piepho wrote:
> > On Mon, 17 Nov 2008, Richard Purdie wrote:
> > > On Fri, 2008-10-24 at 16:09 -0700, Trent Piepho wrote:
> > >> +	if (template->keep_state)
> > >> +		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
> > >> +	else
> > >> +		state = template->default_state;
> > >>
> > >>  		state = of_get_property(child, "default-state", NULL);
> > >>  		led.default_state = state && !strcmp(state, "on");
> > >> +		led.keep_state = state && !strcmp(state, "keep");
> > >>
> > >> +++ b/include/linux/leds.h
> > >> @@ -138,7 +138,8 @@ struct gpio_led {
> > >>  	const char *default_trigger;
> > >>  	unsigned 	gpio;
> > >>  	u8 		active_low;
> > >> -	u8		default_state;
> > >> +	u8		default_state;	/* 0 = off, 1 = on */
> > >> +	u8		keep_state; /* overrides default_state */
> > >>  };
> > >
> > > How about something simpler here, just make default state have three
> > > different values - "keep", "on" and "off"? I'm not keen on having two
> > > different state variables like this.
> > 
> > I thought of that, but it ends up being more complex.  Instead of just
> > using:
> > static const struct gpio_led myled = {
> >  	.name = "something",
> >  	.keep_state = 1,
> > }
> > 
> > You'd do something like this:
> >  	.default_state = LEDS_GPIO_DEFSTATE_KEEP,
> > 
> > Is that better?
> 
> Yes.

Yes, agreed, much better.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

