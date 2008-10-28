Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbYJ1Rpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbYJ1Rpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYJ1Rpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:45:35 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57639 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752699AbYJ1Rpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:45:34 -0400
Date: Tue, 28 Oct 2008 20:45:32 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/6 RFC] OF-glue devices for I2C/SPI   (was: Re: [PATCH
	4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022014243.GA19362@oksana.dev.rtsoft.ru> <1224642497.7654.319.camel@pasglop> <200810212122.49121.david-b@pacbell.net> <20081022103641.GB24757@oksana.dev.rtsoft.ru> <20081022104606.GA510@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081022104606.GA510@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:46:06PM +0400, Anton Vorontsov wrote:
[...]
> > > Like what I suggested:  "chip-aware OF glue drivers".  The relevant
> > > bus code being the "of_platform_bus_type" infrastructure.
> > > 
> > > Example:  instead of Anton's patch #6 modifying the existing pca953x
> > > driver, an of_pca953x driver that knows how to poke around in the OF
> > > device attributes to (a) create the pca953x_platform_data, (b) call
> > > i2c_register_board_info() to make that available later, and then
> > > finally (c) vanish, since it's not needed any longer.
> > 
> > Heh. You tell me my first approach:
> > 
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056730.html (mmc_spi)
> > 
> > The OF people didn't like the patch which was used to support this
> > approach:
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056728.html
> 
> Though, I think I'll able to persuade Grant that two registration paths
> are inevitable (i.e. for simple devices we should use
> drivers/of/of_{i2c,spi}.c and for complex cases we'll have to have
> another method of registration).

Ok, here it is.

I don't like this approach because:

1. It feels like an overhead to create an of_device for each i2c
   device that needs platform data.

2. We have to do ugly of_should_create_pdev() in the i2c code,
   and duplicate lists of supported devices.

Could anybody convince me that this isn't a big deal? ;-)

Otherwise I'll stick with this approach:
http://lkml.org/lkml/2008/10/22/471

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
