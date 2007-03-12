Return-Path: <linux-kernel-owner+w=401wt.eu-S1030193AbXCLOfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193AbXCLOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXCLOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:35:39 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63009 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030193AbXCLOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:35:38 -0400
Date: Mon, 12 Mar 2007 15:34:57 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: bryan.wu@analog.com
Cc: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070312153457.60dafa0c@dhcp-252-105.norway.atmel.com>
In-Reply-To: <1173694079.6638.13.camel@roc-desktop>
References: <200703091345.44744.david-b@pacbell.net>
	<11735324081261-git-send-email-hskinnemoen@atmel.com>
	<1173694079.6638.13.camel@roc-desktop>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 18:07:59 +0800
"Wu, Bryan" <bryan.wu@analog.com> wrote:
> >   static struct i2c_gpio_platform_data i2c_gpio_data = {
> > 	.sda_pin	= GPIO_PIN_FOO,
> > 	.scl_pin	= GPIO_PIN_BAR,
> >   };
> 
> Is this usage right, because 3 flags are added to this structure as
> below:
> 
> struct i2c_gpio_platform_data {
> 	unsigned int sda_pin;
> 	unsigned int scl_pin;
> 	unsigned int sda_is_open_drain:1;
> 	unsigned int scl_is_open_drain:1;
> 	unsigned int scl_is_output_only:1;
> };

Well, it is the simplest possible example. The last 3 fields will be 0,
which is a valid configuration.

> Thanks a lot,  I will drop our GPIO based I2C driver and try this one on
> our platform.

I hope it works for you.

> > +	if (!pdata->scl_is_output_only)
> > +		bit_data->getscl = i2c_gpio_getscl,
> > +
> > +	bit_data->getsda	= i2c_gpio_getsda,
> > +	bit_data->udelay	= 5,			/* 100 kHz */
> > +	bit_data->timeout	= HZ / 10,		/* 100 ms */
> 
> Can we add these udelay/timeout to struct i2c_gpio_platform_data? And
> let customer to choose these according their specific requirement. We
> use Kconfig to do this, but Jean and David don't like the idea, -:(

Yeah, they need to be a bit more configurable than they currently are.
And I think it makes sense to pass them from the board setup code, since
this is where things depending on board-specific details (signal quality
issues, pullup resistor values, etc.) are supposed to go.

Haavard
