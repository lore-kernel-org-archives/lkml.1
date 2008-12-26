Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYLZSjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYLZSjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYLZSi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:38:57 -0500
Received: from mx0.towertech.it ([213.215.222.73]:54583 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751333AbYLZSi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:38:57 -0500
Date: Fri, 26 Dec 2008 19:38:54 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
Subject: Re: [PATCH] AMD Geode CS553X GPIO driver
Message-ID: <20081226193854.41cbee89@i1501.lan.towertech.it>
In-Reply-To: <200812261024.07303.david-b@pacbell.net>
References: <20081224234321.0890274e@i1501.lan.towertech.it>
	<200812261024.07303.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 10:24:07 -0800
David Brownell <david-b@pacbell.net> wrote:

> >  It uses the gpio framework and the gpio api as defined in
> >  arch/x86/kernel/geode_32.c
> 
> Eventually I'd hope to see those geode_32.c calls just vanish.
> 
> In fact, the "normal" way to package these GPIOs would be to
> always provide them through the standard API, in arch/... code,
> with no Kconfig option.  Any reason you shouldn't do that in
> this patch?

 I didn't want to mess with something I did not wrote. Maybe a two steps
 approach can convince people to move on ;) (you remember what happened
 with people holding their old rtc code tight :) )

> > +comment "Other GPIO expanders:"
> 
> This counts as "memory mapped" I'd say.  Doesn't need
> a new category, even if this does need to live outside
> the relevant arch/... files.

 ok
 
> 
> > +
> > +config GPIO_CS553X
> > +	tristate "AMD CS5535/CS5536 Geode Companion Devices"
> > +	depends on MGEODE_LX && !CS5535_GPIO
> 
> What's this CS5535_GPIO stuff?  And why should it affect
> whether this can be configured?  (It's not in mainline...)

 drivers/char/cs5535_gpio.c (mainline)

> > +struct cs553x_gpio_platform_data {
> > +
> > +	unsigned	gpio_base; /* number of the first GPIO */
> > +
> > +	resource_size_t	io_base;
> 
> Platform devices should use platform_get_resource() and
> friends instead of passing resources through platform data.

 ack.
 
> 
> ... other than those points, this seems like a simple and
> straightforward GPIO driver.  Typical of what arch/* holds
> in such cases.  ;)

 :)

 will change it a little bit and resubmit

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

