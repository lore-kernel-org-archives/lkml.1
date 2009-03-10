Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCJJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCJJSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZCJJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:18:07 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38447 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZCJJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:18:06 -0400
Date: Tue, 10 Mar 2009 10:18:00 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-ID: <20090310091800.GC3263@buzzloop.caiaq.de>
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de> <20090309191419.98699220.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309191419.98699220.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 07:14:19PM -0700, Andrew Morton wrote:
> > --- a/drivers/w1/masters/w1-gpio.c
> > +++ b/drivers/w1/masters/w1-gpio.c
> > @@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
> >  {
> >  	struct w1_gpio_platform_data *pdata = data;
> >  
> > -	return gpio_get_value(pdata->pin);
> > +	return gpio_get_value(pdata->pin) ? 1 : 0;
> >  }
> >  
> >  static int __init w1_gpio_probe(struct platform_device *pdev)
> 
> We recently merged a patch (I forget where) which fixed one
> gpio_get_value() implementation so that it always returns 0 or 1.
> 
> From which I deduce that the correct fix for <whatever problem you're
> seeing> is to fix <whichever driver that is>?

I agree those functions should return 0 and 1 only, but my patch fixes
the w1-gpio driver for all platforms at once, so people can use it.

On the other hand, I will submit a patch which modifies PXA's
gpio_get_value() and see what the maintainers say, but I can't go thru
all the implemenations of all architectures to do this.

So for the time being, the above patch helps many users of that driver.

Daniel

