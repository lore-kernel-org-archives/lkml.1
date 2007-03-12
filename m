Return-Path: <linux-kernel-owner+w=401wt.eu-S1030326AbXCLPNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbXCLPNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXCLPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:13:11 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:2490 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030326AbXCLPNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:13:09 -0400
Date: Mon, 12 Mar 2007 16:11:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: bryan.wu@analog.com, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Message-Id: <20070312161109.749c6d69.khali@linux-fr.org>
In-Reply-To: <20070312155359.39020c80@dhcp-252-105.norway.atmel.com>
References: <200703091345.44744.david-b@pacbell.net>
	<11735324081261-git-send-email-hskinnemoen@atmel.com>
	<1173694079.6638.13.camel@roc-desktop>
	<20070312153457.60dafa0c@dhcp-252-105.norway.atmel.com>
	<20070312155359.39020c80@dhcp-252-105.norway.atmel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

On Mon, 12 Mar 2007 15:53:59 +0100, Haavard Skinnemoen wrote:
> On Mon, 12 Mar 2007 15:34:57 +0100
> Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > > > +	bit_data->udelay	= 5,			/* 100 kHz */
> > > > +	bit_data->timeout	= HZ / 10,		/* 100 ms */  
> > > 
> > > Can we add these udelay/timeout to struct i2c_gpio_platform_data? And
> > > let customer to choose these according their specific requirement. We
> > > use Kconfig to do this, but Jean and David don't like the idea, -:(  
> > 
> > Yeah, they need to be a bit more configurable than they currently are.
> > And I think it makes sense to pass them from the board setup code, since
> > this is where things depending on board-specific details (signal quality
> > issues, pullup resistor values, etc.) are supposed to go.
> 
> By the way, timeout seems to be hardcoded to 100 jiffies in the
> i2c-algo-bit driver, so there's probably not much point passing it from
> the board code when it's going to be overridden anyway. I'll add just a
> udelay parameter to the platform struct for  now.

No, it's not hardcoded. I know it looks confusing. struct i2c_adapter
has a timeout field, that's the one being set to 100 in i2c-algo-bit,
but i2c-algo-bit uses the i2c_algo_bit_data timeout field. The
i2c_adapter timeout field is unused.

This is clearly calling for a cleanup but I don't have time for this
right now.

-- 
Jean Delvare
